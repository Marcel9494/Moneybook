import 'package:equatable/equatable.dart';

import '../../../bookings/domain/value_objects/booking_type.dart';

class CategorieStats extends Equatable {
  final String categorie;
  final BookingType bookingType;
  double amount;
  double percentage;

  CategorieStats({
    required this.categorie,
    required this.bookingType,
    required this.amount,
    required this.percentage,
  });

  @override
  List<Object> get props => [categorie, bookingType, amount, percentage];
}
