import 'package:flutter/material.dart';

import '../../../domain/entities/categorie.dart';

class CategorieCard extends StatelessWidget {
  final Categorie categorie;

  const CategorieCard({
    super.key,
    required this.categorie,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        title: Text(categorie.name),
        trailing: IconButton(
          onPressed: () => {}, // TODO
          icon: const Icon(Icons.remove_circle_outline_rounded),
        ),
        onTap: () => {}, // TODO
      ),
    );
  }
}
