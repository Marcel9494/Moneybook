import 'package:equatable/equatable.dart';

class CategorieStats extends Equatable {
  final String categorie;
  double amount;
  double percentage;

  CategorieStats({
    required this.categorie,
    required this.amount,
    required this.percentage,
  });

  @override
  List<Object> get props => [categorie, amount, percentage];
}
