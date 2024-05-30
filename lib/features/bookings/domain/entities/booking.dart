import 'package:equatable/equatable.dart';
import 'package:moneybook/features/bookings/domain/value_objects/repetition_type.dart';

import '../value_objects/booking_type.dart';

class Booking extends Equatable {
  final int id;
  final BookingType type;
  final String title;
  final DateTime date;
  final RepetitionType repetition;
  final double amount;
  final String currency;
  final String account;
  final String categorie;

  const Booking({
    required this.id,
    required this.type,
    required this.title,
    required this.date,
    required this.repetition,
    required this.amount,
    required this.currency,
    required this.account,
    required this.categorie,
  });

  @override
  List<Object> get props => [id, type, title, date, repetition, amount, currency, account, categorie];
}
