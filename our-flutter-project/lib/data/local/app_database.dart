import 'dart:io' show Platform;

import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class AppDatabase {
  AppDatabase({DatabaseFactory? databaseFactory, String? path})
    : _databaseFactory = databaseFactory,
      _path = path;

  static final instance = AppDatabase();
  static const schemaVersion = 1;

  final DatabaseFactory? _databaseFactory;
  final String? _path;
  Database? _database;

  Future<Database> get database async {
    final existing = _database;
    if (existing != null) return existing;

    final factory = _databaseFactory ?? _defaultFactory();
    final dbPath = _path ?? p.join(await getDatabasesPath(), 'sscare.db');
    _database = await factory.openDatabase(
      dbPath,
      options: OpenDatabaseOptions(
        version: schemaVersion,
        onConfigure: (db) async => db.execute('PRAGMA foreign_keys = ON'),
        onCreate: _createSchema,
      ),
    );
    return _database!;
  }

  Future<void> close() async {
    final existing = _database;
    _database = null;
    await existing?.close();
  }

  DatabaseFactory _defaultFactory() {
    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      return databaseFactoryFfi;
    }
    return databaseFactory;
  }

  Future<void> _createSchema(Database db, int version) async {
    final batch = db.batch();
    batch.execute('''
CREATE TABLE action_catalog (
  code TEXT PRIMARY KEY,
  triggers TEXT NOT NULL,
  content TEXT NOT NULL,
  category TEXT NOT NULL,
  slot INTEGER NOT NULL DEFAULT 1,
  gender TEXT,
  min_age INTEGER,
  max_age INTEGER,
  is_active INTEGER NOT NULL DEFAULT 1,
  sort_order INTEGER NOT NULL DEFAULT 0,
  version INTEGER NOT NULL DEFAULT 1
)
''');
    batch.execute('''
CREATE TABLE action_instances (
  id TEXT PRIMARY KEY,
  child_id TEXT NOT NULL,
  month TEXT NOT NULL,
  catalog_code TEXT NOT NULL,
  category TEXT NOT NULL,
  slot INTEGER NOT NULL,
  title TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending',
  executor TEXT NOT NULL DEFAULT 'Mẹ',
  planned_week INTEGER NOT NULL DEFAULT 1,
  note TEXT,
  generated_from_checkin_id TEXT,
  generated_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL,
  completed_at INTEGER,
  UNIQUE(child_id, month, category, slot),
  FOREIGN KEY(catalog_code) REFERENCES action_catalog(code)
)
''');
    batch.execute('''
CREATE TABLE checkins (
  id TEXT PRIMARY KEY,
  child_id TEXT NOT NULL,
  date TEXT NOT NULL,
  notes TEXT,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL,
  UNIQUE(child_id, date)
)
''');
    batch.execute('''
CREATE TABLE checkin_codes (
  checkin_id TEXT NOT NULL,
  code TEXT NOT NULL,
  type TEXT NOT NULL,
  label TEXT NOT NULL,
  PRIMARY KEY(checkin_id, code),
  FOREIGN KEY(checkin_id) REFERENCES checkins(id) ON DELETE CASCADE
)
''');
    batch.execute(
      'CREATE INDEX idx_action_instances_child_month ON action_instances(child_id, month)',
    );
    batch.execute(
      'CREATE INDEX idx_action_instances_recent ON action_instances(child_id, generated_at)',
    );
    batch.execute(
      'CREATE INDEX idx_checkins_child_date ON checkins(child_id, date)',
    );
    await batch.commit(noResult: true);
  }
}
