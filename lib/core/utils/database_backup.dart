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

Future<int> importDatabaseBackup() async {
  final result = await FilePicker.platform.pickFiles(type: FileType.any);

  if (result != null && result.files.single.path != null) {
    final importPath = result.files.single.path!;

    if (!importPath.toLowerCase().endsWith('.db')) {
      return 1;
    }

    final importFile = File(importPath);

    final databasesPath = await getDatabasesPath();
    final localDbPath = join(databasesPath, localDbName);

    if (await File(localDbPath).exists()) {
      final oldDb = await openDatabase(localDbPath);
      await oldDb.close();
      await File(localDbPath).delete();
    }

    await importFile.copy(localDbPath);

    final db = await openDatabase(localDbPath);
    try {
      await db.rawQuery('SELECT name FROM sqlite_master WHERE type="table"');
    } catch (e) {
      print('Fehler beim Lesen der importierten DB: $e');
      return 2;
    }

    print('Lokale Datenbank erfolgreich ersetzt durch: $importPath');
  } else {
    print('Es wurde keine Datei ausgewählt.');
    return 3;
  }
  return 0;
}
