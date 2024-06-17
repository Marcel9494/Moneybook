part of 'categorie_bloc.dart';

sealed class CategorieState extends Equatable {
  const CategorieState();
}

final class Initial extends CategorieState {
  @override
  List<Object> get props => [];
}

final class Loading extends CategorieState {
  @override
  List<Object> get props => [];
}

final class Loaded extends CategorieState {
  final List<Categorie> categorie;

  const Loaded({required this.categorie});

  @override
  List<Object> get props => [categorie];
}

final class Finished extends CategorieState {
  @override
  List<Object> get props => [];
}

final class Error extends CategorieState {
  final String message;

  const Error({required this.message});

  @override
  List<Object> get props => [message];
}
