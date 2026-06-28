import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../core/strings.dart';
import '../core/theme.dart';
import '../mock/mock_data.dart';
import '../models/models.dart';
import 'all_states_report_screen.dart';
import 'height_prediction_screen.dart';

class ReportsTab extends StatefulWidget {
  final ChildProfile child;

  const ReportsTab({super.key, required this.child});

  @override
  State<ReportsTab> createState() => _ReportsTabState();
}

class _ReportsTabState extends State<ReportsTab> {
  String _filter = '6 tháng';
  static const _filters = ['6 tháng', '12 tháng', '24 tháng', '5 năm'];

  int get _monthCount {
    switch (_filter) {
      case '12 tháng': return 12;
      case '24 tháng': return 24;
      case '5 năm': return 60;
      default: return 6;
    }
  }

  @override
  Widget build(BuildContext context) {
    final allMeasurements = MockData.measurementsFor(widget.child.id);
    final measurements = allMeasurements.take(_monthCount).toList();
    final checkins = MockData.checkinsFor(widget.child.id);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Growth chart header + filter
          Row(
            children: [
              const Expanded(
                child: Text(
                  S.growthReport,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _filter,
                    items: _filters.map((f) => DropdownMenuItem(
                      value: f,
                      child: Text(f, style: const TextStyle(fontSize: 13)),
                    )).toList(),
                    onChanged: (v) => setState(() => _filter = v!),
                    style: const TextStyle(fontSize: 13, color: AppColors.primary),
                    icon: const Icon(Icons.arrow_drop_down, size: 20),
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _LegendDot(AppColors.primary, 'Chiều cao (cm)'),
                      const SizedBox(width: 16),
                      _LegendDot(AppColors.secondary, 'Cân nặng (kg)'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 220,
                    child: _GrowthChart(measurements: measurements),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Height prediction entry point (design 4.8)
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => HeightPredictionScreen(child: widget.child),
                ),
              ),
              icon: const Icon(Icons.trending_up_rounded),
              label: const Text('Dự báo chiều cao'),
            ),
          ),

          const SizedBox(height: 24),

          // Expert assessment
          _ExpertAssessment(
            child: widget.child,
            measurements: measurements,
          ),

          const SizedBox(height: 24),

          // Body condition report (30 days)
          Row(
            children: [
              const Expanded(
                child: Text(
                  '${S.bodyReport} — ${S.last30Days}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => AllStatesReportScreen(child: widget.child),
                  ),
                ),
                child: const Text('Xem tất cả'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _BodyConditionReport(checkins: checkins),
        ],
      ),
    );
  }
}

class _GrowthChart extends StatelessWidget {
  final List<BodyMeasurement> measurements;

  const _GrowthChart({required this.measurements});

  @override
  Widget build(BuildContext context) {
    final reversed = measurements.reversed.toList();
    final heightSpots = reversed
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.height))
        .toList();
    final weightSpots = reversed
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.weight))
        .toList();

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 20,
          getDrawingHorizontalLine: (value) => FlLine(
            color: AppColors.pending.withValues(alpha: 0.3),
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final idx = value.toInt();
                if (idx < 0 || idx >= reversed.length) {
                  return const SizedBox();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'T${reversed[idx].month.split('-')[1]}',
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                );
              },
              reservedSize: 28,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) => Text(
                value.toInt().toString(),
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: heightSpots,
            isCurved: true,
            color: AppColors.primary,
            barWidth: 3,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) =>
                  FlDotCirclePainter(
                radius: 4,
                color: AppColors.primary,
                strokeWidth: 2,
                strokeColor: Colors.white,
              ),
            ),
            belowBarData: BarAreaData(
              show: true,
              color: AppColors.primary.withValues(alpha: 0.08),
            ),
          ),
          LineChartBarData(
            spots: weightSpots,
            isCurved: true,
            color: AppColors.secondary,
            barWidth: 3,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) =>
                  FlDotCirclePainter(
                radius: 4,
                color: AppColors.secondary,
                strokeWidth: 2,
                strokeColor: Colors.white,
              ),
            ),
            belowBarData: BarAreaData(
              show: true,
              color: AppColors.secondary.withValues(alpha: 0.08),
            ),
          ),
        ],
        minY: 20,
      ),
    );
  }
}

class _BodyConditionReport extends StatelessWidget {
  final List<DailyCheckin> checkins;

  const _BodyConditionReport({required this.checkins});

  @override
  Widget build(BuildContext context) {
    // Count symptoms across all check-ins
    final Map<String, int> symptomCounts = {};
    for (final c in checkins) {
      for (final s in c.symptoms) {
        symptomCounts[s] = (symptomCounts[s] ?? 0) + 1;
      }
    }

    if (symptomCounts.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Text(
              S.noCheckinYet,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
        ),
      );
    }

    final sorted = symptomCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: sorted.map((entry) {
            final pct = entry.value / checkins.length;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  SizedBox(
                    width: 80,
                    child: Text(
                      entry.key,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: pct,
                        minHeight: 10,
                        backgroundColor: AppColors.background,
                        valueColor:
                            AlwaysStoppedAnimation(AppColors.primary.withValues(alpha: 0.7)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${entry.value} ${S.days}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _ExpertAssessment extends StatelessWidget {
  final ChildProfile child;
  final List<BodyMeasurement> measurements;

  const _ExpertAssessment({required this.child, required this.measurements});

  @override
  Widget build(BuildContext context) {
    final who = MockData.whoFor(child);
    String assessment;
    if (measurements.length >= 2) {
      final latest = measurements.first;
      final prev = measurements[1];
      final heightDelta = latest.height - prev.height;
      final buffer = StringBuffer(
        'Trong kỳ gần nhất, ${child.nickname} tăng ${heightDelta.toStringAsFixed(1)} cm chiều cao. ',
      );
      if (who != null) {
        final diff = latest.height - who['height']!;
        if (diff >= 0) {
          buffer.write('Chiều cao đang ở mức tốt so với chuẩn WHO cùng độ tuổi. ');
        } else if (diff > -5) {
          buffer.write('Chiều cao gần đạt chuẩn WHO, hãy duy trì dinh dưỡng và vận động. ');
        } else {
          buffer.write('Chiều cao thấp hơn chuẩn WHO, nên tham khảo ý kiến chuyên gia dinh dưỡng. ');
        }
      }
      buffer.write('Hãy đảm bảo con ngủ đủ giấc và vận động đều đặn mỗi ngày.');
      assessment = buffer.toString();
    } else {
      assessment = 'Hãy cập nhật số đo của ${child.nickname} thường xuyên để nhận được nhận xét '
          'chi tiết về sự phát triển.';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
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
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.psychology_rounded, size: 20, color: Colors.white),
              ),
              const SizedBox(width: 10),
              const Text(
                'NHẬN XÉT',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            assessment,
            style: const TextStyle(fontSize: 14, height: 1.6, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot(this.color, this.label);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label,
            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }
}
