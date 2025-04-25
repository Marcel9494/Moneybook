import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../../../core/utils/app_localizations.dart';
import '../../../../../shared/presentation/widgets/deco/bottom_sheet_header.dart';
import '../../../../bookings/presentation/widgets/buttons/list_view_button.dart';
import '../../../domain/value_objects/account_type.dart';

class AccountTypeInputField extends StatefulWidget {
  final TextEditingController accountTypeController;
  final Function(String)? onAccountTypeSelected;
  String accountType;

  AccountTypeInputField({
    super.key,
    required this.accountTypeController,
    this.onAccountTypeSelected,
    required this.accountType,
  });

  @override
  State<AccountTypeInputField> createState() => _AccountTypeInputFieldState();
}

class _AccountTypeInputFieldState extends State<AccountTypeInputField> {
  openAccountTypeBottomSheet({
    required BuildContext context,
    required Function(String)? onAccountTypeSelected,
    required String accountType,
  }) {
    showCupertinoModalBottomSheet<void>(
      context: context,
      backgroundColor: Color(0xFF1c1b20),
      builder: (BuildContext context) {
        return Material(
          color: Color(0xFF1c1b20),
          child: Wrap(
            children: [
              Column(
                children: [
                  BottomSheetHeader(title: AppLocalizations.of(context).translate('kontotyp_auswählen') + ':'),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 1.7,
                    child: SingleChildScrollView(
                      child: ListView(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        padding: const EdgeInsets.all(8),
                        children: <Widget>[
                          ListViewButton(
                            onPressed: () => {
                              onAccountTypeSelected!(AccountType.none.name),
                              _setAccountType(context, AccountType.none.name),
                            },
                            text: AccountType.none.name,
                            selectedValue: accountType,
                          ),
                          ListViewButton(
                            onPressed: () => {
                              onAccountTypeSelected!(AccountType.account.name),
                              _setAccountType(context, AccountType.account.name),
                            },
                            text: AccountType.account.name,
                            selectedValue: accountType,
                          ),
                          ListViewButton(
                            onPressed: () => {
                              onAccountTypeSelected!(AccountType.capitalInvestment.name),
                              _setAccountType(context, AccountType.capitalInvestment.name),
                            },
                            text: AccountType.capitalInvestment.name,
                            selectedValue: accountType,
                          ),
                          ListViewButton(
                            onPressed: () => {
                              onAccountTypeSelected!(AccountType.cash.name),
                              _setAccountType(context, AccountType.cash.name),
                            },
                            text: AccountType.cash.name,
                            selectedValue: accountType,
                          ),
                          ListViewButton(
                            onPressed: () => {
                              onAccountTypeSelected!(AccountType.card.name),
                              _setAccountType(context, AccountType.card.name),
                            },
                            text: AccountType.card.name,
                            selectedValue: accountType,
                          ),
                          ListViewButton(
                            onPressed: () => {
                              onAccountTypeSelected!(AccountType.insurance.name),
                              _setAccountType(context, AccountType.insurance.name),
                            },
                            text: AccountType.insurance.name,
                            selectedValue: accountType,
                          ),
                          ListViewButton(
                            onPressed: () => {
                              onAccountTypeSelected!(AccountType.credit.name),
                              _setAccountType(context, AccountType.credit.name),
                            },
                            text: AccountType.credit.name,
                            selectedValue: accountType,
                          ),
                          ListViewButton(
                            onPressed: () => {
                              onAccountTypeSelected!(AccountType.other.name),
                              _setAccountType(context, AccountType.other.name),
                            },
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
        widget.accountTypeController.text = AppLocalizations.of(context).translate(newAccountType);
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
        onAccountTypeSelected: widget.onAccountTypeSelected,
        accountType: widget.accountType,
      ),
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context).translate('kontotyp') + '...',
        counterText: '',
        prefixIcon: const IconTheme(
          data: IconThemeData(color: Colors.grey),
          child: Icon(Icons.account_balance_outlined),
        ),
      ),
    );
  }
}
