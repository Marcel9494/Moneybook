import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneybook/features/bookings/presentation/widgets/cards/booking_card.dart';

import '../../../../core/consts/route_consts.dart';
import '../../../../core/utils/app_localizations.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../shared/presentation/widgets/arguments/bottom_nav_bar_arguments.dart';
import '../../../../shared/presentation/widgets/deco/empty_list.dart';
import '../../../bookings/domain/entities/booking.dart';
import '../../../bookings/domain/value_objects/amount_type.dart';
import '../../../bookings/domain/value_objects/booking_type.dart';
import '../../../bookings/presentation/bloc/booking_bloc.dart';
import '../../../bookings/presentation/widgets/buttons/month_picker_buttons.dart';
import '../../../bookings/presentation/widgets/deco/daily_report_summary.dart';
import '../widgets/charts/categorie_bar_chart.dart';

class CategorieStatisticPage extends StatefulWidget {
  final String categorie;
  final BookingType bookingType;
  DateTime selectedDate;
  final AmountType amountType;

  CategorieStatisticPage({
    super.key,
    required this.categorie,
    required this.bookingType,
    required this.selectedDate,
    required this.amountType,
  });

  @override
  State<CategorieStatisticPage> createState() => _CategorieStatisticPageState();
}

class _CategorieStatisticPageState extends State<CategorieStatisticPage> {
  late DateTime _previousBookingDate;
  late DateTime _bookingDate;
  final Map<DateTime, double> _dailyLeftValuesMap = {};
  final Map<DateTime, double> _dailyRightValuesMap = {};
  int _numberOfBookedBookings = 0;

  void _loadCategorieBookings(BuildContext context) {
    _numberOfBookedBookings = 0;
    BlocProvider.of<BookingBloc>(context).add(
      LoadPastMonthlyCategorieBookings(widget.categorie, widget.bookingType, widget.selectedDate, 7),
    );
  }

  Future<bool> _onBackButtonPressed() async {
    BlocProvider.of<BookingBloc>(context).add(
      LoadSortedMonthlyBookings(widget.selectedDate),
    );
    // Delay navigation to the next event loop tick
    Future.microtask(() {
      Navigator.pushNamedAndRemoveUntil(
          context,
          bottomNavBarRoute,
          arguments: BottomNavBarArguments(
            tabIndex: 2,
            selectedDate: widget.selectedDate,
            bookingType: widget.bookingType,
            amountType: widget.amountType,
          ),
          (route) => false);
    });
    return true;
  }

  void _calculateDailyValues(List<Booking> bookings) {
    _dailyLeftValuesMap.clear();
    _dailyRightValuesMap.clear();
    for (int i = 0; i < bookings.length; i++) {
      if (_dailyLeftValuesMap.containsKey(bookings[i].date) == false) {
        _dailyLeftValuesMap[bookings[i].date] = 0.0;
        _dailyRightValuesMap[bookings[i].date] = 0.0;
      }
      double? dailyAmount = 0.0;
      if (bookings[i].type == BookingType.income) {
        dailyAmount = _dailyLeftValuesMap[bookings[i].date];
        _dailyLeftValuesMap[bookings[i].date] = dailyAmount! + bookings[i].amount;
      } else if (bookings[i].type == BookingType.expense) {
        dailyAmount = _dailyRightValuesMap[bookings[i].date];
        _dailyRightValuesMap[bookings[i].date] = dailyAmount! + bookings[i].amount;
      } else if (bookings[i].type == BookingType.investment) {
        if (bookings[i].amountType.name == AmountType.buy.name) {
          dailyAmount = _dailyLeftValuesMap[bookings[i].date];
          _dailyLeftValuesMap[bookings[i].date] = dailyAmount! + bookings[i].amount;
        } else if (bookings[i].amountType.name == AmountType.sale.name) {
          dailyAmount = _dailyRightValuesMap[bookings[i].date];
          _dailyRightValuesMap[bookings[i].date] = dailyAmount! + bookings[i].amount;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _loadCategorieBookings(context);
    return PopScope(
      onPopInvoked: (_) => _onBackButtonPressed(),
      child: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          if (state is CategorieBookingsLoaded) {
            _calculateDailyValues(state.bookings);
            return Scaffold(
              appBar: AppBar(
                title: Text(AppLocalizations.of(context).translate(widget.categorie)),
                actions: [
                  MonthPickerButtons(
                    selectedDate: widget.selectedDate,
                    selectedDateCallback: (DateTime newDate) {
                      setState(() {
                        widget.selectedDate = newDate;
                      });
                    },
                  )
                ],
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CategorieBarChart(
                    bookings: state.bookings,
                    bookingType: widget.bookingType,
                    selectedDate: widget.selectedDate,
                    amountType: widget.amountType,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(18.0, 0.0, 12.0, 4.0),
                    child: Text(
                      '${DateFormatter.dateFormatMMMM(widget.selectedDate, context)} ${AppLocalizations.of(context).translate('buchungen')}',
                      style: const TextStyle(fontSize: 21.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.bookings.length,
                      itemBuilder: (BuildContext context, int index) {
                        int lastday = DateTime(widget.selectedDate.year, widget.selectedDate.month + 1, 0).day;
                        DateTime startDate = DateTime(widget.selectedDate.year, widget.selectedDate.month, 1);
                        DateTime endDate = DateTime(widget.selectedDate.year, widget.selectedDate.month, lastday + 1);
                        DateTime bookingDate = state.bookings[index].date;
                        if (bookingDate.isAfter(startDate) && bookingDate.isBefore(endDate) || bookingDate.isAtSameMomentAs(startDate)) {
                          _numberOfBookedBookings++;
                          if (index > 0) {
                            _previousBookingDate = state.bookings[index - 1].date;
                            _bookingDate = state.bookings[index].date;
                          }
                          if (index == 0 || _previousBookingDate != _bookingDate) {
                            return Column(
                              children: [
                                DailyReportSummary(
                                  date: state.bookings[index].date,
                                  leftValue:
                                      state.bookings[index].type == BookingType.investment ? 0.0 : _dailyLeftValuesMap[state.bookings[index].date],
                                  rightValue:
                                      state.bookings[index].type == BookingType.investment ? 0.0 : _dailyRightValuesMap[state.bookings[index].date],
                                ),
                                BookingCard(booking: state.bookings[index], activateEditing: false),
                              ],
                            );
                          } else {
                            return BookingCard(booking: state.bookings[index], activateEditing: false);
                          }
                        }
                        if (_numberOfBookedBookings == 0 && index == state.bookings.length - 1) {
                          return Column(
                            children: [
                              const SizedBox(height: 100.0),
                              EmptyList(
                                text: AppLocalizations.of(context).translate('noch_keine_buchungen_für') +
                                    '\n${DateFormatter.dateFormatYMMMM(widget.selectedDate, context)} ' +
                                    AppLocalizations.of(context).translate('vorhanden'),
                                icon: Icons.receipt_long_rounded,
                              ),
                            ],
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
