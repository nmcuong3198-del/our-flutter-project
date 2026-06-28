import 'package:flutter/material.dart';

import 'report_models.dart';

class CycleReportService {
  const CycleReportService();

  CycleReport build({
    required List<DateTimeRange> periods,
    required DateTime endDate,
    int? userCycleLength,
  }) {
    final months = _monthRows(periods: periods, endDate: endDate);
    final starts =
        periods.map((range) => DateUtils.dateOnly(range.start)).toList()
          ..sort((a, b) => b.compareTo(a));
    final cycleGaps = <int>[];
    for (var i = 0; i < starts.length - 1; i++) {
      cycleGaps.add(starts[i].difference(starts[i + 1]).inDays);
    }

    final estimated = _estimatedCycleLength(cycleGaps, userCycleLength);
    final latestStart = starts.isEmpty ? null : starts.first;
    final next = latestStart == null || estimated == null
        ? null
        : latestStart.add(Duration(days: estimated));
    final today = DateUtils.dateOnly(DateTime.now());
    final daysUntil = next?.difference(today).inDays;

    return CycleReport(
      months: months,
      assessment: _assessment(months),
      prediction: _prediction(periods.length, daysUntil, userCycleLength),
      estimatedCycleLength: estimated,
      loggedPeriodCount: periods.length,
      nextPeriodDate: next,
      daysUntilPeriod: daysUntil,
    );
  }

  List<CycleMonthReport> _monthRows({
    required List<DateTimeRange> periods,
    required DateTime endDate,
  }) {
    final endMonth = DateTime(endDate.year, endDate.month);
    final earliest = periods.isEmpty ? null : periods.last.start;
    return List.generate(12, (index) {
      final month = DateTime(endMonth.year, endMonth.month - index);
      final periodDays = _periodDaysInMonth(periods, month);
      final status = periodDays > 0
          ? 'yes'
          : (earliest == null ||
                    month.isBefore(DateTime(earliest.year, earliest.month))
                ? 'nodata'
                : 'no');
      return CycleMonthReport(
        month: month,
        status: status,
        periodDays: status == 'nodata' ? null : periodDays,
      );
    });
  }

  int _periodDaysInMonth(List<DateTimeRange> periods, DateTime month) {
    var count = 0;
    for (final range in periods) {
      for (
        var day = DateUtils.dateOnly(range.start);
        !day.isAfter(range.end);
        day = day.add(const Duration(days: 1))
      ) {
        if (day.year == month.year && day.month == month.month) count++;
      }
    }
    return count;
  }

  String _assessment(List<CycleMonthReport> months) {
    final lastThree = months.take(3).toList();
    if (lastThree.any((month) => month.status == 'nodata')) {
      return 'Chưa có đủ dữ liệu để đánh giá. Phụ huynh cần nhập thông tin đầy đủ trong 3 tháng để SSCare hỗ trợ tốt nhất';
    }
    if (lastThree.any((month) => month.status == 'no')) {
      return 'Chưa ổn định (bình thường ở độ tuổi này)';
    }
    return 'Kinh nguyệt bình thường';
  }

  int? _estimatedCycleLength(List<int> gaps, int? userCycleLength) {
    if (gaps.isEmpty) return userCycleLength;
    if (gaps.length == 1) return userCycleLength ?? _clamp(gaps.first);
    if (gaps.length <= 4) {
      final average = gaps.reduce((a, b) => a + b) / gaps.length;
      final estimate = userCycleLength == null
          ? average
          : average * 0.6 + userCycleLength * 0.4;
      return _clamp(estimate.round());
    }
    const weights = [0.40, 0.25, 0.15, 0.10, 0.05, 0.05];
    var weighted = 0.0;
    var totalWeight = 0.0;
    for (var i = 0; i < gaps.length && i < weights.length; i++) {
      weighted += gaps[i] * weights[i];
      totalWeight += weights[i];
    }
    return _clamp((weighted / totalWeight).round());
  }

  String _prediction(
    int loggedPeriodCount,
    int? daysUntil,
    int? userCycleLength,
  ) {
    if (daysUntil == null ||
        (loggedPeriodCount <= 1 && userCycleLength == null)) {
      return 'Hãy thêm thông tin chu kỳ kinh để SSCare bắt đầu dự báo.';
    }
    if (daysUntil > 30) return 'Dự kiến kỳ kinh tiếp theo: Khoảng 1 tháng nữa';
    if (daysUntil >= 8) {
      return 'Dự kiến kỳ kinh tiếp theo: Khoảng $daysUntil - ${daysUntil + 2} ngày nữa';
    }
    if (daysUntil >= 3) {
      return 'Có thể con sắp đến kỳ kinh trong vài ngày nữa';
    }
    if (daysUntil >= 1) {
      return 'Khoảng $daysUntil - ${daysUntil + 2} ngày nữa con có thể đến kỳ';
    }
    if (daysUntil == 0) return 'Kỳ kinh có thể sắp bắt đầu';
    if (daysUntil >= -7) {
      return 'Kỳ kinh có vẻ đến muộn hơn dự kiến. Hiện trễ khoảng ${-daysUntil} ngày';
    }
    if (daysUntil > -21) {
      return 'Chu kỳ lần này thay đổi nhiều hơn bình thường. Đã trễ khoảng ${-daysUntil} ngày';
    }
    return 'Chu kỳ lần này thay đổi khá nhiều. Nếu kéo dài hoặc khiến phụ huynh lo lắng, có thể trao đổi với con hoặc chuyên gia sức khỏe.';
  }

  int _clamp(int value) => value.clamp(21, 45);
}
