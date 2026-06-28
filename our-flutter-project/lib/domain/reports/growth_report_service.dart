import '../../models/models.dart';
import 'report_models.dart';
import 'who_reference_service.dart';

class GrowthReportService {
  const GrowthReportService({
    this.whoReferenceService = const WhoReferenceService(),
  });

  final WhoReferenceService whoReferenceService;

  GrowthReport build({
    required ChildProfile child,
    required List<BodyMeasurement> measurements,
    required ReportFrequency frequency,
    required DateTime fromDate,
    required DateTime toDate,
  }) {
    final filtered = measurements.where((m) {
      final date = _monthDate(m.month);
      return !date.isBefore(DateTime(fromDate.year, fromDate.month)) &&
          !date.isAfter(DateTime(toDate.year, toDate.month));
    }).toList()..sort((a, b) => b.month.compareTo(a.month));

    final points = filtered.reversed.map((measurement) {
      final date = _monthDate(measurement.month);
      return GrowthReportPoint(
        date: date,
        label: _labelFor(date, frequency),
        measurement: measurement,
        who: whoReferenceService.referenceFor(child, atDate: date),
      );
    }).toList();

    if (filtered.isEmpty) {
      return const GrowthReport(summaries: [], points: []);
    }

    final latest = filtered.first;
    final comparison = filtered.length > 3 ? filtered[3] : filtered.last;
    final who = whoReferenceService.referenceFor(
      child,
      atDate: _monthDate(latest.month),
    );

    return GrowthReport(
      points: points,
      summaries: [
        _summary(
          label: 'Chiều cao',
          value: latest.height,
          unit: 'cm',
          previous: comparison.height,
          assessment: _heightAssessment(latest.height, who),
        ),
        _summary(
          label: 'Cân nặng',
          value: latest.weight,
          unit: 'kg',
          previous: comparison.weight,
          assessment: _weightAssessment(latest.weight, who),
        ),
        _summary(
          label: 'BMI',
          value: latest.bmi,
          unit: '',
          previous: comparison.bmi,
          assessment: _bmiAssessment(latest.bmi, who),
        ),
      ],
    );
  }

  DateTime clampToRangeLimit({
    required ReportFrequency frequency,
    required DateTime fromDate,
    required DateTime toDate,
  }) {
    final maxToDate = switch (frequency) {
      ReportFrequency.week => DateTime(
        fromDate.year + 1,
        fromDate.month,
        fromDate.day,
      ),
      ReportFrequency.month => DateTime(
        fromDate.year + 3,
        fromDate.month,
        fromDate.day,
      ),
      ReportFrequency.year => DateTime(
        fromDate.year + 10,
        fromDate.month,
        fromDate.day,
      ),
    };
    return toDate.isAfter(maxToDate) ? maxToDate : toDate;
  }

  GrowthMetricSummary _summary({
    required String label,
    required double value,
    required String unit,
    required double previous,
    required String assessment,
  }) {
    final delta = value - previous;
    final direction = delta > 0
        ? ReportGrowthDirection.up
        : (delta < 0 ? ReportGrowthDirection.down : ReportGrowthDirection.flat);
    final formatted = unit.isEmpty
        ? value.toStringAsFixed(1)
        : '${value.toStringAsFixed(1)} $unit';
    final deltaText =
        '${delta >= 0 ? '+' : ''}${delta.toStringAsFixed(1)}${unit.isEmpty ? '' : ' $unit'}';
    return GrowthMetricSummary(
      label: label,
      value: formatted,
      delta: delta,
      growthLabel: deltaText,
      assessment: assessment,
      direction: direction,
    );
  }

  String _heightAssessment(double value, WhoReference? who) {
    if (who == null) return 'Chưa có chuẩn WHO cho tuổi này';
    final diff = value - who.height;
    if (diff.abs() <= 5) return 'Trong ngưỡng so với chuẩn WHO';
    return diff > 0 ? 'Cao hơn so với chuẩn WHO' : 'Thấp hơn so với chuẩn WHO';
  }

  String _weightAssessment(double value, WhoReference? who) {
    if (who == null) return 'Chưa có chuẩn WHO cho tuổi này';
    final diff = value - who.weight;
    if (diff.abs() <= 5) return 'Trong ngưỡng so với chuẩn WHO';
    return diff > 0 ? 'Nặng hơn so với chuẩn WHO' : 'Nhẹ hơn so với chuẩn WHO';
  }

  String _bmiAssessment(double value, WhoReference? who) {
    if (who == null) return 'Chưa có chuẩn WHO cho tuổi này';
    final diff = value - who.bmi;
    if (diff.abs() <= 1) return 'Bình thường so với chuẩn WHO';
    return diff > 0 ? 'Thừa so với chuẩn WHO' : 'Gầy so với chuẩn WHO';
  }

  DateTime _monthDate(String month) {
    final parts = month.split('-');
    return DateTime(int.parse(parts[0]), int.parse(parts[1]));
  }

  String _labelFor(DateTime date, ReportFrequency frequency) {
    switch (frequency) {
      case ReportFrequency.week:
        return '${date.day}/${date.month}';
      case ReportFrequency.month:
        return 'T${date.month}/${date.year.toString().substring(2)}';
      case ReportFrequency.year:
        return '${date.year}';
    }
  }
}
