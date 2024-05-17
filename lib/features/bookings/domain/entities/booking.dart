import 'package:equatable/equatable.dart';

class Booking extends Equatable {
  final int id;
  final String title;
  final DateTime date;
  final double amount;
  final String account;
  final String categorie;

  const Booking({
    required this.id,
    required this.title,
    required this.date,
    required this.amount,
    required this.account,
    required this.categorie,
  });

  @override
  List<Object> get props => [id, title, date, amount, account, categorie];
}
