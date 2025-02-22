import 'package:flutter/material.dart';
import 'package:moneybook/features/bookings/presentation/widgets/cards/monthly_card.dart';

import '../../../../../core/utils/app_localizations.dart';
import '../../../domain/entities/booking.dart';

class MonthlyValueCards extends StatefulWidget {
  final List<Booking> bookings;
  final DateTime selectedDate;
  final double monthlyExpense;
  final double monthlyIncome;
  final double monthlyInvestmentBuys;
  final double monthlyInvestmentSales;

  const MonthlyValueCards({
    super.key,
    required this.bookings,
    required this.selectedDate,
    required this.monthlyExpense,
    required this.monthlyIncome,
    required this.monthlyInvestmentBuys,
    required this.monthlyInvestmentSales,
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
      height: 86.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          MonthlyCard(
            title: AppLocalizations.of(context).translate('income'),
            monthlyValue: widget.monthlyIncome,
            dailyAverageValue: widget.monthlyIncome / numberOfDays,
            textColor: Colors.greenAccent,
          ),
          MonthlyCard(
            title: AppLocalizations.of(context).translate('expenses'),
            monthlyValue: widget.monthlyExpense,
            dailyAverageValue: widget.monthlyExpense / numberOfDays,
            textColor: Colors.redAccent,
          ),
          MonthlyCard(
            title: AppLocalizations.of(context).translate('balance'),
            monthlyValue: widget.monthlyIncome - widget.monthlyExpense,
            dailyAverageValue: (widget.monthlyIncome - widget.monthlyExpense) / numberOfDays,
            textColor: widget.monthlyIncome - widget.monthlyExpense >= 0.0 ? Colors.greenAccent : Colors.redAccent,
          ),
          MonthlyCard(
            title: AppLocalizations.of(context).translate('purchases'),
            monthlyValue: widget.monthlyInvestmentBuys,
            dailyAverageValue: widget.monthlyInvestmentBuys / numberOfDays,
            textColor: Colors.cyanAccent,
          ),
          MonthlyCard(
            title: AppLocalizations.of(context).translate('sales'),
            monthlyValue: widget.monthlyInvestmentSales,
            dailyAverageValue: widget.monthlyInvestmentSales / numberOfDays,
            textColor: Colors.cyanAccent,
          ),
          MonthlyCard(
            title: AppLocalizations.of(context).translate('difference'),
            monthlyValue: widget.monthlyInvestmentBuys - widget.monthlyInvestmentSales,
            dailyAverageValue: (widget.monthlyInvestmentBuys - widget.monthlyInvestmentSales) / numberOfDays,
            textColor: widget.monthlyInvestmentBuys - widget.monthlyInvestmentSales >= 0.0 ? Colors.greenAccent : Colors.redAccent,
            showInfo: true,
          ),
        ],
      ),
    );
  }
}
