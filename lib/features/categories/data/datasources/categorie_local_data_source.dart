import 'package:sqflite/sqflite.dart';

import '../../../../core/consts/database_consts.dart';
import '../../domain/entities/categorie.dart';
import '../../domain/value_objects/categorie_type.dart';

abstract class CategorieLocalDataSource {
  Future<void> create(Categorie categorie);
  Future<void> edit(Categorie categorie);
  Future<void> delete(int id);
  Future<List<Categorie>> load(List<int> ids);
  Future<Categorie> getId(String categorieName, CategorieType categorieType);
  Future<List<Categorie>> loadAll();
  Future<bool> checkCategorieName(Categorie categorie);
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

  @override
  Future<void> delete(int id) async {
    db = await openDatabase(localDbName);
    await db.rawDelete('DELETE FROM $categorieDbName WHERE id = ?', [id]);
  }

  @override
  Future<List<Categorie>> load(List<int> ids) async {
    List<Categorie> loadedCategories = [];
    db = await openDatabase(localDbName);
    for (int i = 0; i < ids.length; i++) {
      List<Map> categorieMap = await db.rawQuery('SELECT * FROM $categorieDbName WHERE id = ?', [ids[i]]);
      Categorie categorie = Categorie(
        id: categorieMap[0]['id'],
        type: CategorieType.fromString(categorieMap[0]['type']),
        name: categorieMap[0]['name'],
      );
      loadedCategories.add(categorie);
    }
    return loadedCategories;
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
  Future<bool> checkCategorieName(Categorie categorie) async {
    db = await openDatabase(localDbName);
    List<Map> categorieMap =
        await db.rawQuery('SELECT * FROM $categorieDbName WHERE name = ? AND type = ? LIMIT 1', [categorie.name, categorie.type.name]);
    if (categorieMap.isEmpty) {
      return false;
    }
    return true;
  }
}
