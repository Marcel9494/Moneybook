import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:moneybook/core/consts/common_consts.dart';
import 'package:moneybook/features/bookings/presentation/widgets/cards/booking_card.dart';
import 'package:moneybook/features/bookings/presentation/widgets/cards/monthly_value_cards.dart';
import 'package:moneybook/shared/presentation/widgets/deco/empty_list.dart';

import '../../domain/entities/booking.dart';
import '../../domain/value_objects/amount_type.dart';
import '../../domain/value_objects/booking_type.dart';
import '../bloc/booking_bloc.dart';
import '../widgets/cards/pending_monthly_value_cards.dart';
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
  final List<Booking> _dependingBookings = [];
  double _monthlyExpense = 0.0;
  double _monthlyIncome = 0.0;
  double _monthlyInvestmentBuys = 0.0;
  double _monthlyInvestmentSales = 0.0;
  double _monthlyDependingExpense = 0.0;
  double _monthlyDependingIncome = 0.0;
  double _monthlyDependingInvestmentBuys = 0.0;
  double _monthlyDependingInvestmentSales = 0.0;
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
    _monthlyInvestmentBuys = 0.0;
    _monthlyInvestmentSales = 0.0;
    _monthlyDependingExpense = 0.0;
    _monthlyDependingIncome = 0.0;
    _monthlyDependingInvestmentBuys = 0.0;
    _monthlyDependingInvestmentSales = 0.0;
    _dependingBookings.clear();
    for (int i = 0; i < bookings.length; i++) {
      if (bookings[i].date.isAfter(DateTime.now()) == false) {
        if (bookings[i].type == BookingType.expense) {
          _monthlyExpense += bookings[i].amount;
        } else if (bookings[i].type == BookingType.income) {
          _monthlyIncome += bookings[i].amount;
        } else if (bookings[i].type == BookingType.investment) {
          if (bookings[i].amountType == AmountType.buy) {
            _monthlyInvestmentBuys += bookings[i].amount;
          } else if (bookings[i].amountType == AmountType.sale) {
            _monthlyInvestmentSales += bookings[i].amount;
          }
        }
      } else if (bookings[i].date.isAfter(DateTime.now())) {
        _dependingBookings.add(bookings[i]);
        if (bookings[i].type == BookingType.expense) {
          _monthlyDependingExpense += bookings[i].amount;
        } else if (bookings[i].type == BookingType.income) {
          _monthlyDependingIncome += bookings[i].amount;
        } else if (bookings[i].type == BookingType.investment) {
          if (bookings[i].amountType == AmountType.buy) {
            _monthlyDependingInvestmentBuys += bookings[i].amount;
          } else if (bookings[i].amountType == AmountType.sale) {
            _monthlyDependingInvestmentSales += bookings[i].amount;
          }
        }
      }
      _dependingBookings.sort((first, second) => first.date.compareTo(second.date));
    }
  }

  @override
  Widget build(BuildContext context) {
    _loadBookings(context);
    return Scaffold(
      body: Column(
        children: [
          BlocBuilder<BookingBloc, BookingState>(
            builder: (context, state) {
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
                          monthlyInvestmentBuys: _monthlyInvestmentBuys,
                          monthlyInvestmentSales: _monthlyInvestmentSales,
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.0),
                            child: EmptyList(
                              text: 'Noch keine Buchungen\nfür ${DateFormat.yMMMM(locale).format(widget.selectedDate)} vorhanden',
                              icon: Icons.receipt_long_rounded,
                            ),
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
                          monthlyInvestmentBuys: _monthlyInvestmentBuys,
                          monthlyInvestmentSales: _monthlyInvestmentSales,
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
                                        leftValue: _dailyIncomeMap[state.bookings[index].date],
                                        rightValue: _dailyExpenseMap[state.bookings[index].date],
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
                                  child: EmptyList(
                                    text: 'Noch keine Buchungen\nfür ${DateFormat.yMMMM(locale).format(widget.selectedDate)} vorhanden',
                                    icon: Icons.receipt_long_rounded,
                                  ),
                                );
                              }
                              return const SizedBox();
                            },
                          ),
                        ),
                        Theme(
                          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                          child: ListTileTheme(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    color: _isExpanded ? Colors.transparent : Colors.grey,
                                    width: 0.6,
                                  ),
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8.0),
                                  topRight: Radius.circular(8.0),
                                ),
                              ),
                              child: ExpansionTile(
                                dense: true,
                                title: Text(
                                  _isExpanded
                                      ? _dependingBookings.length == 1
                                          ? '1 Ausstehende Buchung:'
                                          : '${_dependingBookings.length} Ausstehende Buchungen:'
                                      : '${_dependingBookings.length} Ausstehende',
                                  style: TextStyle(color: _isExpanded ? Colors.white : Colors.grey, fontSize: _isExpanded ? 14.5 : 13.0),
                                ),
                                iconColor: _isExpanded ? Colors.white : Colors.grey,
                                backgroundColor: ThemeData.dark().scaffoldBackgroundColor,
                                onExpansionChanged: (bool expanded) {
                                  setState(() {
                                    _isExpanded = expanded;
                                  });
                                },
                                children: [
                                  PendingMonthlyValueCards(
                                    monthlyDependingExpense: _monthlyDependingExpense,
                                    monthlyDependingIncome: _monthlyDependingIncome,
                                    monthlyDependingInvestmentBuys: _monthlyDependingInvestmentBuys,
                                    monthlyDependingInvestmentSales: _monthlyDependingInvestmentSales,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(top: 8.0, bottom: 4.0),
                                    child: Divider(indent: 12.0, endIndent: 12.0, height: 2.0),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.sizeOf(context).height / 2.3,
                                    child: _dependingBookings.isEmpty
                                        ? EmptyList(
                                            text:
                                                'Keine ausstehenden Buchungen\nfür ${DateFormat.yMMMM(locale).format(widget.selectedDate)} vorhanden',
                                            icon: Icons.receipt_long_rounded,
                                          )
                                        : ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: _dependingBookings.length,
                                            itemBuilder: (BuildContext context, int index) {
                                              if (_dependingBookings[index].date.isAfter(DateTime.now())) {
                                                if (index > 0) {
                                                  _previousBookingDate = _dependingBookings[index - 1].date;
                                                  _bookingDate = _dependingBookings[index].date;
                                                }
                                                if (index == 0 || _previousBookingDate != _bookingDate) {
                                                  return Column(
                                                    children: [
                                                      DailyReportSummary(
                                                        date: _dependingBookings[index].date,
                                                        leftValue: _dailyIncomeMap[_dependingBookings[index].date],
                                                        rightValue: _dailyExpenseMap[_dependingBookings[index].date],
                                                      ),
                                                      BookingCard(booking: _dependingBookings[index]),
                                                    ],
                                                  );
                                                } else {
                                                  return BookingCard(booking: _dependingBookings[index]);
                                                }
                                              }
                                              return const SizedBox();
                                            },
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              } else if (state is SerieLoaded) {
                // Der Status SerieLoaded kommt vom edit_booking_page.dart zurück,
                // wenn eine Serienbuchung bearbeitet werden sollte aber der Benutzer
                // über den Back Button die Bearbeitung abgebrochen hat. In diesem Fall
                // muss die Buchungsliste nochmals neu geladen werden, damit auch der Status
                // auf Loaded gesetzt wird und die Buchungsliste wieder richtig angezeigt wird.
                _loadBookings(context);
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }
}
