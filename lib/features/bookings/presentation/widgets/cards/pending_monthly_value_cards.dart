import 'package:flutter/material.dart';
import 'package:moneybook/features/bookings/presentation/widgets/cards/pending_monthly_card.dart';

class PendingMonthlyValueCards extends StatefulWidget {
  final double monthlyDependingExpense;
  final double monthlyDependingIncome;
  final double monthlyDependingInvestment;

  const PendingMonthlyValueCards({
    super.key,
    required this.monthlyDependingExpense,
    required this.monthlyDependingIncome,
    required this.monthlyDependingInvestment,
  });

  @override
  State<PendingMonthlyValueCards> createState() => _PendingMonthlyValueCardsState();
}

class _PendingMonthlyValueCardsState extends State<PendingMonthlyValueCards> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70.0,
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: PendingMonthlyCard(
              title: 'Einnahmen',
              pendingMonthlyValue: widget.monthlyDependingIncome,
              textColor: Colors.greenAccent,
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: PendingMonthlyCard(
              title: 'Ausgaben',
              pendingMonthlyValue: widget.monthlyDependingExpense,
              textColor: Colors.redAccent,
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: PendingMonthlyCard(
              title: 'Investment',
              pendingMonthlyValue: widget.monthlyDependingInvestment,
              textColor: Colors.cyanAccent,
            ),
          ),
        ],
      ),
    );
  }
}
