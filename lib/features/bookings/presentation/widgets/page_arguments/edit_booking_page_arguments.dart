import '../../../../../shared/domain/value_objects/serie_mode_type.dart';
import '../../../domain/entities/booking.dart';

class EditBookingPageArguments {
  final Booking booking;
  final SerieModeType editMode;

  EditBookingPageArguments(
    this.booking,
    this.editMode,
  );
}
