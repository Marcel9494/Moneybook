import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../../core/consts/common_consts.dart';
import '../../../../core/consts/regex_consts.dart';
import '../../../../core/utils/app_localizations.dart';
import '../../../../core/utils/number_formatter.dart';
import '../buttons/square_button.dart';
import '../buttons/square_icon_button.dart';
import '../deco/bottom_sheet_header.dart';

bool _clearAmountInputField = false;

void openBottomSheetForAmountInput({
  required BuildContext context,
  required TextEditingController amountController,
  required int maxAmountLength,
  bool showMinus = false,
  bool showSeparator = true,
  bool isPercentValue = false,
  bool isAgeValue = false,
}) {
  if (amountController.text.isNotEmpty) {
    _clearAmountInputField = true;
  }
  showCupertinoModalBottomSheet<void>(
    context: context,
    backgroundColor: Color(0xFF1c1b20),
    builder: (BuildContext context) {
      return Material(
        color: Color(0xFF1c1b20),
        child: Wrap(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BottomSheetHeader(title: AppLocalizations.of(context).translate('betrag_eingeben')),
                Center(
                  child: GridView.count(
                    primary: false,
                    padding: const EdgeInsets.all(24.0),
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                    crossAxisCount: 4,
                    shrinkWrap: true,
                    children: <Widget>[
                      SquareButton(onPressed: () => _setAmount('1', amountController, maxAmountLength), text: '1'),
                      SquareButton(onPressed: () => _setAmount('2', amountController, maxAmountLength), text: '2'),
                      SquareButton(onPressed: () => _setAmount('3', amountController, maxAmountLength), text: '3'),
                      SquareIconButton(
                        onPressed: () => _clearAmount(amountController),
                        icon: const Icon(Icons.clear_rounded, color: Colors.cyanAccent, size: 24.0),
                      ),
                      SquareButton(onPressed: () => _setAmount('4', amountController, maxAmountLength), text: '4'),
                      SquareButton(onPressed: () => _setAmount('5', amountController, maxAmountLength), text: '5'),
                      SquareButton(onPressed: () => _setAmount('6', amountController, maxAmountLength), text: '6'),
                      SquareIconButton(
                        onPressed: () => _removeLastCharacter(amountController),
                        icon: const Icon(Icons.backspace_rounded, color: Colors.cyanAccent, size: 20.0),
                      ),
                      SquareButton(onPressed: () => _setAmount('7', amountController, maxAmountLength), text: '7'),
                      SquareButton(onPressed: () => _setAmount('8', amountController, maxAmountLength), text: '8'),
                      SquareButton(onPressed: () => _setAmount('9', amountController, maxAmountLength), text: '9'),
                      SquareIconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.check_circle_rounded, color: Colors.greenAccent, size: 24.0)),
                      showMinus
                          ? SquareButton(onPressed: () => _setAmount('-', amountController, maxAmountLength), text: '-')
                          : const Visibility(
                              visible: false,
                              child: Text(''),
                            ),
                      SquareButton(onPressed: () => _setAmount('0', amountController, maxAmountLength), text: '0'),
                      showSeparator
                          ? SquareButton(
                              onPressed: () => _setAmount(locale == 'de-DE' ? ',' : '.', amountController, maxAmountLength),
                              text: locale == 'de-DE' ? ',' : '.')
                          : const Visibility(
                              visible: false,
                              child: Text(''),
                            ),
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
    if (isAgeValue == true) {
      amountController.text = double.parse(amountController.text).toStringAsFixed(0);
    } else if (isPercentValue == true) {
      final locale = Localizations.localeOf(context).toString();
      final numberFormat = NumberFormat.decimalPattern(locale)
        ..minimumFractionDigits = 1
        ..maximumFractionDigits = 1;
      final parsed = double.tryParse(amountController.text.replaceAll(',', '.')) ?? 0;
      amountController.text = '${numberFormat.format(parsed)}%';
    } else if (amountController.text == '-') {
      amountController.text = '';
    } else if (amountController.text.isNotEmpty && !amountController.text.contains(currencyLocale)) {
      amountController.text = formatToMoneyAmount(amountController.text, withoutDecimalPlaces: -1);
    }
  });
}

void _setAmount(String text, TextEditingController amountController, int maxAmountLength) {
  // Eingabefeld wird automatisch geleert => Benutzer muss das Eingabefeld nicht mehr manuell mit X löschen, wenn
  // ein neuer Betrag eingegeben wird.
  if (_clearAmountInputField) {
    amountController.text = '';
    _clearAmountInputField = false;
  }
  if (amountController.text.length > maxAmountLength) {
    return;
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
