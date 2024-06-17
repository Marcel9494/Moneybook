import 'package:sqflite/sqflite.dart';

import '../../domain/entities/categorie.dart';
import '../../domain/value_objects/categorie_type.dart';
import '../models/categorie_model.dart';

abstract class CategorieLocalDataSource {
  Future<void> create(Categorie categorie);
  Future<void> update(Categorie categorie);
  Future<void> delete(int id);
  Future<CategorieModel> load(int id);
  Future<List<Categorie>> loadAll(CategorieType categorieType);
}

class CategorieLocalDataSourceImpl implements CategorieLocalDataSource {
  CategorieLocalDataSourceImpl();

  static const String categorieDbName = 'categories';
  var db;

  Future<dynamic> openCategorieDatabase(String databaseName) async {
    db = await openDatabase('$databaseName.db', version: 1, onCreate: (Database db, int version) async {
      await db.execute('''
          CREATE TABLE IF NOT EXISTS $databaseName (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            type TEXT NOT NULL,
            name TEXT NOT NULL
          )
          ''');
    });
    return db;
  }

  @override
  Future<void> create(Categorie categorie) async {
    db = await openCategorieDatabase(categorieDbName);
    await db.rawInsert('INSERT INTO $categorieDbName(type, name) VALUES(?, ?)', [
      categorie.type.name,
      categorie.name,
    ]);
  }

  @override
  Future<void> delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<CategorieModel> load(int id) {
    // TODO: implement load
    throw UnimplementedError();
  }

  @override
  Future<List<Categorie>> loadAll(CategorieType categorieType) async {
    db = await openCategorieDatabase(categorieDbName);
    List<Map> categorieMap = await db.rawQuery('SELECT * FROM $categorieDbName WHERE type = ?', [categorieType.name]);
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
  Future<void> update(Categorie categorie) {
    // TODO: implement update
    throw UnimplementedError();
  }
}