import 'package:sqflite/sqflite.dart';

import '../../domain/actions/action_catalog.dart';
import '../../domain/actions/action_generation_service.dart';
import '../../domain/actions/default_action_catalog.dart';
import '../../models/models.dart';
import '../local/app_database.dart';
import 'checkin_repository.dart';

class ActionRepository {
  ActionRepository(
    this._database, {
    CheckinRepository? checkinRepository,
    ActionGenerationService actionGenerationService =
        const ActionGenerationService(),
  }) : _checkinRepository = checkinRepository ?? CheckinRepository(_database),
       _actionGenerationService = actionGenerationService;

  static final instance = ActionRepository(AppDatabase.instance);

  final AppDatabase _database;
  final CheckinRepository _checkinRepository;
  final ActionGenerationService _actionGenerationService;

  Future<List<PracticeItem>> getOrCreateMonthlyActions({
    required ChildProfile child,
    DateTime? monthDate,
    Iterable<String> selectedTriggers = const [],
  }) async {
    final db = await _database.database;
    await _seedCatalogIfNeeded(db);

    final month = _monthKey(monthDate ?? DateTime.now());
    final existing = await _loadInstances(db, child.id, month);
    if (existing.isNotEmpty) return existing;

    final triggers = selectedTriggers.toSet();
    if (triggers.isEmpty) {
      triggers.addAll(await _checkinRepository.latestCodesForChild(child.id));
    }
    if (triggers.isEmpty) triggers.add('A3');

    final selected = _actionGenerationService.selectMonthlyActions(
      selectedTriggers: triggers,
      catalog: await _loadCatalog(db),
      recentlyUsedCatalogCodes: await _recentCatalogCodes(db, child.id),
    );
    final now = DateTime.now().millisecondsSinceEpoch;

    await db.transaction((txn) async {
      for (final item in selected) {
        await txn.insert('action_instances', {
          'id': '${child.id}_${month}_${item.category}_${item.slot}',
          'child_id': child.id,
          'month': month,
          'catalog_code': item.code,
          'category': item.category,
          'slot': item.slot,
          'title': item.content,
          'status': 'pending',
          'executor': 'Mẹ',
          'planned_week': item.slot.clamp(1, 4),
          'note': null,
          'generated_from_checkin_id': null,
          'generated_at': now,
          'updated_at': now,
          'completed_at': null,
        }, conflictAlgorithm: ConflictAlgorithm.ignore);
      }
    });

    return _loadInstances(db, child.id, month);
  }

  Future<void> setCompleted(String actionId, bool completed) async {
    final db = await _database.database;
    final now = DateTime.now().millisecondsSinceEpoch;
    await db.update(
      'action_instances',
      {
        'status': completed ? 'completed' : 'pending',
        'completed_at': completed ? now : null,
        'updated_at': now,
      },
      where: 'id = ?',
      whereArgs: [actionId],
    );
  }

  Future<void> updateActionDetails({
    required String actionId,
    required String executor,
    required int plannedWeek,
    String? note,
  }) async {
    final db = await _database.database;
    await db.update(
      'action_instances',
      {
        'executor': executor,
        'planned_week': plannedWeek.clamp(1, 4),
        'note': note?.trim().isEmpty ?? true ? null : note!.trim(),
        'updated_at': DateTime.now().millisecondsSinceEpoch,
      },
      where: 'id = ?',
      whereArgs: [actionId],
    );
  }

  Future<List<PracticeItem>> _loadInstances(
    Database db,
    String childId,
    String month,
  ) async {
    final rows = await db.query(
      'action_instances',
      where: 'child_id = ? AND month = ?',
      whereArgs: [childId, month],
      orderBy: '''
CASE category
  WHEN 'quan_sat' THEN 0
  WHEN 'giao_tiep' THEN 1
  WHEN 'ho_tro' THEN 2
  ELSE 3
END, slot ASC
''',
    );

    return rows.map((row) {
      return PracticeItem(
        id: row['id'] as String,
        childId: row['child_id'] as String,
        category: row['category'] as String,
        title: row['title'] as String,
        monthYear: row['month'] as String,
        executor: row['executor'] as String,
        plannedWeek: row['planned_week'] as int,
        isCompleted: row['status'] == 'completed',
        notes: row['note'] as String?,
      );
    }).toList();
  }

  Future<List<ActionCatalogItem>> _loadCatalog(Database db) async {
    final rows = await db.query(
      'action_catalog',
      where: 'is_active = 1',
      orderBy: 'sort_order ASC, code ASC',
    );
    return rows.map((row) {
      return ActionCatalogItem(
        code: row['code'] as String,
        triggers: (row['triggers'] as String).split(',').toSet(),
        content: row['content'] as String,
        category: row['category'] as String,
        slot: row['slot'] as int,
        gender: row['gender'] as String?,
        minAge: row['min_age'] as int?,
        maxAge: row['max_age'] as int?,
        sortOrder: row['sort_order'] as int,
      );
    }).toList();
  }

  Future<Set<String>> _recentCatalogCodes(Database db, String childId) async {
    final cutoff = DateTime.now()
        .subtract(const Duration(days: 14))
        .millisecondsSinceEpoch;
    final rows = await db.query(
      'action_instances',
      columns: ['catalog_code'],
      where: 'child_id = ? AND generated_at >= ?',
      whereArgs: [childId, cutoff],
    );
    return rows.map((row) => row['catalog_code'] as String).toSet();
  }

  Future<void> _seedCatalogIfNeeded(Database db) async {
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM action_catalog'),
    );
    if ((count ?? 0) >= defaultActionCatalog.length) return;

    final batch = db.batch();
    for (final item in defaultActionCatalog) {
      final values = {
        'code': item.code,
        'triggers': item.triggers.join(','),
        'content': item.content,
        'category': item.category,
        'slot': item.slot,
        'gender': item.gender,
        'min_age': item.minAge,
        'max_age': item.maxAge,
        'is_active': 1,
        'sort_order': item.sortOrder,
        'version': 1,
      };
      batch.insert(
        'action_catalog',
        values,
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
      batch.update(
        'action_catalog',
        values,
        where: 'code = ?',
        whereArgs: [item.code],
      );
    }
    await batch.commit(noResult: true);
  }

  String _monthKey(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    return '${date.year}-$month';
  }
}
