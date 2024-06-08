import 'package:equatable/equatable.dart';
import 'package:moneybook/features/accounts/domain/value_objects/account_type.dart';

class Account extends Equatable {
  final int id;
  final AccountType type;
  final String name;
  final double amount;
  final String currency;

  const Account({
    required this.id,
    required this.type,
    required this.name,
    required this.amount,
    required this.currency,
  });

  @override
  List<Object> get props => [id, type, name, amount, currency];
}
