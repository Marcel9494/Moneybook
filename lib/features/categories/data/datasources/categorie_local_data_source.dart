import 'package:sqflite/sqflite.dart';

import '../../domain/entities/categorie.dart';
import '../../domain/value_objects/categorie_type.dart';
import '../models/categorie_model.dart';

abstract class CategorieLocalDataSource {
  Future<void> create(Categorie cateogrie);
  Future<void> update(Categorie cateogrie);
  Future<void> delete(int id);
  Future<CategorieModel> load(int id);
  Future<List<Categorie>> loadAll(CategorieType categorieType);
}

class CategorieLocalDataSourceImpl implements CategorieLocalDataSource {
  CategorieLocalDataSourceImpl();

  static const String categorieDbName = 'categories';
  var db;

  Future<void> openCategorieDatabase() async {
    db = await openDatabase('$categorieDbName.db', version: 1, onCreate: (Database db, int version) async {
      await db.execute('''
          CREATE TABLE IF NOT EXISTS $categorieDbName (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            type TEXT NOT NULL,
            name TEXT NOT NULL
          )
          ''');
    });
  }

  @override
  Future<void> create(Categorie categorie) async {
    await openCategorieDatabase();
    await db.rawInsert('INSERT INTO $categorieDbName(type, name) VALUES(?, ?)', [
      categorie.type.name,
      categorie.name,
    ]);
    // TODO hier weitermachen und schauen warum id nicht automatisch hochgezählt wird und anschließend Kategorie Listen UI implementieren
    print(categorie);
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
  Future<List<Categorie>> loadAll(CategorieType categorieType) {
    // TODO: implement loadAll
    throw UnimplementedError();
  }

  @override
  Future<void> update(Categorie categorie) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
