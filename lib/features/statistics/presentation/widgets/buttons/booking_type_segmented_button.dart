import 'package:flutter/material.dart';

import '../../../../../core/utils/app_localizations.dart';
import '../../../../bookings/domain/value_objects/booking_type.dart';

class BookingTypeSegmentedButton extends StatefulWidget {
  final BookingType selectedBookingType;
  final Function(Set<BookingType>) onBookingTypeChanged;

  const BookingTypeSegmentedButton({
    super.key,
    required this.selectedBookingType,
    required this.onBookingTypeChanged,
  });

  @override
  State<BookingTypeSegmentedButton> createState() => _BookingTypeSegmentedButtonState();
}

class _BookingTypeSegmentedButtonState extends State<BookingTypeSegmentedButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, right: 6.0, left: 6.0),
      child: SizedBox(
        width: double.infinity,
        child: SegmentedButton<BookingType>(
          segments: <ButtonSegment<BookingType>>[
            ButtonSegment<BookingType>(
              value: BookingType.expense,
              label: Text(
                AppLocalizations.of(context).translate(BookingType.expense.pluralName),
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12.0),
              ),
            ),
            ButtonSegment<BookingType>(
              value: BookingType.income,
              label: Text(
                AppLocalizations.of(context).translate(BookingType.income.pluralName),
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12.0),
              ),
            ),
            ButtonSegment<BookingType>(
              value: BookingType.investment,
              label: Text(
                AppLocalizations.of(context).translate(BookingType.investment.pluralName),
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12.0),
              ),
            ),
          ],
          selected: <BookingType>{widget.selectedBookingType},
          onSelectionChanged: widget.onBookingTypeChanged,
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
