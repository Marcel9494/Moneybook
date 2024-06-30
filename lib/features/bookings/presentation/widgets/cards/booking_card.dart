import 'package:flutter/material.dart';
import 'package:moneybook/core/consts/route_consts.dart';
import 'package:moneybook/features/bookings/presentation/widgets/page_arguments/edit_booking_page_arguments.dart';

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
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, editBookingRoute, arguments: EditBookingPageArguments(booking)),
      child: Card(
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
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 8.0, 0.0, 10.0),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        booking.categorie,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(left: BorderSide(color: Colors.grey.shade700, width: 0.7)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 16.0),
                                    child: Text(booking.title, overflow: TextOverflow.ellipsis),
                                  ),
                                ),
                                Text(
                                  formatToMoneyAmount(booking.amount.toString()),
                                  style: TextStyle(
                                    color: _getBookingTypeColor(),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.end,
                                ),
                              ],
                            ),
                            const SizedBox(height: 4.0),
                            Row(
                              children: [
                                Text(booking.fromAccount),
                                booking.type == BookingType.transfer || booking.type == BookingType.investment
                                    ? const Icon(Icons.arrow_right_alt_rounded, size: 20.0)
                                    : const SizedBox(),
                                booking.type == BookingType.transfer || booking.type == BookingType.investment
                                    ? Text(booking.toAccount, overflow: TextOverflow.ellipsis)
                                    : const SizedBox(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
