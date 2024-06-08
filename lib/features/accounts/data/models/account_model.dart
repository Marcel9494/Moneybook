import '../../domain/entities/account.dart';

class AccountModel extends Account {
  const AccountModel({
    required super.id,
    required super.type,
    required super.name,
    required super.amount,
    required super.currency,
  });
}
