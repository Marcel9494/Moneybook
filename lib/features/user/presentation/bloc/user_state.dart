part of 'user_bloc.dart';

sealed class UserState extends Equatable {
  const UserState();
}

final class Initial extends UserState {
  @override
  List<Object> get props => [];
}

final class Created extends UserState {
  @override
  List<Object> get props => [];
}

final class FirstStartChecked extends UserState {
  final bool isFirstStart;

  const FirstStartChecked({required this.isFirstStart});

  @override
  List<Object> get props => [isFirstStart];
}

final class CurrentLanguage extends UserState {
  final String currentLanguageCode;

  const CurrentLanguage({required this.currentLanguageCode});

  @override
  List<Object> get props => [currentLanguageCode];
}

final class CurrencyUpdated extends UserState {
  final int forceRefresh;

  const CurrencyUpdated({required this.forceRefresh});

  @override
  List<Object> get props => [forceRefresh];
}
