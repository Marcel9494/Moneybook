import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneybook/features/bookings/presentation/widgets/cards/booking_card.dart';
import 'package:moneybook/shared/presentation/widgets/deco/empty_list.dart';

import '../../domain/entities/booking.dart';
import '../../domain/value_objects/booking_type.dart';
import '../bloc/booking_bloc.dart';
import '../widgets/buttons/month_picker_buttons.dart';
import '../widgets/deco/daily_report_summary.dart';

class BookingListPage extends StatefulWidget {
  const BookingListPage({super.key});

  @override
  State<BookingListPage> createState() => _BookingListPageState();
}

class _BookingListPageState extends State<BookingListPage> {
  late DateTime previousBookingDate;
  late DateTime bookingDate;
  late DateTime selectedDate = DateTime.now();
  final Map<DateTime, double> _dailyIncomeMap = {};
  final Map<DateTime, double> _dailyExpenseMap = {};

  void loadBookings(BuildContext context) {
    BlocProvider.of<BookingBloc>(context).add(
      LoadSortedMonthlyBookings(selectedDate),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          MonthPickerButtons(
            selectedDate: selectedDate,
            selectedDateCallback: (DateTime newDate) {
              setState(() {
                selectedDate = newDate;
              });
            },
          ),
          BlocBuilder<BookingBloc, BookingState>(
            builder: (context, state) {
              loadBookings(context);
              if (state is Loaded) {
                if (state.bookings.isEmpty) {
                  return const Expanded(
                    child: EmptyList(
                      text: 'Noch keine Buchungen vorhanden',
                      icon: Icons.receipt_long_rounded,
                    ),
                  );
                } else {
                  _calculateDailyValues(state.bookings);
                  return Expanded(
                    child: ListView.builder(
                      itemCount: state.bookings.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (index > 0) {
                          previousBookingDate = state.bookings[index - 1].date;
                          bookingDate = state.bookings[index].date;
                        }
                        if (index == 0 || previousBookingDate != bookingDate) {
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
                      },
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
