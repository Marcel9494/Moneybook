import 'package:flutter/material.dart';

import '../bottom_sheets/account_bottom_sheet.dart';

class AccountInputField extends StatelessWidget {
  final String hintText;
  final TextEditingController accountController;
  final List<String> accountNameFilter;
  final String bottomSheetTitle;

  const AccountInputField({
    super.key,
    required this.hintText,
    required this.accountController,
    this.accountNameFilter = const [],
    this.bottomSheetTitle = 'Konto auswählen:',
  });

  String? _checkAccountInput() {
    if (accountController.text.isEmpty) {
      return 'Bitte wählen Sie ein Konto aus.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: accountController,
      showCursor: false,
      readOnly: true,
      textAlignVertical: TextAlignVertical.center,
      validator: (input) => _checkAccountInput(),
      onTap: () => openAccountBottomSheet(
        context: context,
        title: bottomSheetTitle,
        controller: accountController,
        accountNameFilter: accountNameFilter,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        counterText: '',
        prefixIcon: const Icon(Icons.account_balance_outlined),
      ),
    );
  }
}
