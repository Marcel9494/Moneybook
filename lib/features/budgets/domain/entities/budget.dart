import 'package:equatable/equatable.dart';

class Budget extends Equatable {
  final int id;
  final int categorieId;
  final DateTime date;
  final double amount;
  final double used;
  final double remaining;
  final double percentage;
  final String currency;

  const Budget({
    required this.id,
    required this.categorieId,
    required this.date,
    required this.amount,
    required this.used,
    required this.remaining,
    required this.percentage,
    required this.currency,
  });

  Budget copyWith({
    int? id,
    int? categorieId,
    DateTime? date,
    double? amount,
    double? used,
    double? remaining,
    double? percentage,
    String? currency,
  }) {
    return Budget(
      id: id ?? this.id,
      categorieId: categorieId ?? this.categorieId,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      used: used ?? this.used,
      remaining: remaining ?? this.remaining,
      percentage: percentage ?? this.percentage,
      currency: currency ?? this.currency,
    );
  }

  @override
  List<Object?> get props => [id, categorieId, date, amount, used, remaining, percentage, currency];
}
