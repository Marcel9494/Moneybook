import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../buttons/square_button.dart';
import '../buttons/square_icon_button.dart';

void openBottomSheetForAmountInput(BuildContext context, TextEditingController amountController) {
  showCupertinoModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return Material(
        child: SizedBox(
          height: 450.0, // TODO responsive implementieren
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 16.0, left: 28.0),
                child: Text('Betrag eingeben:', style: TextStyle(fontSize: 18.0)),
              ),
              Center(
                child: GridView.count(
                  primary: false,
                  padding: const EdgeInsets.all(30),
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
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
                    const Visibility(
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
        ),
      );
    },
  );
}

void _setAmount(String text, TextEditingController amountController) {
  amountController.text = '${amountController.text}$text';
}

void _removeLastCharacter(TextEditingController amountController) {
  amountController.text.isNotEmpty ? amountController.text = amountController.text.substring(0, amountController.text.length - 1) : null;
}

void _clearAmount(TextEditingController amountController) {
  amountController.text = '';
}
