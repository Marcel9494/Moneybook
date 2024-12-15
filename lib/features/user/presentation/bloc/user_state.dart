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
