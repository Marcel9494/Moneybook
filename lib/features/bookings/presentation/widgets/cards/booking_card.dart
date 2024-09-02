import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:moneybook/core/consts/route_consts.dart';
import 'package:moneybook/features/bookings/domain/value_objects/repetition_type.dart';
import 'package:moneybook/features/bookings/presentation/widgets/page_arguments/edit_booking_page_arguments.dart';
import 'package:moneybook/shared/domain/value_objects/serie_mode_type.dart';

import '../../../../../core/utils/number_formatter.dart';
import '../../../../../shared/presentation/widgets/deco/bottom_sheet_header.dart';
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

  void _openSerieBookingBottomSheet(BuildContext context) {
    showCupertinoModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Material(
          child: Wrap(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BottomSheetHeader(title: 'Buchung bearbeiten:', indent: 16.0),
                  ListTile(
                    leading: const Icon(Icons.looks_one_outlined, color: Colors.cyanAccent),
                    title: const Text('Nur diese Buchung'),
                    trailing: const Icon(Icons.keyboard_arrow_right_rounded),
                    onTap: () => Navigator.popAndPushNamed(
                      context,
                      editBookingRoute,
                      arguments: EditBookingPageArguments(
                        booking,
                        SerieModeType.one,
                      ),
                    ),
                  ),
                  const Divider(indent: 16.0, endIndent: 16.0),
                  ListTile(
                    leading: const Icon(Icons.repeat_one_rounded, color: Colors.cyanAccent),
                    title: const Text('Alle zukünftige Buchungen'),
                    trailing: const Icon(Icons.keyboard_arrow_right_rounded),
                    onTap: () => Navigator.popAndPushNamed(
                      context,
                      editBookingRoute,
                      arguments: EditBookingPageArguments(
                        booking,
                        SerieModeType.onlyFuture,
                      ),
                    ),
                  ),
                  const Divider(indent: 16.0, endIndent: 16.0),
                  ListTile(
                    leading: const Icon(Icons.all_inclusive_rounded, color: Colors.cyanAccent),
                    title: const Text('Alle Buchungen'),
                    trailing: const Icon(Icons.keyboard_arrow_right_rounded),
                    onTap: () => Navigator.popAndPushNamed(
                      context,
                      editBookingRoute,
                      arguments: EditBookingPageArguments(
                        booking,
                        SerieModeType.all,
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => booking.repetition == RepetitionType.noRepetition
          ? Navigator.pushNamed(context, editBookingRoute, arguments: EditBookingPageArguments(booking, SerieModeType.one))
          : _openSerieBookingBottomSheet(context),
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
