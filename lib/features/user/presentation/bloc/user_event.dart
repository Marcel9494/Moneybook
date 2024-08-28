part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();
}

class CreateUser extends UserEvent {
  final User user;

  const CreateUser({required this.user});

  @override
  List<Object?> get props => [user];
}

class CheckFirstStart extends UserEvent {
  final BuildContext context;

  const CheckFirstStart({required this.context});

  @override
  List<Object?> get props => [context];
}
