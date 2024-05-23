import 'package:equatable/equatable.dart';

import '../value_objects/booking_type.dart';

class Booking extends Equatable {
  final int id;
  final BookingType type;
  final String title;
  final DateTime date;
  final double amount;
  final String account;
  final String categorie;

  const Booking({
    required this.id,
    required this.type,
    required this.title,
    required this.date,
    required this.amount,
    required this.account,
    required this.categorie,
  });

  @override
  List<Object> get props => [id, type, title, date, amount, account, categorie];
}
