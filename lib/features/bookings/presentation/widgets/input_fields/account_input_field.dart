import 'package:flutter/material.dart';

import '../bottom_sheets/account_bottom_sheet.dart';

class AccountInputField extends StatelessWidget {
  final String hintText;
  final TextEditingController accountController;
  final String errorText;

  const AccountInputField({
    super.key,
    required this.hintText,
    required this.accountController,
    required this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: accountController,
      showCursor: false,
      readOnly: true,
      onTap: () => openAccountBottomSheet(
        context: context,
        title: 'Konto auswählen:',
        controller: accountController,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        counterText: '',
        prefixIcon: const Icon(Icons.account_balance_rounded),
        errorText: errorText.isEmpty ? null : errorText,
      ),
    );
  }
}
