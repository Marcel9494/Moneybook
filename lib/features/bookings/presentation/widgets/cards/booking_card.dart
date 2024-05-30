import 'package:flutter/material.dart';

import '../../../../../core/utils/number_formatter.dart';
import '../../../domain/entities/booking.dart';
import '../../../domain/value_objects/booking_type.dart';

class BookingCard extends StatelessWidget {
  final Booking booking;

  const BookingCard({
    super.key,
    required this.booking,
  });

  Color _getBookingTypeColor() {
    if (booking.type == BookingType.expense) {
      return Colors.redAccent;
    } else if (booking.type == BookingType.income) {
      return Colors.greenAccent;
    } else if (booking.type == BookingType.transfer || booking.type == BookingType.investment) {
      return Colors.cyanAccent;
    }
    return Colors.cyanAccent;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ClipPath(
        clipper: ShapeBorderClipper(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border(right: BorderSide(color: _getBookingTypeColor(), width: 3.5)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 12.0, 12.0, 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(right: BorderSide(color: Colors.grey.shade700, width: 0.7)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            booking.categorie,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            booking.account,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 12.0, 12.0, 8.0),
                  child: Text(booking.title),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 12.0, 16.0, 8.0),
                  child: Text(
                    formatToMoneyAmount(booking.amount.toString()),
                    style: TextStyle(
                      color: _getBookingTypeColor(),
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
