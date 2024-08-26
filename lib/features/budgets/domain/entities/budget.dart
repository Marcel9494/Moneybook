import 'package:equatable/equatable.dart';

class Budget extends Equatable {
  final int id;
  final String categorie;
  final DateTime date;
  final double amount;
  double used;
  double remaining;
  double percentage;
  final String currency;

  Budget({
    required this.id,
    required this.categorie,
    required this.date,
    required this.amount,
    required this.used,
    required this.remaining,
    required this.percentage,
    required this.currency,
  });

  Budget copyWith({
    int? id,
    String? categorie,
    DateTime? date,
    double? amount,
    double? used,
    double? remaining,
    double? percentage,
    String? currency,
  }) {
    return Budget(
      id: id ?? this.id,
      categorie: categorie ?? this.categorie,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      used: used ?? this.used,
      remaining: remaining ?? this.remaining,
      percentage: percentage ?? this.percentage,
      currency: currency ?? this.currency,
    );
  }

  @override
  List<Object?> get props => [id, categorie, date, amount, used, remaining, percentage, currency];
}
