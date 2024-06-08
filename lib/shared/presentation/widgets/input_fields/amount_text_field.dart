import 'package:flutter/material.dart';

import '../bottom_sheets/amount_bottom_sheet.dart';

class AmountTextField extends StatelessWidget {
  final TextEditingController amountController;

  const AmountTextField({
    super.key,
    required this.amountController,
  });

  String? _checkAmountInput() {
    if (amountController.text.isEmpty) {
      return 'Bitte geben Sie einen Betrag ein.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: amountController,
      showCursor: false,
      readOnly: true,
      validator: (input) => _checkAmountInput(),
      onTap: () => openBottomSheetForAmountInput(
        context: context,
        amountController: amountController,
      ),
      decoration: const InputDecoration(
        hintText: 'Betrag...',
        counterText: '',
        prefixIcon: Icon(Icons.money_rounded),
      ),
    );
  }
}
