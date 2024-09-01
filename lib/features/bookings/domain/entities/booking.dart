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
  final String fromAccount;
  final String toAccount;
  final String categorie;
  final bool isBooked;

  const Booking({
    required this.id,
    required this.type,
    required this.title,
    required this.date,
    required this.repetition,
    required this.amount,
    required this.currency,
    required this.fromAccount,
    required this.toAccount,
    required this.categorie,
    required this.isBooked,
  });

  Booking copyWith(
      {int? id,
      BookingType? type,
      String? title,
      DateTime? date,
      RepetitionType? repetition,
      double? amount,
      String? currency,
      String? fromAccount,
      String? toAccount,
      String? categorie,
      bool? isBooked}) {
    return Booking(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      date: date ?? this.date,
      repetition: repetition ?? this.repetition,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      fromAccount: fromAccount ?? this.fromAccount,
      toAccount: toAccount ?? this.toAccount,
      categorie: categorie ?? this.categorie,
      isBooked: isBooked ?? this.isBooked,
    );
  }

  @override
  List<Object> get props => [id, type, title, date, repetition, amount, currency, fromAccount, toAccount, categorie, isBooked];
}
