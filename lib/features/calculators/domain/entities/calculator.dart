import 'package:equatable/equatable.dart';

class Calculator extends Equatable {
  final String title;
  final String description;
  final String route;

  const Calculator({
    required this.title,
    required this.description,
    required this.route,
  });

  @override
  List<Object> get props => [title, description, route];
}
