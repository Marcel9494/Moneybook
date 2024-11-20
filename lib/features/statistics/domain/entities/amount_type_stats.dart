import 'package:equatable/equatable.dart';

import '../../../bookings/domain/value_objects/amount_type.dart';

class AmountTypeStats extends Equatable {
  final AmountType amountType;
  final double amount;
  final double percentage;

  const AmountTypeStats({
    required this.amountType,
    required this.amount,
    required this.percentage,
  });

  @override
  List<Object> get props => [amountType, amount, percentage];
}
