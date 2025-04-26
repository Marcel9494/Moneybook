import 'package:flutter/material.dart';
import 'package:moneybook/features/bookings/presentation/widgets/cards/pending_monthly_card.dart';

import '../../../../../core/utils/app_localizations.dart';

class PendingMonthlyValueCards extends StatefulWidget {
  final double monthlyDependingExpense;
  final double monthlyDependingIncome;
  final double monthlyDependingInvestmentBuys;
  final double monthlyDependingInvestmentSales;

  const PendingMonthlyValueCards({
    super.key,
    required this.monthlyDependingExpense,
    required this.monthlyDependingIncome,
    required this.monthlyDependingInvestmentBuys,
    required this.monthlyDependingInvestmentSales,
  });

  @override
  State<PendingMonthlyValueCards> createState() => _PendingMonthlyValueCardsState();
}

class _PendingMonthlyValueCardsState extends State<PendingMonthlyValueCards> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          PendingMonthlyCard(
            title: AppLocalizations.of(context).translate('einkommen'),
            pendingMonthlyValue: widget.monthlyDependingIncome,
            textColor: Colors.greenAccent,
          ),
          PendingMonthlyCard(
            title: AppLocalizations.of(context).translate('ausgaben'),
            pendingMonthlyValue: widget.monthlyDependingExpense,
            textColor: Colors.redAccent,
          ),
          PendingMonthlyCard(
            title: AppLocalizations.of(context).translate('käufe'),
            pendingMonthlyValue: widget.monthlyDependingInvestmentBuys,
            textColor: Colors.cyanAccent,
          ),
          PendingMonthlyCard(
            title: AppLocalizations.of(context).translate('verkäufe'),
            pendingMonthlyValue: widget.monthlyDependingInvestmentSales,
            textColor: Colors.cyanAccent,
          ),
        ],
      ),
    );
  }
}
