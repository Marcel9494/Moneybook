import 'package:equatable/equatable.dart';

import '../value_objects/categorie_type.dart';

class Categorie extends Equatable {
  final int id;
  final CategorieType type;
  final String name;

  const Categorie({
    required this.id,
    required this.type,
    required this.name,
  });

  @override
  List<Object> get props => [id, type, name];
}
