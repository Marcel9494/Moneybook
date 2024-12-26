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
            infoDialogText:
                'Konten von folgendem Kontotyp werden als Vermögen klassifiziert:\n- Konto\n- Kapitalanlage\n- Bargeld\n- Karte\n- Versicherung\n- Sonstiges',
          ),
          OverviewCard(
            title: 'Schulden',
            value: widget.debts,
            textColor: Colors.redAccent,
            infoDialogText: 'Konten die vom Kontotyp Kredit sind oder einen negativen Betrag aufweisen werden als Schulden klassifiziert.',
          ),
          OverviewCard(
            title: 'Saldo',
            value: widget.assets - widget.debts,
            textColor: widget.assets - widget.debts >= 0.0 ? Colors.greenAccent : Colors.redAccent,
            infoDialogText: 'Der Saldo beschreibt den Vermögensstand abzüglich aller Schulden.\n\nVermögen - Schulden = Saldo',
          ),
        ],
      ),
    );
  }
}
