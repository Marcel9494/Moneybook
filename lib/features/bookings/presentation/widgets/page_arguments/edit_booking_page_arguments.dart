import '../../../../../shared/domain/value_objects/edit_mode_type.dart';
import '../../../domain/entities/booking.dart';

class EditBookingPageArguments {
  final Booking booking;
  final EditModeType editMode;

  EditBookingPageArguments(
    this.booking,
    this.editMode,
  );
}
