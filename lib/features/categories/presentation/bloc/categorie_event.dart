part of 'categorie_bloc.dart';

sealed class CategorieEvent {
  const CategorieEvent();
}

class CreateCategorie extends CategorieEvent {
  final Categorie categorie;

  const CreateCategorie(this.categorie);

  @override
  List<Object?> get props => [categorie];
}

class EditCategorie extends CategorieEvent {
  final Categorie categorie;

  const EditCategorie(this.categorie);

  @override
  List<Object?> get props => [categorie];
}

class DeleteCategorie extends CategorieEvent {
  final int categorieId;
  final BuildContext context;

  const DeleteCategorie(this.categorieId, this.context);

  @override
  List<Object?> get props => [categorieId, context];
}

class GetCategorieId extends CategorieEvent {
  final String categorieName;
  final CategorieType categorieType;

  const GetCategorieId(this.categorieName, this.categorieType);

  @override
  List<Object?> get props => [categorieName, categorieType];
}

class LoadAllCategories extends CategorieEvent {
  const LoadAllCategories();
}

class LoadCategoriesWithIds extends CategorieEvent {
  final List<int> ids;

  const LoadCategoriesWithIds(this.ids);

  @override
  List<Object?> get props => [ids];
}

class CheckCategorieNameExists extends CategorieEvent {
  final Categorie categorie;
  int numberOfEventCalls;

  CheckCategorieNameExists(this.categorie, this.numberOfEventCalls);

  @override
  List<Object?> get props => [categorie, numberOfEventCalls];
}

class ExistsCategorieName extends CategorieEvent {
  final Categorie newCategorie;
  final List<Categorie> categories;
  final BuildContext context;
  int numberOfEventCalls;

  ExistsCategorieName(this.newCategorie, this.categories, this.context, this.numberOfEventCalls);

  @override
  List<Object?> get props => [newCategorie, categories];
}

class TranslateAllCategories extends CategorieEvent {
  final BuildContext context;

  const TranslateAllCategories(this.context);

  @override
  List<Object?> get props => [context];
}
