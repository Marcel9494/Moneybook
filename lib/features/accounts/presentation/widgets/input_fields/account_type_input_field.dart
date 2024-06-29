import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../../../shared/presentation/widgets/deco/bottom_sheet_header.dart';
import '../../../../bookings/presentation/widgets/buttons/list_view_button.dart';
import '../../../domain/value_objects/account_type.dart';

class AccountTypeInputField extends StatefulWidget {
  final TextEditingController accountTypeController;
  String accountType;

  AccountTypeInputField({
    super.key,
    required this.accountTypeController,
    required this.accountType,
  });

  @override
  State<AccountTypeInputField> createState() => _AccountTypeInputFieldState();
}

class _AccountTypeInputFieldState extends State<AccountTypeInputField> {
  openAccountTypeBottomSheet({required BuildContext context, required String accountType}) {
    showCupertinoModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Material(
          child: Wrap(
            children: [
              Column(
                children: [
                  const BottomSheetHeader(title: 'Kontotyp auswählen:'),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 1.7,
                    child: SingleChildScrollView(
                      child: ListView(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        padding: const EdgeInsets.all(8),
                        children: <Widget>[
                          ListViewButton(
                            onPressed: () => _setAccountType(context, AccountType.none.name),
                            text: AccountType.none.name,
                            selectedValue: accountType,
                          ),
                          ListViewButton(
                            onPressed: () => _setAccountType(context, AccountType.account.name),
                            text: AccountType.account.name,
                            selectedValue: accountType,
                          ),
                          ListViewButton(
                            onPressed: () => _setAccountType(context, AccountType.capitalInvestment.name),
                            text: AccountType.capitalInvestment.name,
                            selectedValue: accountType,
                          ),
                          ListViewButton(
                            onPressed: () => _setAccountType(context, AccountType.cash.name),
                            text: AccountType.cash.name,
                            selectedValue: accountType,
                          ),
                          ListViewButton(
                            onPressed: () => _setAccountType(context, AccountType.card.name),
                            text: AccountType.card.name,
                            selectedValue: accountType,
                          ),
                          ListViewButton(
                            onPressed: () => _setAccountType(context, AccountType.insurance.name),
                            text: AccountType.insurance.name,
                            selectedValue: accountType,
                          ),
                          ListViewButton(
                            onPressed: () => _setAccountType(context, AccountType.credit.name),
                            text: AccountType.credit.name,
                            selectedValue: accountType,
                          ),
                          ListViewButton(
                            onPressed: () => _setAccountType(context, AccountType.other.name),
                            text: AccountType.other.name,
                            selectedValue: accountType,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _setAccountType(BuildContext context, String newAccountType) {
    setState(() {
      widget.accountType = newAccountType;
      if (widget.accountType == AccountType.none.name) {
        widget.accountTypeController.text = '';
      } else {
        widget.accountTypeController.text = newAccountType;
      }
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.accountTypeController,
      showCursor: false,
      readOnly: true,
      textAlignVertical: TextAlignVertical.center,
      onTap: () => openAccountTypeBottomSheet(
        context: context,
        accountType: widget.accountType,
      ),
      decoration: const InputDecoration(
        hintText: 'Kontotyp...',
        counterText: '',
        prefixIcon: IconTheme(
          data: IconThemeData(color: Colors.grey),
          child: Icon(Icons.account_balance_outlined),
        ),
      ),
    );
  }
}
