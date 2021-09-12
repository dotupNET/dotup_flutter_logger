import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'LoggerRepository.dart';
import 'database/DatabaseRepositoryManager.dart';
import 'database/SQLite/SqLiteDatabase.dart';

class Bootstrapper {
  Future<DatabaseRepositoryManager> initialize(String databaseFile) async {
    if (Platform.isWindows || Platform.isLinux) {
      // Initialize FFI
      sqfliteFfiInit();
      // Change the default factory
      databaseFactory = databaseFactoryFfi;
    }

    final _repositoryManager = DatabaseRepositoryManager(
      databaseFile,
    );

    _repositoryManager.register((db) => LoggerRepository(db.database));
    await _repositoryManager.initialize(version: 1);

    return _repositoryManager;
  }
}
