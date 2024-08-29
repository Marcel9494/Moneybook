import 'package:sqflite/sqflite.dart';

import '../../../../core/consts/database_consts.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/user.dart';

abstract class UserLocalDataSource {
  Future<void> create(User user);
  Future<bool> checkFirstStart();
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  UserLocalDataSourceImpl();

  @override
  Future<void> create(User user) async {
    db = await openDatabase(localDbName);
    await db.rawInsert('INSERT INTO $userDbName(id, firstStart, lastStart, language, localDb) VALUES(?, ?, ?, ?, ?)', [
      user.id,
      user.firstStart,
      dateFormatterYYYYMMDD.format(user.lastStart),
      user.language,
      user.localDb,
    ]);
  }

  @override
  Future<bool> checkFirstStart() async {
    db = await openDatabase(localDbName);
    // TODO Code refactorn, damit Code einfacher zu verstehen ist und shared feature aufräumen (Dead Code entfernen)
    int? userCount = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $userDbName'));
    if (userCount == 0) {
      return true;
    }
    List<Map> userMap = await db.rawQuery('SELECT * FROM $userDbName');
    List<User> userList = userMap
        .map(
          (user) => User(
            id: user['id'],
            firstStart: user['firstStart'] == 0 ? false : true,
            lastStart: DateTime.parse(user['lastStart']),
            language: user['language'],
            localDb: user['localDb'] == 0 ? false : true,
          ),
        )
        .toList();
    return userList[0].firstStart;
  }
}
