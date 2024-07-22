import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneybook/core/utils/number_formatter.dart';
import 'package:moneybook/features/bookings/presentation/widgets/cards/booking_card.dart';
import 'package:moneybook/features/bookings/presentation/widgets/cards/monthly_value_cards.dart';
import 'package:moneybook/shared/presentation/widgets/deco/empty_list.dart';

import '../../domain/entities/booking.dart';
import '../../domain/value_objects/booking_type.dart';
import '../bloc/booking_bloc.dart';
import '../widgets/deco/daily_report_summary.dart';

class BookingListPage extends StatefulWidget {
  DateTime selectedDate;

  BookingListPage({
    super.key,
    required this.selectedDate,
  });

  @override
  State<BookingListPage> createState() => _BookingListPageState();
}

class _BookingListPageState extends State<BookingListPage> {
  late DateTime _previousBookingDate;
  late DateTime _bookingDate;
  final Map<DateTime, double> _dailyIncomeMap = {};
  final Map<DateTime, double> _dailyExpenseMap = {};
  double _monthlyExpense = 0.0;
  double _monthlyIncome = 0.0;
  double _monthlyInvestment = 0.0;
  double _monthlyUnpaid = 0.0;
  int _numberOfBookedBookings = 0;
  bool _isExpanded = false;

  void _loadBookings(BuildContext context) {
    BlocProvider.of<BookingBloc>(context).add(
      LoadSortedMonthlyBookings(widget.selectedDate),
    );
  }

  void _calculateDailyValues(List<Booking> bookings) {
    _dailyIncomeMap.clear();
    _dailyExpenseMap.clear();
    for (int i = 0; i < bookings.length; i++) {
      if (_dailyIncomeMap.containsKey(bookings[i].date) == false) {
        _dailyIncomeMap[bookings[i].date] = 0.0;
        _dailyExpenseMap[bookings[i].date] = 0.0;
      }
      double? dailyAmount = 0.0;
      if (bookings[i].type == BookingType.income) {
        dailyAmount = _dailyIncomeMap[bookings[i].date];
        _dailyIncomeMap[bookings[i].date] = dailyAmount! + bookings[i].amount;
      } else if (bookings[i].type == BookingType.expense) {
        dailyAmount = _dailyExpenseMap[bookings[i].date];
        _dailyExpenseMap[bookings[i].date] = dailyAmount! + bookings[i].amount;
      }
    }
  }

  void _calculateMonthlyValues(List<Booking> bookings) {
    _monthlyExpense = 0.0;
    _monthlyIncome = 0.0;
    _monthlyInvestment = 0.0;
    _monthlyUnpaid = 0.0;
    for (int i = 0; i < bookings.length; i++) {
      if (bookings[i].type == BookingType.expense) {
        _monthlyExpense += bookings[i].amount;
      } else if (bookings[i].type == BookingType.income) {
        _monthlyIncome += bookings[i].amount;
      } else if (bookings[i].type == BookingType.investment) {
        _monthlyInvestment += bookings[i].amount;
      }
      if (bookings[i].date.isAfter(DateTime.now())) {
        _monthlyUnpaid += bookings[i].amount;
      }
    }
  }

  bool _isSameMonth() {
    return widget.selectedDate.year == DateTime.now().year && widget.selectedDate.month == DateTime.now().month;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          BlocBuilder<BookingBloc, BookingState>(
            builder: (context, state) {
              _loadBookings(context);
              if (state is Loaded) {
                _calculateMonthlyValues(state.bookings);
                if (state.bookings.isEmpty) {
                  return Expanded(
                    child: Column(
                      children: [
                        MonthlyValueCards(
                          bookings: state.bookings,
                          selectedDate: widget.selectedDate,
                          monthlyExpense: _monthlyExpense,
                          monthlyIncome: _monthlyIncome,
                          monthlyInvestment: _monthlyInvestment,
                        ),
                        const Expanded(
                          child: EmptyList(
                            text: 'Noch keine Buchungen vorhanden',
                            icon: Icons.receipt_long_rounded,
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  _calculateDailyValues(state.bookings);
                  _numberOfBookedBookings = 0;
                  return Expanded(
                    child: Column(
                      children: [
                        MonthlyValueCards(
                          bookings: state.bookings,
                          selectedDate: widget.selectedDate,
                          monthlyExpense: _monthlyExpense,
                          monthlyIncome: _monthlyIncome,
                          monthlyInvestment: _monthlyInvestment,
                        ),
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.bookings.length,
                            itemBuilder: (BuildContext context, int index) {
                              if (state.bookings[index].date.isBefore(DateTime.now())) {
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
                                        dailyIncome: _dailyIncomeMap[state.bookings[index].date],
                                        dailyExpense: _dailyExpenseMap[state.bookings[index].date],
                                      ),
                                      BookingCard(booking: state.bookings[index]),
                                    ],
                                  );
                                } else {
                                  return BookingCard(booking: state.bookings[index]);
                                }
                              }
                              if (_numberOfBookedBookings == 0 && index == state.bookings.length - 1) {
                                return SizedBox(
                                  height: MediaQuery.sizeOf(context).height / 1.5,
                                  child: const EmptyList(
                                    text: 'Noch keine Buchungen vorhanden',
                                    icon: Icons.receipt_long_rounded,
                                  ),
                                );
                              }
                              return const SizedBox();
                            },
                          ),
                        ),
                        widget.selectedDate.isAfter(DateTime.now()) || _isSameMonth()
                            ? Theme(
                                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                                child: ListTileTheme(
                                  dense: true,
                                  child: ExpansionTile(
                                    title: Text(
                                      '${formatToMoneyAmount(_monthlyUnpaid.toString())} Ausstehend',
                                      style: TextStyle(color: _isExpanded ? Colors.white : Colors.grey, fontSize: _isExpanded ? 15.0 : 13.0),
                                    ),
                                    iconColor: Colors.cyanAccent,
                                    backgroundColor: ThemeData.dark().scaffoldBackgroundColor,
                                    onExpansionChanged: (bool expanded) {
                                      setState(() {
                                        _isExpanded = expanded;
                                      });
                                    },
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(bottom: 4.0),
                                        child: Divider(indent: 12.0, endIndent: 12.0, height: 2.0),
                                      ),
                                      SizedBox(
                                        height: MediaQuery.sizeOf(context).height / 2.5,
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: state.bookings.length,
                                          itemBuilder: (BuildContext context, int index) {
                                            if (state.bookings[index].date.isAfter(DateTime.now())) {
                                              if (index > 0) {
                                                _previousBookingDate = state.bookings[index - 1].date;
                                                _bookingDate = state.bookings[index].date;
                                              }
                                              if (index == 0 || _previousBookingDate != _bookingDate) {
                                                return Column(
                                                  children: [
                                                    DailyReportSummary(
                                                      date: state.bookings[index].date,
                                                      dailyIncome: _dailyIncomeMap[state.bookings[index].date],
                                                      dailyExpense: _dailyExpenseMap[state.bookings[index].date],
                                                    ),
                                                    BookingCard(booking: state.bookings[index]),
                                                  ],
                                                );
                                              } else {
                                                return BookingCard(booking: state.bookings[index]);
                                              }
                                            }
                                            return const SizedBox();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  );
                }
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }
}
