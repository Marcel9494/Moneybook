part of 'shared_bloc.dart';

sealed class SharedEvent extends Equatable {
  const SharedEvent();
}

class CreateDatabase extends SharedEvent {
  const CreateDatabase();

  @override
  List<Object?> get props => [];
}

class CreateStartDatabaseValues extends SharedEvent {
  const CreateStartDatabaseValues();

  @override
  List<Object?> get props => [];
}

class DatabaseExists extends SharedEvent {
  final BuildContext context;

  const DatabaseExists({required this.context});

  @override
  List<Object?> get props => [context];
}
