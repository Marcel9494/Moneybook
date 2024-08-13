import 'package:flutter/material.dart';
import 'package:moneybook/features/accounts/presentation/widgets/page_arguments/edit_account_page_arguments.dart';

import '../../../../../core/consts/route_consts.dart';
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
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, editAccountRoute, arguments: EditAccountPageArguments(widget.account)),
      child: Card(
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
                  Text(
                    widget.account.name,
                    style: const TextStyle(fontSize: 14.0),
                  ),
                  Text(
                    formatToMoneyAmount(widget.account.amount.toString()),
                    style: const TextStyle(fontSize: 14.0),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
