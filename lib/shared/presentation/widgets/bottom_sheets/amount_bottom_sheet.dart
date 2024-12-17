import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../../core/consts/common_consts.dart';
import '../../../../core/consts/regex_consts.dart';
import '../../../../core/utils/number_formatter.dart';
import '../buttons/square_button.dart';
import '../buttons/square_icon_button.dart';
import '../deco/bottom_sheet_header.dart';

bool _clearAmountInputField = false;

void openBottomSheetForAmountInput({required BuildContext context, required TextEditingController amountController, bool showMinus = false}) {
  if (amountController.text.isNotEmpty) {
    _clearAmountInputField = true;
  }
  showCupertinoModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return Material(
        child: Wrap(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BottomSheetHeader(title: 'Betrag eingeben:'),
                Center(
                  child: GridView.count(
                    primary: false,
                    padding: const EdgeInsets.all(24.0),
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                    crossAxisCount: 4,
                    shrinkWrap: true,
                    children: <Widget>[
                      SquareButton(onPressed: () => _setAmount('1', amountController), text: '1'),
                      SquareButton(onPressed: () => _setAmount('2', amountController), text: '2'),
                      SquareButton(onPressed: () => _setAmount('3', amountController), text: '3'),
                      SquareIconButton(
                        onPressed: () => _clearAmount(amountController),
                        icon: const Icon(Icons.clear_rounded, color: Colors.cyanAccent),
                      ),
                      SquareButton(onPressed: () => _setAmount('4', amountController), text: '4'),
                      SquareButton(onPressed: () => _setAmount('5', amountController), text: '5'),
                      SquareButton(onPressed: () => _setAmount('6', amountController), text: '6'),
                      SquareIconButton(
                        onPressed: () => _removeLastCharacter(amountController),
                        icon: const Icon(Icons.backspace_rounded, color: Colors.cyanAccent),
                      ),
                      SquareButton(onPressed: () => _setAmount('7', amountController), text: '7'),
                      SquareButton(onPressed: () => _setAmount('8', amountController), text: '8'),
                      SquareButton(onPressed: () => _setAmount('9', amountController), text: '9'),
                      SquareIconButton(
                          onPressed: () => Navigator.pop(context), icon: const Icon(Icons.check_circle_rounded, color: Colors.greenAccent)),
                      showMinus
                          ? SquareButton(onPressed: () => _setAmount('-', amountController), text: '-')
                          : const Visibility(
                              visible: false,
                              child: Text(''),
                            ),
                      SquareButton(onPressed: () => _setAmount('0', amountController), text: '0'),
                      SquareButton(onPressed: () => _setAmount(',', amountController), text: ','),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  ).whenComplete(() {
    if (amountController.text == '-') {
      amountController.text = '';
    } else if (amountController.text.isNotEmpty && !amountController.text.contains(currencyLocale)) {
      amountController.text = formatToMoneyAmount(amountController.text, withoutDecimalPlaces: -1);
    }
  });
}

void _setAmount(String text, TextEditingController amountController) {
  // Eingabefeld wird automatisch geleert => Benutzer muss das Eingabefeld nicht mehr manuell mit X löschen, wenn
  // ein neuer Betrag eingegeben wird.
  if (_clearAmountInputField) {
    amountController.text = '';
    _clearAmountInputField = false;
  }
  if (moneyRegex.hasMatch(amountController.text + text)) {
    amountController.text = '${amountController.text}$text';
  }
}

void _removeLastCharacter(TextEditingController amountController) {
  amountController.text.isNotEmpty ? amountController.text = amountController.text.substring(0, amountController.text.length - 1) : null;
}

void _clearAmount(TextEditingController amountController) {
  amountController.text = '';
}
