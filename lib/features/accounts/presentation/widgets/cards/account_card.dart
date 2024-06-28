import 'package:flutter/material.dart';

import '../../../../../core/utils/number_formatter.dart';
import '../../../domain/entities/account.dart';

class AccountCard extends StatefulWidget {
  final Account account;

  const AccountCard({
    super.key,
    required this.account,
  });

  @override
  State<AccountCard> createState() => _AccountCardState();
}

class _AccountCardState extends State<AccountCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ClipPath(
        clipper: ShapeBorderClipper(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        ),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(left: BorderSide(color: Colors.cyanAccent, width: 3.5)),
          ),
          child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.account.name),
                Text(formatToMoneyAmount(widget.account.amount.toString())),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
