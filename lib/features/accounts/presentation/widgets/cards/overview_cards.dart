import 'package:flutter/material.dart';

import '../../../../../core/utils/app_localizations.dart';
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
            title: AppLocalizations.of(context).translate('vermögen'),
            value: widget.assets,
            textColor: Colors.greenAccent,
            infoDialogText: AppLocalizations.of(context).translate('vermögen_beschreibung') +
                '\n- ' +
                AppLocalizations.of(context).translate('konto') +
                '\n- ' +
                AppLocalizations.of(context).translate('kapitalanlage') +
                '\n- ' +
                AppLocalizations.of(context).translate('bargeld') +
                '\n- ' +
                AppLocalizations.of(context).translate('karte') +
                '\n- ' +
                AppLocalizations.of(context).translate('versicherung') +
                '\n- ' +
                AppLocalizations.of(context).translate('sonstiges'),
          ),
          OverviewCard(
            title: AppLocalizations.of(context).translate('schulden'),
            value: widget.debts,
            textColor: Colors.redAccent,
            infoDialogText: AppLocalizations.of(context).translate('schulden_beschreibung'),
          ),
          OverviewCard(
            title: AppLocalizations.of(context).translate('saldo'),
            value: widget.assets - widget.debts,
            textColor: widget.assets - widget.debts >= 0.0 ? Colors.greenAccent : Colors.redAccent,
            infoDialogText: AppLocalizations.of(context).translate('saldo_beschreibung'),
          ),
        ],
      ),
    );
  }
}
