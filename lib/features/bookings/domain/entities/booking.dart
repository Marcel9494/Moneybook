import 'package:equatable/equatable.dart';
import 'package:moneybook/features/bookings/domain/value_objects/repetition_type.dart';

import '../value_objects/amount_type.dart';
import '../value_objects/booking_type.dart';

class Booking extends Equatable {
  final int id;
  final int serieId;
  final BookingType type;
  final String title;
  final DateTime date;
  final RepetitionType repetition;
  final double amount;
  final AmountType amountType;
  final String currency;
  final String fromAccount;
  final String toAccount;
  final String categorie;
  final bool isBooked;

  const Booking({
    required this.id,
    required this.serieId,
    required this.type,
    required this.title,
    required this.date,
    required this.repetition,
    required this.amount,
    required this.amountType,
    required this.currency,
    required this.fromAccount,
    required this.toAccount,
    required this.categorie,
    required this.isBooked,
  });

  Booking copyWith(
      {int? id,
      int? serieId,
      BookingType? type,
      String? title,
      DateTime? date,
      RepetitionType? repetition,
      double? amount,
      AmountType? amountType,
      String? currency,
      String? fromAccount,
      String? toAccount,
      String? categorie,
      bool? isBooked}) {
    return Booking(
      serieId: serieId ?? this.serieId,
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      date: date ?? this.date,
      repetition: repetition ?? this.repetition,
      amount: amount ?? this.amount,
      amountType: amountType ?? this.amountType,
      currency: currency ?? this.currency,
      fromAccount: fromAccount ?? this.fromAccount,
      toAccount: toAccount ?? this.toAccount,
      categorie: categorie ?? this.categorie,
      isBooked: isBooked ?? this.isBooked,
    );
  }

  @override
  List<Object> get props => [id, serieId, type, title, date, repetition, amount, amountType, currency, fromAccount, toAccount, categorie, isBooked];
}
