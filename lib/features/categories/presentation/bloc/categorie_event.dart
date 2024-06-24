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
  final BuildContext context;

  const EditCategorie(this.categorie, this.context);

  @override
  List<Object?> get props => [categorie, context];
}

class DeleteCategorie extends CategorieEvent {
  final int categorieId;
  final BuildContext context;

  const DeleteCategorie(this.categorieId, this.context);

  @override
  List<Object?> get props => [categorieId, context];
}

class LoadAllCategories extends CategorieEvent {
  const LoadAllCategories();
}
