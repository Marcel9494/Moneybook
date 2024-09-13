import 'package:flutter/material.dart';

import '../../../domain/entities/account.dart';
import 'overview_card.dart';

class OverviewCards extends StatefulWidget {
  final List<Account> accounts;
  final double assets;
  final double debts;

  const OverviewCards({
    super.key,
    required this.accounts,
    required this.assets,
    required this.debts,
  });

  @override
  State<OverviewCards> createState() => _OverviewCardsState();
}

class _OverviewCardsState extends State<OverviewCards> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70.0,
      child: Row(
        children: [
          OverviewCard(
            title: 'Vermögen',
            value: widget.assets,
            textColor: Colors.greenAccent,
          ),
          OverviewCard(
            title: 'Schulden',
            value: widget.debts,
            textColor: Colors.redAccent,
          ),
          OverviewCard(
            title: 'Saldo',
            value: widget.assets - widget.debts,
            textColor: widget.assets - widget.debts >= 0.0 ? Colors.greenAccent : Colors.redAccent,
          ),
        ],
      ),
    );
  }
}
