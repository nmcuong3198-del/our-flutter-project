import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sscare/domain/reports/body_status_report_service.dart';
import 'package:sscare/domain/reports/cycle_report_service.dart';
import 'package:sscare/domain/reports/growth_report_service.dart';
import 'package:sscare/domain/reports/report_models.dart';
import 'package:sscare/domain/reports/who_reference_service.dart';
import 'package:sscare/models/models.dart';

void main() {
  const whoService = WhoReferenceService();

  final female = ChildProfile(
    id: '1',
    nickname: 'Minh Anh',
    dateOfBirth: DateTime(2014, 3, 15),
    gender: Gender.female,
    avatarColor: Colors.pink,
  );

  test('WHO reference covers BRD ages 5 to 18 for boys and girls', () {
    expect(
      WhoReferenceService.boys.keys,
      containsAll(List.generate(14, (i) => i + 5)),
    );
    expect(
      WhoReferenceService.girls.keys,
      containsAll(List.generate(14, (i) => i + 5)),
    );
    expect(WhoReferenceService.boys[18]!.height, 176);
    expect(WhoReferenceService.girls[18]!.bmi, 21.3);
  });

  test('growth report builds BRD summaries and WHO assessment', () {
    const service = GrowthReportService(whoReferenceService: whoService);
    final report = service.build(
      child: female,
      measurements: const [
        BodyMeasurement(
          childId: '1',
          month: '2026-06',
          height: 156,
          weight: 45,
        ),
        BodyMeasurement(
          childId: '1',
          month: '2026-05',
          height: 155,
          weight: 44,
        ),
        BodyMeasurement(
          childId: '1',
          month: '2026-04',
          height: 154,
          weight: 43,
        ),
        BodyMeasurement(
          childId: '1',
          month: '2026-03',
          height: 153,
          weight: 42,
        ),
      ],
      frequency: ReportFrequency.month,
      fromDate: DateTime(2026, 3),
      toDate: DateTime(2026, 6),
    );

    expect(report.summaries, hasLength(3));
    expect(report.summaries.first.label, 'Chiều cao');
    expect(report.summaries.first.growthLabel, '+3.0 cm');
    expect(report.summaries.first.assessment, contains('WHO'));
    expect(report.points, hasLength(4));
    expect(report.points.first.who, isNotNull);
  });

  test('body status report separates normal watch and missing data', () {
    const service = BodyStatusReportService();
    final report = service.build(
      fromDate: DateTime(2026, 6, 1),
      toDate: DateTime(2026, 6, 5),
      checkins: [
        DailyCheckin(
          childId: '1',
          date: DateTime(2026, 6, 1),
          emotions: const ['Vui vẻ'],
          bodyStatus: 'Không trong kỳ',
          symptoms: const ['Khỏe'],
        ),
        DailyCheckin(
          childId: '1',
          date: DateTime(2026, 6, 2),
          emotions: const ['Lo lắng', 'Buồn'],
          symptoms: const ['Đau đầu'],
        ),
        DailyCheckin(
          childId: '1',
          date: DateTime(2026, 6, 3),
          emotions: const ['Lo lắng'],
          symptoms: const ['Đau bụng'],
        ),
      ],
    );

    expect(report.normal.map((e) => e.label), contains('Vui vẻ'));
    expect(report.watchTop.first.label, 'Lo lắng');
    expect(report.watchTop, hasLength(3));
    expect(
      report.missing.map((e) => e.label),
      contains('Không có dữ liệu cơ thể'),
    );
    expect(
      report.missing.map((e) => e.label),
      contains('Không có dữ liệu cảm xúc'),
    );
  });

  test(
    'cycle report follows BRD last-three-month assessment and prediction',
    () {
      const service = CycleReportService();
      final today = DateUtils.dateOnly(DateTime.now());
      final periods = [
        DateTimeRange(
          start: today.subtract(const Duration(days: 28)),
          end: today.subtract(const Duration(days: 24)),
        ),
        DateTimeRange(
          start: today.subtract(const Duration(days: 56)),
          end: today.subtract(const Duration(days: 52)),
        ),
        DateTimeRange(
          start: today.subtract(const Duration(days: 84)),
          end: today.subtract(const Duration(days: 80)),
        ),
      ];

      final report = service.build(periods: periods, endDate: today);

      expect(report.estimatedCycleLength, 28);
      expect(report.assessment, isNotEmpty);
      expect(report.prediction, isNotEmpty);
      expect(report.months, hasLength(12));
    },
  );
}
