import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../mock/mock_data.dart';
import '../models/models.dart';

/// Comprehensive "all states" dashboard (design 4.7): every emotional, physical
/// and cycle state with per-state day counts.
class AllStatesReportScreen extends StatelessWidget {
  final ChildProfile child;
  const AllStatesReportScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final emotions = _sorted(MockData.emotionSummaryFor(child.id));
    final symptoms = _sorted(MockData.symptomSummaryFor(child.id));
    final cycle = _cycleSummary();

    final emotionMax = _maxValue(emotions);
    final symptomMax = _maxValue(symptoms);
    final cycleMax = _maxValue(cycle);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Tất cả trạng thái'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          Text(
            'Tổng hợp trạng thái của ${child.nickname} trong 30 ngày qua.',
            style: const TextStyle(fontSize: 14, height: 1.5, color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 20),
          _StateSection(
            title: 'Cảm xúc',
            icon: Icons.emoji_emotions_rounded,
            color: AppColors.primary,
            entries: emotions,
            maxValue: emotionMax,
            emptyLabel: 'Chưa có dữ liệu cảm xúc',
          ),
          const SizedBox(height: 20),
          _StateSection(
            title: 'Cơ thể',
            icon: Icons.healing_rounded,
            color: AppColors.tertiary,
            barColor: AppColors.tertiaryFixedDim,
            entries: symptoms,
            maxValue: symptomMax,
            emptyLabel: 'Chưa có dữ liệu cơ thể',
          ),
          if (child.isFemale) ...[
            const SizedBox(height: 20),
            _StateSection(
              title: 'Chu kỳ',
              icon: Icons.water_drop_rounded,
              color: AppColors.secondary,
              barColor: AppColors.secondary,
              entries: cycle,
              maxValue: cycleMax,
              emptyLabel: 'Chưa có dữ liệu chu kỳ',
            ),
          ],
        ],
      ),
    );
  }

  List<MapEntry<String, int>> _sorted(Map<String, int> m) {
    final list = m.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    return list;
  }

  int _maxValue(List<MapEntry<String, int>> entries) {
    if (entries.isEmpty) return 1;
    return entries.map((e) => e.value).reduce((a, b) => a > b ? a : b);
  }

  List<MapEntry<String, int>> _cycleSummary() {
    final cycle = MockData.cycleDataFor(child.id);
    if (cycle.isEmpty) return [];
    int yes = 0, no = 0, noData = 0;
    for (final c in cycle) {
      switch (c.status) {
        case 'yes':
          yes++;
          break;
        case 'no':
          no++;
          break;
        default:
          noData++;
      }
    }
    return [
      MapEntry('Có kinh nguyệt', yes),
      MapEntry('Không có kinh', no),
      MapEntry('Không có dữ liệu', noData),
    ]..removeWhere((e) => e.value == 0);
  }
}

class _StateSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Color? barColor;
  final List<MapEntry<String, int>> entries;
  final int maxValue;
  final String emptyLabel;

  const _StateSection({
    required this.title,
    required this.icon,
    required this.color,
    required this.entries,
    required this.maxValue,
    required this.emptyLabel,
    this.barColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: color),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (entries.isEmpty)
            Text(emptyLabel, style: const TextStyle(fontSize: 13, color: AppColors.onSurfaceVariant))
          else
            ...entries.map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 110,
                        child: Text(
                          e.key,
                          style: const TextStyle(fontSize: 13),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: maxValue == 0 ? 0 : e.value / maxValue,
                            minHeight: 10,
                            backgroundColor: AppColors.surfaceContainerHigh,
                            valueColor: AlwaysStoppedAnimation(barColor ?? color),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${e.value} ngày',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                )),
        ],
      ),
    );
  }
}
