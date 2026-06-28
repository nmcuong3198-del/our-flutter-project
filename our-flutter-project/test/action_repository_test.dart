import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sscare/data/local/app_database.dart';
import 'package:sscare/data/repositories/action_repository.dart';
import 'package:sscare/data/repositories/checkin_repository.dart';
import 'package:sscare/domain/actions/action_catalog.dart';
import 'package:sscare/domain/actions/action_generation_service.dart';
import 'package:sscare/domain/actions/default_action_catalog.dart';
import 'package:sscare/domain/checkin/checkin_code_mapper.dart';
import 'package:sscare/models/models.dart';

void main() {
  sqfliteFfiInit();

  late AppDatabase database;
  late CheckinRepository checkinRepository;
  late ActionRepository actionRepository;

  final child = ChildProfile(
    id: 'child-1',
    nickname: 'Minh Anh',
    dateOfBirth: DateTime(2014, 3, 15),
    gender: Gender.female,
    avatarColor: Colors.pink,
  );

  setUp(() {
    database = AppDatabase(
      databaseFactory: databaseFactoryFfi,
      path: inMemoryDatabasePath,
    );
    checkinRepository = CheckinRepository(database);
    actionRepository = ActionRepository(
      database,
      checkinRepository: checkinRepository,
    );
  });

  tearDown(() async {
    await database.close();
  });

  test('loads the full BRD action catalog', () {
    expect(defaultActionCatalog, hasLength(208));
    expect(defaultActionCatalog.first.code, 'ACT_01');
    expect(defaultActionCatalog.last.code, 'ACT_208');
  });

  test('maps all Check-in BRD emotion statuses used by actions', () {
    final codes = CheckinCodeMapper.codesFor(
      emotions: const [
        'Vui vẻ',
        'Phấn khích',
        'Bình thường',
        'Mệt',
        'Buồn',
        'Lo lắng',
        'Áp lực',
        'Cáu',
        'Cô đơn',
        'Kiệt sức',
        'Khác',
      ],
    );

    expect(codes, containsAll(['A1', 'A2', 'A3', 'A4', 'A5', 'A6']));
    expect(codes, containsAll(['A7', 'A8', 'A9', 'A10', 'A11']));
  });

  test(
    'generates one monthly action per category from saved check-in codes',
    () async {
      await checkinRepository.saveCheckin(
        childId: child.id,
        date: DateTime(2026, 6, 28),
        selections: const [
          CheckinCodeSelection(code: 'A10', type: 'emotion', label: 'Kiệt sức'),
        ],
      );

      final actions = await actionRepository.getOrCreateMonthlyActions(
        child: child,
        monthDate: DateTime(2026, 6),
      );

      expect(actions, hasLength(3));
      expect(actions.map((action) => action.category), [
        'quan_sat',
        'giao_tiep',
        'ho_tro',
      ]);
      expect(actions.every((action) => !action.isCompleted), isTrue);
      expect(
        actions.map((action) => action.title).join('\n'),
        contains('4-4-4'),
      );
    },
  );

  test('keeps generated monthly action edits when called again', () async {
    final actions = await actionRepository.getOrCreateMonthlyActions(
      child: child,
      monthDate: DateTime(2026, 6),
      selectedTriggers: const ['A8'],
    );
    await actionRepository.setCompleted(actions.first.id, true);

    final reloaded = await actionRepository.getOrCreateMonthlyActions(
      child: child,
      monthDate: DateTime(2026, 6),
      selectedTriggers: const ['A10'],
    );

    expect(reloaded, hasLength(3));
    expect(reloaded.first.id, actions.first.id);
    expect(reloaded.first.title, actions.first.title);
    expect(reloaded.first.isCompleted, isTrue);
  });

  test('persists editable executor week and note fields', () async {
    final actions = await actionRepository.getOrCreateMonthlyActions(
      child: child,
      monthDate: DateTime(2026, 7),
      selectedTriggers: const ['A5'],
    );

    await actionRepository.updateActionDetails(
      actionId: actions.first.id,
      executor: 'Bố',
      plannedWeek: 4,
      note: 'Con muốn nói chuyện sau bữa tối.',
    );

    final reloaded = await actionRepository.getOrCreateMonthlyActions(
      child: child,
      monthDate: DateTime(2026, 7),
      selectedTriggers: const ['A10'],
    );

    expect(reloaded.first.executor, 'Bố');
    expect(reloaded.first.plannedWeek, 4);
    expect(reloaded.first.notes, 'Con muốn nói chuyện sau bữa tối.');
  });

  test(
    'maps influence selections into C triggers for action generation',
    () async {
      final selections = CheckinCodeMapper.selectionsFor(
        influences: const ['Học tập'],
      );
      await checkinRepository.saveCheckin(
        childId: child.id,
        date: DateTime(2026, 8, 1),
        selections: selections,
      );

      final actions = await actionRepository.getOrCreateMonthlyActions(
        child: child,
        monthDate: DateTime(2026, 8),
      );

      expect(actions, hasLength(3));
      expect(actions.first.title, contains('góc học tập'));
      expect(actions.map((action) => action.title).join('\n'), contains('học'));
    },
  );

  test('prioritizes trigger order and skips recently used catalog codes', () {
    const service = ActionGenerationService();
    const catalog = [
      ActionCatalogItem(
        code: 'RECENT_HIGH',
        triggers: {'A10'},
        content: 'recent high priority',
        category: 'quan_sat',
      ),
      ActionCatalogItem(
        code: 'NEXT_TRIGGER',
        triggers: {'A3'},
        content: 'next trigger fallback',
        category: 'quan_sat',
      ),
      ActionCatalogItem(
        code: 'HIGH_COMMUNICATION',
        triggers: {'A10'},
        content: 'high priority communication',
        category: 'giao_tiep',
      ),
    ];

    final selected = service.selectMonthlyActions(
      selectedTriggers: const ['A3', 'A10'],
      catalog: catalog,
      recentlyUsedCatalogCodes: const ['RECENT_HIGH'],
    );

    expect(selected.map((item) => item.code), [
      'NEXT_TRIGGER',
      'HIGH_COMMUNICATION',
    ]);
  });
}
