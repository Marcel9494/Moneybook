import 'package:flutter/material.dart';

import '../../../../../core/utils/app_localizations.dart';
import '../../../domain/value_objects/booking_type.dart';

class TypeSegmentedButton extends StatefulWidget {
  BookingType bookingType;
  Function onSelectionChanged;

  TypeSegmentedButton({
    super.key,
    required this.bookingType,
    required this.onSelectionChanged,
  });

  @override
  State<TypeSegmentedButton> createState() => _TypeSegmentedButtonState();
}

class _TypeSegmentedButtonState extends State<TypeSegmentedButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SegmentedButton(
        segments: <ButtonSegment<BookingType>>[
          ButtonSegment(
            value: BookingType.expense,
            label: Text(
              AppLocalizations.of(context).translate(BookingType.expense.name),
              style: const TextStyle(fontSize: 12.0),
            ),
          ),
          ButtonSegment(
            value: BookingType.income,
            label: Text(
              AppLocalizations.of(context).translate(BookingType.income.name),
              style: const TextStyle(fontSize: 12.0),
            ),
          ),
          ButtonSegment(
            value: BookingType.transfer,
            label: Text(
              AppLocalizations.of(context).translate(BookingType.transfer.name),
              style: const TextStyle(fontSize: 12.0),
            ),
          ),
          ButtonSegment(
            value: BookingType.investment,
            label: Text(
              AppLocalizations.of(context).translate(BookingType.investment.name),
              style: const TextStyle(fontSize: 12.0),
            ),
          ),
        ],
        selected: {widget.bookingType},
        onSelectionChanged: (newSelectedValue) => widget.onSelectionChanged(newSelectedValue),
        showSelectedIcon: false,
        style: SegmentedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(12.0),
              bottom: Radius.circular(4.0),
            ),
          ),
        ),
      ),
    );
  }
}
