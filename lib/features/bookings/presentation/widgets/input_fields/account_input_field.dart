import 'package:flutter/material.dart';

import '../../../../../core/utils/app_localizations.dart';
import '../bottom_sheets/account_bottom_sheet.dart';

class AccountInputField extends StatelessWidget {
  final String hintText;
  final TextEditingController accountController;
  final Function(String)? onAccountSelected;
  final List<String> accountNameFilter;
  final String bottomSheetTitle;

  const AccountInputField({
    super.key,
    required this.hintText,
    required this.accountController,
    this.onAccountSelected,
    this.accountNameFilter = const [],
    this.bottomSheetTitle = 'Konto auswählen:',
  });

  String? _checkAccountInput(BuildContext context) {
    if (accountController.text.isEmpty) {
      return AppLocalizations.of(context).translate('leeres_konto');
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
      validator: (input) => _checkAccountInput(context),
      onTap: () => openAccountBottomSheet(
        context: context,
        title: bottomSheetTitle,
        controller: accountController,
        onAccountSelected: onAccountSelected,
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
