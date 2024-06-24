/*import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/categorie.dart';
import '../../bloc/categorie_bloc.dart';

class CategorieCard extends StatelessWidget {
  final Categorie categorie;
  final GlobalKey globalKey;

  const CategorieCard({
    super.key,
    required this.categorie,
    required this.globalKey,
  });

  void deleteCategorie(BuildContext context, int index) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Kategorie löschen?'),
          content: Text('Wollen Sie die Kategorie ${categorie.name} wirklich löschen?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Ja'),
              onPressed: () {
                globalKey.currentState!.removeItem(index,)
                BlocProvider.of<CategorieBloc>(context).add(
                      DeleteCategorie(categorie.id, context),
                    );
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Nein'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        title: Text(categorie.name),
        trailing: IconButton(
          onPressed: () => deleteCategorie(context),
          icon: const Icon(Icons.remove_circle_outline_rounded),
        ),
        onTap: () => {}, // TODO
      ),
    );
  }
}*/
