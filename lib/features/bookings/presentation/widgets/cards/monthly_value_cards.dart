import 'package:flutter/material.dart';
import 'package:moneybook/features/bookings/presentation/widgets/cards/monthly_card.dart';

import '../../../domain/entities/booking.dart';
import '../../../domain/value_objects/booking_type.dart';

class MonthlyValueCards extends StatefulWidget {
  final List<Booking> bookings;
  final DateTime selectedDate;

  const MonthlyValueCards({
    super.key,
    required this.bookings,
    required this.selectedDate,
  });

  @override
  State<MonthlyValueCards> createState() => _MonthlyValueCardsState();
}

class _MonthlyValueCardsState extends State<MonthlyValueCards> {
  double monthlyExpense = 0.0;
  double monthlyIncome = 0.0;
  double monthlyInvestment = 0.0;
  double dailyAverageExpense = 0.0;
  double dailyAverageIncome = 0.0;
  double dailyAverageInvestment = 0.0;

  @override
  void initState() {
    super.initState();
    _calculateMonthlyValues(widget.bookings);
  }

  void _calculateMonthlyValues(List<Booking> bookings) {
    monthlyExpense = 0.0;
    monthlyIncome = 0.0;
    monthlyInvestment = 0.0;
    for (int i = 0; i < bookings.length; i++) {
      if (bookings[i].type == BookingType.expense) {
        monthlyExpense += bookings[i].amount;
      } else if (bookings[i].type == BookingType.income) {
        monthlyIncome += bookings[i].amount;
      } else if (bookings[i].type == BookingType.investment) {
        monthlyInvestment += bookings[i].amount;
      }
    }
    dailyAverageExpense = monthlyExpense / DateTime(widget.selectedDate.year, widget.selectedDate.month, 0).day;
    dailyAverageIncome = monthlyIncome / DateTime(widget.selectedDate.year, widget.selectedDate.month, 0).day;
    dailyAverageInvestment = monthlyInvestment / DateTime(widget.selectedDate.year, widget.selectedDate.month, 0).day;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 86.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          MonthlyCard(
            title: 'Einnahmen:',
            monthlyValue: monthlyExpense,
            dailyAverageValue: dailyAverageExpense,
          ),
          MonthlyCard(
            title: 'Ausgaben:',
            monthlyValue: monthlyIncome,
            dailyAverageValue: dailyAverageIncome,
          ),
          MonthlyCard(
            title: 'Saldo:',
            monthlyValue: monthlyIncome - monthlyExpense,
            dailyAverageValue: dailyAverageIncome - dailyAverageExpense,
          ),
          MonthlyCard(
            title: 'Investment:',
            monthlyValue: monthlyInvestment,
            dailyAverageValue: dailyAverageInvestment,
          ),
          MonthlyCard(
            title: 'Verfügbar:',
            monthlyValue: monthlyIncome - monthlyExpense - monthlyInvestment,
            dailyAverageValue: dailyAverageIncome - dailyAverageExpense - dailyAverageInvestment,
          ),
        ],
      ),
    );
  }
}
