import 'package:flutter/material.dart';

import '../../../domain/value_objects/booking_type.dart';

class TypeSegmentedButton extends StatefulWidget {
  Set<BookingType> bookingType;

  TypeSegmentedButton({
    super.key,
    required this.bookingType,
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
              BookingType.expense.name,
              style: const TextStyle(fontSize: 12.0),
            ),
          ),
          ButtonSegment(
            value: BookingType.income,
            label: Text(
              BookingType.income.name,
              style: const TextStyle(fontSize: 12.0),
            ),
          ),
          ButtonSegment(
            value: BookingType.transfer,
            label: Text(
              BookingType.transfer.name,
              style: const TextStyle(fontSize: 12.0),
            ),
          ),
          ButtonSegment(
            value: BookingType.investment,
            label: Text(
              BookingType.investment.name,
              style: const TextStyle(fontSize: 12.0),
            ),
          ),
        ],
        selected: widget.bookingType,
        onSelectionChanged: (newSelectedType) {
          setState(() {
            widget.bookingType = newSelectedType;
          });
        },
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
