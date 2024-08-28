part of 'shared_bloc.dart';

sealed class SharedState extends Equatable {
  const SharedState();
}

final class Initial extends SharedState {
  @override
  List<Object> get props => [];
}

final class Created extends SharedState {
  @override
  List<Object> get props => [];
}

final class Exists extends SharedState {
  final bool exists;

  const Exists({required this.exists});

  @override
  List<Object> get props => [exists];
}

final class Error extends SharedState {
  final String message;

  const Error({required this.message});

  @override
  List<Object> get props => [message];
}
