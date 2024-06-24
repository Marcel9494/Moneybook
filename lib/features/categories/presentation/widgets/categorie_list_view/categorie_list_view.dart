import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/categorie.dart';
import '../../bloc/categorie_bloc.dart';

class CategorieListView extends StatelessWidget {
  final UniqueKey uniqueKey;

  CategorieListView({
    super.key,
    required this.uniqueKey,
  });

  // TODO hier weitermachen und ListView in ListPage hochziehen + _key, dann Kategorie hinzufügen implementieren in Bottom Sheet
  final GlobalKey<AnimatedListState> _key = GlobalKey();

  void _deleteCategorie(BuildContext context, Categorie categorie, int index) {
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
                _key.currentState!.removeItem(
                  index,
                  (context, animation) {
                    return SizeTransition(
                      sizeFactor: animation,
                      child: const Card(
                        margin: EdgeInsets.all(10.0),
                        color: Colors.red,
                        child: ListTile(
                          title: Text('Gelöscht'),
                        ),
                      ),
                    );
                  },
                  duration: const Duration(milliseconds: 1000),
                );
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
    return Text('Entfernen');
    /*return BlocBuilder<CategorieBloc, CategorieState>(
      builder: (context, state) {
        if (state is Loaded) {
          return AnimatedList(
            key: _key,
            initialItemCount: state.categories.length,
            itemBuilder: (context, index, animation) {
              if (state.categories.isEmpty) {
                return const Text('Keine Kategorien vorhanden.');
              } else {
                return Card(
                  child: ListTile(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    ),
                    title: Text(state.categories[index].name),
                    trailing: IconButton(
                      onPressed: () => _deleteCategorie(context, state.categories[index], index),
                      icon: const Icon(Icons.remove_circle_outline_rounded),
                    ),
                    onTap: () => {}, // TODO
                  ),
                );
              }
            },
          );
        }
        return const SizedBox();
      },
    );*/
  }
}
