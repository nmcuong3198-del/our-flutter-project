import '../../models/models.dart';

enum ReportFrequency { week, month, year }

extension ReportFrequencyLabel on ReportFrequency {
  String get label {
    switch (this) {
      case ReportFrequency.week:
        return 'Tuần';
      case ReportFrequency.month:
        return 'Tháng';
      case ReportFrequency.year:
        return 'Năm';
    }
  }
}

class WhoReference {
  final int age;
  final double height;
  final double weight;
  final double bmi;

  const WhoReference({
    required this.age,
    required this.height,
    required this.weight,
    required this.bmi,
  });
}

class GrowthMetricSummary {
  final String label;
  final String value;
  final double? delta;
  final String growthLabel;
  final String assessment;
  final ReportGrowthDirection direction;

  const GrowthMetricSummary({
    required this.label,
    required this.value,
    required this.delta,
    required this.growthLabel,
    required this.assessment,
    required this.direction,
  });
}

enum ReportGrowthDirection { up, flat, down, unknown }

class GrowthReportPoint {
  final DateTime date;
  final String label;
  final BodyMeasurement measurement;
  final WhoReference? who;

  const GrowthReportPoint({
    required this.date,
    required this.label,
    required this.measurement,
    required this.who,
  });
}

class GrowthReport {
  final List<GrowthMetricSummary> summaries;
  final List<GrowthReportPoint> points;

  const GrowthReport({required this.summaries, required this.points});
}

class BodyStatusEntry {
  final String label;
  final int days;

  const BodyStatusEntry({required this.label, required this.days});
}

class BodyStatusReport {
  final DateTime? latestCheckinDate;
  final int totalDays;
  final List<BodyStatusEntry> normal;
  final List<BodyStatusEntry> watchTop;
  final List<BodyStatusEntry> allWatch;
  final List<BodyStatusEntry> missing;

  const BodyStatusReport({
    required this.latestCheckinDate,
    required this.totalDays,
    required this.normal,
    required this.watchTop,
    required this.allWatch,
    required this.missing,
  });
}

class CycleMonthReport {
  final DateTime month;
  final String status;
  final int? periodDays;

  const CycleMonthReport({
    required this.month,
    required this.status,
    required this.periodDays,
  });
}

class CycleReport {
  final List<CycleMonthReport> months;
  final String assessment;
  final String prediction;
  final int? estimatedCycleLength;
  final int loggedPeriodCount;
  final DateTime? nextPeriodDate;
  final int? daysUntilPeriod;

  const CycleReport({
    required this.months,
    required this.assessment,
    required this.prediction,
    required this.estimatedCycleLength,
    required this.loggedPeriodCount,
    required this.nextPeriodDate,
    required this.daysUntilPeriod,
  });
}
