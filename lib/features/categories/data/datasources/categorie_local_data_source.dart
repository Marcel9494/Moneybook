import 'package:sqflite/sqflite.dart';

import '../../../../core/consts/database_consts.dart';
import '../../domain/entities/categorie.dart';
import '../../domain/value_objects/categorie_type.dart';
import '../models/categorie_model.dart';

abstract class CategorieLocalDataSource {
  Future<void> create(Categorie categorie);
  Future<void> edit(Categorie categorie);
  Future<void> delete(int id);
  Future<CategorieModel> load(int id);
  Future<Categorie> getId(String categorieName, CategorieType categorieType);
  Future<List<Categorie>> loadAll();
}

class CategorieLocalDataSourceImpl implements CategorieLocalDataSource {
  CategorieLocalDataSourceImpl();

  @override
  Future<void> create(Categorie categorie) async {
    db = await openDatabase(localDbName);
    await db.rawInsert('INSERT INTO $categorieDbName(type, name) VALUES(?, ?)', [
      categorie.type.name,
      categorie.name,
    ]);
  }

  @override
  Future<void> delete(int id) async {
    db = await openDatabase(localDbName);
    await db.rawDelete('DELETE FROM $categorieDbName WHERE id = ?', [id]);
  }

  @override
  Future<CategorieModel> load(int id) {
    // TODO: implement load
    throw UnimplementedError();
  }

  @override
  Future<Categorie> getId(String categorieName, CategorieType categorieType) async {
    db = await openDatabase(localDbName);
    List<Map> selectedCategorie =
        await db.rawQuery('SELECT * FROM $categorieDbName WHERE name = ? AND type = ?', [categorieName, categorieType.name]);
    List<Categorie> categorie = selectedCategorie
        .map(
          (categorie) => Categorie(
            id: categorie['id'],
            type: CategorieType.fromString(categorie['type']),
            name: categorie['name'],
          ),
        )
        .toList();
    return categorie[0];
  }

  @override
  Future<List<Categorie>> loadAll() async {
    db = await openDatabase(localDbName);
    List<Map> categorieMap = await db.rawQuery('SELECT * FROM $categorieDbName');
    List<Categorie> categorieList = categorieMap
        .map(
          (categorie) => Categorie(
            id: categorie['id'],
            type: CategorieType.fromString(categorie['type']),
            name: categorie['name'],
          ),
        )
        .toList();
    return categorieList;
  }

  @override
  Future<void> edit(Categorie categorie) async {
    db = await openDatabase(localDbName);
    try {
      await db.rawUpdate('UPDATE $categorieDbName SET id = ?, type = ?, name = ? WHERE id = ?', [
        categorie.id,
        categorie.type.name,
        categorie.name,
        categorie.id,
      ]);
    } catch (e) {
      // TODO Fehler richtig behandeln
      print('Error: $e');
    }
  }
}
