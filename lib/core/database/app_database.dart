import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../system/app_paths.dart';

/// Owns the SQLite connection for the whole application.
///
/// Uses the FFI implementation so Windows, macOS and Linux all share the same
/// engine. The schema is created eagerly on first run.
class AppDatabase {
  AppDatabase._();

  static final AppDatabase instance = AppDatabase._();

  static const _fileName = 'sortify.db';
  static const schemaVersion = 3;

  Database? _database;

  Future<Database> get database async {
    return _database ??= await _open();
  }

  /// Must be called once before any database access.
  static void initializeFfi() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  Future<String> databasePath() async {
    await AppPaths.ensureSupportDirectory();
    return p.join(AppPaths.supportDirectory, _fileName);
  }

  Future<Database> _open() async {
    final path = await databasePath();
    return databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: schemaVersion,
        onConfigure: (db) async {
          await db.execute('PRAGMA foreign_keys = ON');
        },
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      ),
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    final batch = db.batch();

    batch.execute('''
      CREATE TABLE watched_folders (
        id TEXT PRIMARY KEY,
        path TEXT NOT NULL UNIQUE,
        enabled INTEGER NOT NULL DEFAULT 1,
        created_at INTEGER NOT NULL
      )
    ''');

    batch.execute('''
      CREATE TABLE rules (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT,
        enabled INTEGER NOT NULL DEFAULT 1,
        destination TEXT,
        action_type TEXT NOT NULL DEFAULT 'move',
        conflict_policy TEXT NOT NULL DEFAULT 'askEveryTime',
        processed_count INTEGER NOT NULL DEFAULT 0,
        last_run_at INTEGER,
        scope_path TEXT,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''');

    batch.execute('''
      CREATE TABLE conditions (
        id TEXT PRIMARY KEY,
        rule_id TEXT NOT NULL,
        type TEXT NOT NULL,
        operator TEXT NOT NULL,
        value TEXT NOT NULL,
        ordinal INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (rule_id) REFERENCES rules (id) ON DELETE CASCADE
      )
    ''');

    batch.execute('''
      CREATE TABLE actions (
        id TEXT PRIMARY KEY,
        rule_id TEXT NOT NULL,
        type TEXT NOT NULL,
        value TEXT NOT NULL,
        subfolder TEXT NOT NULL DEFAULT '',
        ordinal INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (rule_id) REFERENCES rules (id) ON DELETE CASCADE
      )
    ''');

    batch.execute('''
      CREATE TABLE file_operations (
        id TEXT PRIMARY KEY,
        rule_id TEXT,
        rule_name TEXT,
        file_name TEXT NOT NULL,
        source TEXT NOT NULL,
        destination TEXT,
        operation TEXT NOT NULL,
        status TEXT NOT NULL,
        error TEXT,
        created_at INTEGER NOT NULL
      )
    ''');

    batch.execute('CREATE INDEX idx_conditions_rule ON conditions (rule_id)');
    batch.execute('CREATE INDEX idx_actions_rule ON actions (rule_id)');
    batch.execute(
      'CREATE INDEX idx_operations_created ON file_operations (created_at DESC)',
    );
    batch.execute(
      'CREATE INDEX idx_operations_status ON file_operations (status)',
    );

    await batch.commit(noResult: true);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE rules ADD COLUMN scope_path TEXT');
    }
    if (oldVersion < 3) {
      await db.execute(
        "ALTER TABLE actions ADD COLUMN subfolder TEXT NOT NULL DEFAULT ''",
      );
    }
  }

  /// Closes the connection and deletes the database file. Used by tests and
  /// by a "reset" path in settings.
  Future<void> close() async {
    await _database?.close();
    _database = null;
  }

  Future<void> deleteDatabaseFile() async {
    await close();
    final file = File(await databasePath());
    if (await file.exists()) {
      await file.delete();
    }
  }
}
