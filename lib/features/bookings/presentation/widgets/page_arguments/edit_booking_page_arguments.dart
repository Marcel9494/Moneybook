import '../../../domain/entities/booking.dart';
import '../../../domain/value_objects/edit_mode_type.dart';

class EditBookingPageArguments {
  final Booking booking;
  final EditModeType editMode;

  EditBookingPageArguments(
    this.booking,
    this.editMode,
  );
}
