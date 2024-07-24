import 'package:equatable/equatable.dart';

class Budget extends Equatable {
  final int id;
  final int categorieId;
  final double amount;
  final double used;
  final double remaining;
  final double percentage;
  final String currency;

  const Budget({
    required this.id,
    required this.categorieId,
    required this.amount,
    required this.used,
    required this.remaining,
    required this.percentage,
    required this.currency,
  });

  Budget copyWith({
    int? id,
    int? categorieId,
    double? amount,
    double? used,
    double? remaining,
    double? percentage,
    String? currency,
  }) {
    return Budget(
      id: id ?? this.id,
      categorieId: categorieId ?? this.categorieId,
      amount: amount ?? this.amount,
      used: used ?? this.used,
      remaining: remaining ?? this.remaining,
      percentage: percentage ?? this.percentage,
      currency: currency ?? this.currency,
    );
  }

  @override
  List<Object?> get props => [id, categorieId, amount, used, remaining, percentage, currency];
}
