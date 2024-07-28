part of 'shared_bloc.dart';

sealed class SharedEvent extends Equatable {
  const SharedEvent();
}

class CreateDatabase extends SharedEvent {
  const CreateDatabase();

  @override
  List<Object?> get props => [];
}
