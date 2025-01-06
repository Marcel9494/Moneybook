import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../../features/bookings/domain/value_objects/amount_type.dart';
import '../../../../features/bookings/domain/value_objects/booking_type.dart';
import '../../../../features/bookings/presentation/widgets/buttons/list_view_button.dart';
import '../bottom_sheets/amount_bottom_sheet.dart';
import '../deco/bottom_sheet_header.dart';

class AmountTextField extends StatelessWidget {
  final TextEditingController amountController;
  final String hintText;
  final bool showMinus;
  final Function onAmountTypeChanged;
  final String amountType;
  final BookingType bookingType;
  List<AmountType> _amountTypes = [];

  AmountTextField({
    super.key,
    required this.amountController,
    this.onAmountTypeChanged = _emptyFunction,
    this.amountType = '',
    this.hintText = 'Betrag...',
    this.showMinus = false,
    this.bookingType = BookingType.none,
  });

  static void _emptyFunction(AmountType amountType) {}

  String? _checkAmountInput() {
    if (amountController.text.isEmpty) {
      return 'Bitte geben Sie einen Betrag ein.';
    }
    return null;
  }

  List<AmountType> _getAmountTypes() {
    _amountTypes.clear();
    if (BookingType.expense.name == bookingType.name) {
      _amountTypes.add(AmountType.variable);
      _amountTypes.add(AmountType.fix);
    } else if (BookingType.income.name == bookingType.name) {
      _amountTypes.add(AmountType.active);
      _amountTypes.add(AmountType.passive);
    } else if (BookingType.investment.name == bookingType.name) {
      _amountTypes.add(AmountType.buy);
      _amountTypes.add(AmountType.sale);
    }
    return _amountTypes;
  }

  void _openAmountTypeBottomSheet({required BuildContext context, required String amountType}) {
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
                  BottomSheetHeader(
                    title: 'Betragstyp auswählen:',
                    infoButtonFunction: () => _showInfoDialog(context),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 5.0,
                    child: SingleChildScrollView(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        padding: const EdgeInsets.all(8),
                        itemCount: _getAmountTypes().length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListViewButton(
                            onPressed: () => onAmountTypeChanged(_amountTypes[index]),
                            text: _amountTypes[index].name,
                            selectedValue: amountType,
                          );
                        },
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

  void _showInfoDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Betragstypen:'),
          content: RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 16),
              children: [
                TextSpan(text: '${_amountTypes[0].name}:\n', style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: '${_amountTypes[0].description}\n\n'),
                TextSpan(text: '${_amountTypes[1].name}:\n', style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: _amountTypes[1].description),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: amountController,
      showCursor: false,
      readOnly: true,
      textAlignVertical: TextAlignVertical.center,
      validator: (input) => _checkAmountInput(),
      onTap: () => openBottomSheetForAmountInput(
        context: context,
        amountController: amountController,
        showMinus: showMinus,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        counterText: '',
        prefixIcon: const Icon(Icons.money_rounded),
        suffixIcon: bookingType.name != BookingType.transfer.name && bookingType != BookingType.none
            ? Column(
                children: [
                  IconButton(
                    onPressed: () => {
                      _openAmountTypeBottomSheet(
                        context: context,
                        amountType: amountType,
                      ),
                    },
                    padding: const EdgeInsets.only(top: 6.0),
                    constraints: const BoxConstraints(),
                    style: const ButtonStyle(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    icon: const Icon(Icons.ballot_rounded),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      amountType,
                      style: TextStyle(fontSize: 10.0, color: Colors.grey.shade300),
                    ),
                  ),
                ],
              )
            : const SizedBox(),
      ),
    );
  }
}
