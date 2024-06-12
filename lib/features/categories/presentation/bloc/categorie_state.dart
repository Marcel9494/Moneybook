part of 'categorie_bloc.dart';

sealed class CategorieState extends Equatable {
  const CategorieState();
}

final class Initial extends CategorieState {
  @override
  List<Object> get props => [];
}

final class Finished extends CategorieState {
  @override
  List<Object> get props => [];
}
