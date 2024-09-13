import 'package:flutter/material.dart';
import 'package:moneybook/features/bookings/presentation/widgets/cards/monthly_card.dart';

import '../../../domain/entities/booking.dart';

class MonthlyValueCards extends StatefulWidget {
  final List<Booking> bookings;
  final DateTime selectedDate;
  final double monthlyExpense;
  final double monthlyIncome;
  final double monthlyInvestment;

  const MonthlyValueCards({
    super.key,
    required this.bookings,
    required this.selectedDate,
    required this.monthlyExpense,
    required this.monthlyIncome,
    required this.monthlyInvestment,
  });

  @override
  State<MonthlyValueCards> createState() => _MonthlyValueCardsState();
}

class _MonthlyValueCardsState extends State<MonthlyValueCards> {
  int numberOfDays = 0;

  @override
  void initState() {
    super.initState();
    numberOfDays = DateTime(widget.selectedDate.year, widget.selectedDate.month, 0).day;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 92.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          MonthlyCard(
            title: 'Einnahmen',
            monthlyValue: widget.monthlyIncome,
            dailyAverageValue: widget.monthlyIncome / numberOfDays,
            textColor: Colors.greenAccent,
          ),
          MonthlyCard(
            title: 'Ausgaben',
            monthlyValue: widget.monthlyExpense,
            dailyAverageValue: widget.monthlyExpense / numberOfDays,
            textColor: Colors.redAccent,
          ),
          MonthlyCard(
            title: 'Saldo',
            monthlyValue: widget.monthlyIncome - widget.monthlyExpense,
            dailyAverageValue: (widget.monthlyIncome - widget.monthlyExpense) / numberOfDays,
            textColor: widget.monthlyIncome - widget.monthlyExpense >= 0.0 ? Colors.greenAccent : Colors.redAccent,
          ),
          MonthlyCard(
            title: 'Investment',
            monthlyValue: widget.monthlyInvestment,
            dailyAverageValue: widget.monthlyInvestment / numberOfDays,
            textColor: Colors.cyanAccent,
          ),
          MonthlyCard(
            title: 'Verfügbar',
            monthlyValue: widget.monthlyIncome - widget.monthlyExpense - widget.monthlyInvestment,
            dailyAverageValue: (widget.monthlyIncome - widget.monthlyExpense - widget.monthlyInvestment) / numberOfDays,
            textColor: widget.monthlyIncome - widget.monthlyExpense - widget.monthlyInvestment >= 0.0 ? Colors.greenAccent : Colors.redAccent,
          ),
        ],
      ),
    );
  }
}
