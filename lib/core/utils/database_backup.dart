import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqflite/sqflite.dart';

import '../consts/database_consts.dart';

Future<void> exportDatabaseBackup() async {
  final databasesPath = await getDatabasesPath();
  final dbPath = join(databasesPath, localDbName);

  final dbFile = File(dbPath);
  if (await dbFile.exists()) {
    final tempDir = await getTemporaryDirectory();
    final exportFile = await dbFile.copy(join(tempDir.path, 'database_backup.db'));

    // Backup Datei teilen (z.B. per E-Mail, WhatsApp etc.)
    await Share.shareXFiles([XFile(exportFile.path)], text: 'Datenbank-Backup Datei von Moneybook');
  } else {
    print('Datenbank wurde nicht gefunden.');
  }
}

Future<void> importDatabaseBackup() async {
  print('Test');
  final result = await FilePicker.platform.pickFiles(
    type: FileType.any,
  );

  if (result != null && result.files.single.path != null) {
    final importPath = result.files.single.path!;
    final importFile = File(importPath);

    final databasesBackupPath = await getDatabasesPath();
    String dbPath = join(databasesBackupPath, 'database_backup.db');

    // Wichtig: Existierende Datenbank vorher schließen, wenn offen
    db = await openDatabase(localDbName);
    await db.close();

    final dbFile = File(dbPath);
    if (await dbFile.exists()) {
      await dbFile.delete();
    }

    dbPath = join(await getDatabasesPath(), 'database_backup.db');
    db = await openDatabase(dbPath);

    await importFile.copy(dbPath);

    // TODO hier weitermachen warum funktioniert der Import noch nicht?
    //final test = await db.rawQuery('SELECT name FROM sqlite_master WHERE type="table"');
    //print('Tabellen: $test');
    final rows = await db.query('SELECT * FROM $bookingDbName');
    print('Importierte Daten: $rows');

    print('Datenbank Backup importiert von: $importPath');
  } else {
    print('Es wurde keine Datei ausgewählt.');
  }
}
