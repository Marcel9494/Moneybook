import 'package:flutter/material.dart';

import '../bottom_sheets/amount_bottom_sheet.dart';

class AmountTextField extends StatelessWidget {
  final TextEditingController amountController;
  final String errorText;

  const AmountTextField({
    super.key,
    required this.amountController,
    required this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: amountController,
      showCursor: true,
      readOnly: true,
      onTap: () => openBottomSheetForAmountInput(context, amountController),
      decoration: InputDecoration(
        hintText: 'Betrag...',
        counterText: '',
        prefixIcon: const Icon(Icons.money_rounded),
        errorText: errorText.isEmpty ? null : errorText,
      ),
    );
  }
}
