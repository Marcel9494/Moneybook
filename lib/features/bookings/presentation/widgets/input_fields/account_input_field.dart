import 'package:flutter/material.dart';

import '../bottom_sheets/account_bottom_sheet.dart';

class AccountInputField extends StatelessWidget {
  final String hintText;
  final TextEditingController accountController;

  const AccountInputField({
    super.key,
    required this.hintText,
    required this.accountController,
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
      validator: (input) => _checkAccountInput(),
      onTap: () => openAccountBottomSheet(
        context: context,
        title: 'Konto auswählen:',
        controller: accountController,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        counterText: '',
        prefixIcon: const Icon(Icons.account_balance_outlined),
      ),
    );
  }
}
