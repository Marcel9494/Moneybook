part of 'categorie_bloc.dart';

sealed class CategorieEvent extends Equatable {
  const CategorieEvent();
}

class CreateCategorie extends CategorieEvent {
  final Categorie categorie;

  const CreateCategorie(this.categorie);

  @override
  List<Object?> get props => [categorie];
}
