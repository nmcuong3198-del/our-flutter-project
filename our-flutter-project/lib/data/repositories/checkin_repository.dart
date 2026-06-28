import 'package:sqflite/sqflite.dart';

import '../../domain/checkin/checkin_code_mapper.dart';
import '../local/app_database.dart';

class CheckinRepository {
  CheckinRepository(this._database);

  static final instance = CheckinRepository(AppDatabase.instance);

  final AppDatabase _database;

  Future<Set<String>> saveCheckin({
    required String childId,
    required DateTime date,
    required Iterable<CheckinCodeSelection> selections,
    String? notes,
  }) async {
    final db = await _database.database;
    final checkinId = '${childId}_${_dateKey(date)}';
    final now = DateTime.now().millisecondsSinceEpoch;
    final codes = selections.toList();

    await db.transaction((txn) async {
      await txn.insert('checkins', {
        'id': checkinId,
        'child_id': childId,
        'date': _dateKey(date),
        'notes': notes,
        'created_at': now,
        'updated_at': now,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
      await txn.delete(
        'checkin_codes',
        where: 'checkin_id = ?',
        whereArgs: [checkinId],
      );
      for (final selection in codes) {
        await txn.insert('checkin_codes', {
          'checkin_id': checkinId,
          'code': selection.code,
          'type': selection.type,
          'label': selection.label,
        });
      }
    });

    return codes.map((selection) => selection.code).toSet();
  }

  Future<Set<String>> latestCodesForChild(String childId) async {
    final db = await _database.database;
    final checkins = await db.query(
      'checkins',
      columns: ['id'],
      where: 'child_id = ?',
      whereArgs: [childId],
      orderBy: 'date DESC',
      limit: 1,
    );
    if (checkins.isEmpty) return const {};

    final rows = await db.query(
      'checkin_codes',
      columns: ['code'],
      where: 'checkin_id = ?',
      whereArgs: [checkins.first['id']],
    );
    return rows.map((row) => row['code'] as String).toSet();
  }

  String _dateKey(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }
}
