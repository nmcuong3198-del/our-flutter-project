import '../../models/models.dart';
import 'report_models.dart';

class BodyStatusReportService {
  const BodyStatusReportService();

  BodyStatusReport build({
    required List<DailyCheckin> checkins,
    required DateTime fromDate,
    required DateTime toDate,
  }) {
    final from = DateTime(fromDate.year, fromDate.month, fromDate.day);
    final to = DateTime(toDate.year, toDate.month, toDate.day);
    final totalDays = to.difference(from).inDays + 1;
    final inRange = checkins.where((checkin) {
      final date = DateTime(
        checkin.date.year,
        checkin.date.month,
        checkin.date.day,
      );
      return !date.isBefore(from) && !date.isAfter(to);
    }).toList();

    final normal = <String, int>{};
    final watch = <String, int>{};
    var emotionDataDays = 0;
    var bodyDataDays = 0;
    DateTime? latest;

    for (final checkin in inRange) {
      latest = latest == null || checkin.date.isAfter(latest)
          ? checkin.date
          : latest;
      if (checkin.emotions.isNotEmpty) emotionDataDays++;
      if ((checkin.bodyStatus?.isNotEmpty ?? false) ||
          checkin.symptoms.isNotEmpty) {
        bodyDataDays++;
      }

      for (final emotion in checkin.emotions.map(_normalizeEmotion)) {
        _add(_isNormalEmotion(emotion) ? normal : watch, emotion);
      }
      if (checkin.bodyStatus != null) {
        final body = _normalizeBody(checkin.bodyStatus!);
        _add(_isNormalBody(body) ? normal : watch, body);
      }
      for (final symptom in checkin.symptoms.map(_normalizeBody)) {
        _add(_isNormalBody(symptom) ? normal : watch, symptom);
      }
    }

    final watchEntries = _sorted(watch);
    final missing = <BodyStatusEntry>[
      if (totalDays - bodyDataDays > 0)
        BodyStatusEntry(
          label: 'Không có dữ liệu cơ thể',
          days: totalDays - bodyDataDays,
        ),
      if (totalDays - emotionDataDays > 0)
        BodyStatusEntry(
          label: 'Không có dữ liệu cảm xúc',
          days: totalDays - emotionDataDays,
        ),
    ];

    return BodyStatusReport(
      latestCheckinDate: latest,
      totalDays: totalDays,
      normal: _sorted(normal),
      watchTop: watchEntries.take(3).toList(),
      allWatch: watchEntries,
      missing: missing,
    );
  }

  void _add(Map<String, int> target, String label) {
    target[label] = (target[label] ?? 0) + 1;
  }

  List<BodyStatusEntry> _sorted(Map<String, int> source) {
    return source.entries
        .map((entry) => BodyStatusEntry(label: entry.key, days: entry.value))
        .toList()
      ..sort((a, b) {
        final dayCompare = b.days.compareTo(a.days);
        if (dayCompare != 0) return dayCompare;
        return a.label.compareTo(b.label);
      });
  }

  String _normalizeEmotion(String label) {
    return switch (label) {
      'Vui' => 'Vui vẻ',
      'Chán, mệt' => 'Mệt',
      'Uể oải' => 'Kiệt sức',
      _ => label,
    };
  }

  String _normalizeBody(String label) {
    return switch (label) {
      'Khỏe' => 'Bình thường (cơ thể)',
      'Không có gì' => 'Bình thường (cơ thể)',
      'Không trong kỳ' => 'Bình thường (cơ thể)',
      _ => label,
    };
  }

  bool _isNormalEmotion(String label) {
    return label == 'Vui vẻ' || label == 'Phấn khích' || label == 'Bình thường';
  }

  bool _isNormalBody(String label) {
    return label == 'Bình thường (cơ thể)' || label == 'Khỏe';
  }
}
