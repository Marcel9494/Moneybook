import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final bool firstStart;
  final DateTime lastStart;
  final String language;
  final String currency;
  final bool localDb;

  const User({
    required this.id,
    required this.firstStart,
    required this.lastStart,
    required this.language,
    required this.currency,
    required this.localDb,
  });

  @override
  List<Object> get props => [id, firstStart, lastStart, language, currency, localDb];
}
