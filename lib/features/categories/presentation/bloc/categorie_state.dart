part of 'categorie_bloc.dart';

sealed class CategorieState {
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
  final List<Categorie> expenseCategories;
  final List<Categorie> incomeCategories;
  final List<Categorie> investmentCategories;

  const Loaded({
    required this.expenseCategories,
    required this.incomeCategories,
    required this.investmentCategories,
  });

  @override
  List<Object> get props => [
        expenseCategories,
        incomeCategories,
        investmentCategories,
      ];
}

final class Finished extends CategorieState {
  @override
  List<Object> get props => [];
}

final class Edited extends CategorieState {
  @override
  List<Object> get props => [];
}

final class Deleted extends CategorieState {
  @override
  List<Object> get props => [];
}

final class ReceivedCategorie extends CategorieState {
  final Categorie categorie;

  const ReceivedCategorie({required this.categorie});

  @override
  List<Object> get props => [categorie];
}

final class ReceivedCategories extends CategorieState {
  final List<Categorie> categories;

  const ReceivedCategories({required this.categories});

  @override
  List<Object> get props => [categories];
}

final class CheckedCategorieName extends CategorieState {
  final bool categorieNameExists;
  final Categorie categorie;
  final int numberOfEventCalls;

  const CheckedCategorieName({
    required this.categorieNameExists,
    required this.categorie,
    required this.numberOfEventCalls,
  });

  @override
  List<Object> get props => [categorieNameExists, categorie, numberOfEventCalls];
}

final class Error extends CategorieState {
  final String message;

  const Error({required this.message});

  @override
  List<Object> get props => [message];
}
