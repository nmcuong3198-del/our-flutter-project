import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../core/strings.dart';
import '../core/theme.dart';
import '../domain/reports/body_status_report_service.dart';
import '../domain/reports/growth_report_service.dart';
import '../domain/reports/report_models.dart';
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
  ReportFrequency _frequency = ReportFrequency.month;
  late DateTime _fromDate;
  late DateTime _toDate;

  final _growthReportService = const GrowthReportService();
  final _bodyStatusReportService = const BodyStatusReportService();

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _toDate = DateTime(now.year, now.month, now.day);
    _fromDate = DateTime(now.year, now.month - 5, now.day);
  }

  @override
  Widget build(BuildContext context) {
    final allMeasurements = MockData.measurementsFor(widget.child.id);
    final checkins = MockData.checkinsFor(widget.child.id);
    final growthReport = _growthReportService.build(
      child: widget.child,
      measurements: allMeasurements,
      frequency: _frequency,
      fromDate: _fromDate,
      toDate: _toDate,
    );
    final bodyReport = _bodyStatusReportService.build(
      checkins: checkins,
      fromDate: _fromDate,
      toDate: _toDate,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Growth chart header + filters
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
              _FrequencyMenu(
                value: _frequency,
                onChanged: (value) => setState(() {
                  _frequency = value;
                  _toDate = _growthReportService.clampToRangeLimit(
                    frequency: _frequency,
                    fromDate: _fromDate,
                    toDate: _toDate,
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _DateRangePicker(
            fromDate: _fromDate,
            toDate: _toDate,
            onPickFrom: () => _pickDate(isFrom: true),
            onPickTo: () => _pickDate(isFrom: false),
          ),
          const SizedBox(height: 12),
          _GrowthSummaryTable(summaries: growthReport.summaries),
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
                      const SizedBox(width: 16),
                      _LegendDot(AppColors.tertiary, 'BMI'),
                      const SizedBox(width: 16),
                      _LegendDot(AppColors.outline, 'WHO'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 220,
                    child: _GrowthChart(points: growthReport.points),
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
            summaries: growthReport.summaries,
          ),

          const SizedBox(height: 24),

          // Body condition report (30 days)
          Row(
            children: [
              Expanded(
                child: Text(
                  '${S.bodyReport} — ${bodyReport.totalDays} ngày',
                  style: const TextStyle(
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
          _BodyConditionReport(report: bodyReport),
        ],
      ),
    );
  }

  Future<void> _pickDate({required bool isFrom}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isFrom ? _fromDate : _toDate,
      firstDate: DateTime.now().subtract(const Duration(days: 3650)),
      lastDate: DateTime.now(),
    );
    if (picked == null) return;

    setState(() {
      if (isFrom) {
        _fromDate = picked;
        if (_toDate.isBefore(_fromDate)) _toDate = _fromDate;
      } else {
        _toDate = picked.isBefore(_fromDate) ? _fromDate : picked;
      }
      _toDate = _growthReportService.clampToRangeLimit(
        frequency: _frequency,
        fromDate: _fromDate,
        toDate: _toDate,
      );
    });
  }
}

class _GrowthChart extends StatelessWidget {
  final List<GrowthReportPoint> points;

  const _GrowthChart({required this.points});

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) return const Center(child: Text(S.noCheckinYet));

    final heightSpots = points
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.measurement.height))
        .toList();
    final weightSpots = points
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.measurement.weight))
        .toList();
    final bmiSpots = points
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.measurement.bmi))
        .toList();
    final whoHeightSpots = points
        .asMap()
        .entries
        .where((e) => e.value.who != null)
        .map((e) => FlSpot(e.key.toDouble(), e.value.who!.height))
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
                if (idx < 0 || idx >= points.length) {
                  return const SizedBox();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    points[idx].label,
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
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
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
          LineChartBarData(
            spots: bmiSpots,
            isCurved: true,
            color: AppColors.tertiary,
            barWidth: 2,
            dotData: const FlDotData(show: false),
          ),
          if (whoHeightSpots.isNotEmpty)
            LineChartBarData(
              spots: whoHeightSpots,
              isCurved: false,
              color: AppColors.outline,
              barWidth: 2,
              dashArray: [6, 4],
              dotData: const FlDotData(show: false),
            ),
        ],
        minY: 20,
      ),
    );
  }
}

class _BodyConditionReport extends StatelessWidget {
  final BodyStatusReport report;

  const _BodyConditionReport({required this.report});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (report.latestCheckinDate != null)
              Text(
                'Ngày gần nhất cập nhật: ${report.latestCheckinDate!.day}/${report.latestCheckinDate!.month}/${report.latestCheckinDate!.year}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            const SizedBox(height: 12),
            _statusGroup('Bình thường', report.normal, AppColors.checkedIn),
            const SizedBox(height: 14),
            _statusGroup('Cần theo dõi', report.watchTop, AppColors.overdue),
            if (report.missing.isNotEmpty) ...[
              const SizedBox(height: 14),
              _statusGroup('Thiếu dữ liệu', report.missing, AppColors.pending),
            ],
          ],
        ),
      ),
    );
  }

  Widget _statusGroup(
    String title,
    List<BodyStatusEntry> entries,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        const SizedBox(height: 8),
        if (entries.isEmpty)
          const Text(
            'Không có trạng thái',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          )
        else
          ...entries.map((entry) => _statusRow(entry, color)),
      ],
    );
  }

  Widget _statusRow(BodyStatusEntry entry, Color color) {
    final pct = report.totalDays <= 0 ? 0.0 : entry.days / report.totalDays;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 112,
            child: Text(
              entry.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: pct.clamp(0, 1),
                minHeight: 10,
                backgroundColor: AppColors.background,
                valueColor: AlwaysStoppedAnimation(
                  color.withValues(alpha: 0.75),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${entry.days}/${report.totalDays}',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpertAssessment extends StatelessWidget {
  final ChildProfile child;
  final List<GrowthMetricSummary> summaries;

  const _ExpertAssessment({required this.child, required this.summaries});

  @override
  Widget build(BuildContext context) {
    final assessment = summaries.isEmpty
        ? 'Hãy cập nhật số đo của ${child.nickname} thường xuyên để nhận được nhận xét chi tiết về sự phát triển.'
        : summaries
              .map((summary) => '${summary.label}: ${summary.assessment}.')
              .join(' ');

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
                child: const Icon(
                  Icons.psychology_rounded,
                  size: 20,
                  color: Colors.white,
                ),
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
            style: const TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _GrowthSummaryTable extends StatelessWidget {
  final List<GrowthMetricSummary> summaries;

  const _GrowthSummaryTable({required this.summaries});

  @override
  Widget build(BuildContext context) {
    if (summaries.isEmpty) return const SizedBox.shrink();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const Row(
              children: [
                Expanded(flex: 2, child: _HeaderText('Chỉ số')),
                Expanded(child: _HeaderText('Thông số')),
                Expanded(child: _HeaderText('Tăng trưởng')),
                Expanded(flex: 2, child: _HeaderText('Đánh giá')),
              ],
            ),
            const SizedBox(height: 8),
            ...summaries.map((summary) => _GrowthSummaryRow(summary: summary)),
          ],
        ),
      ),
    );
  }
}

class _GrowthSummaryRow extends StatelessWidget {
  final GrowthMetricSummary summary;

  const _GrowthSummaryRow({required this.summary});

  @override
  Widget build(BuildContext context) {
    final color = switch (summary.direction) {
      ReportGrowthDirection.up => AppColors.primary,
      ReportGrowthDirection.flat => AppColors.warning,
      ReportGrowthDirection.down => AppColors.error,
      ReportGrowthDirection.unknown => AppColors.textSecondary,
    };
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              summary.label,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Text(summary.value, style: const TextStyle(fontSize: 12.5)),
          ),
          Expanded(
            child: Text(
              summary.growthLabel,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              summary.assessment,
              style: const TextStyle(fontSize: 12.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderText extends StatelessWidget {
  final String text;

  const _HeaderText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        color: AppColors.primary,
      ),
    );
  }
}

class _FrequencyMenu extends StatelessWidget {
  final ReportFrequency value;
  final ValueChanged<ReportFrequency> onChanged;

  const _FrequencyMenu({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<ReportFrequency>(
          value: value,
          items: ReportFrequency.values
              .map(
                (frequency) => DropdownMenuItem(
                  value: frequency,
                  child: Text(
                    frequency.label,
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              )
              .toList(),
          onChanged: (frequency) {
            if (frequency != null) onChanged(frequency);
          },
          style: const TextStyle(fontSize: 13, color: AppColors.primary),
          icon: const Icon(Icons.arrow_drop_down, size: 20),
          isDense: true,
        ),
      ),
    );
  }
}

class _DateRangePicker extends StatelessWidget {
  final DateTime fromDate;
  final DateTime toDate;
  final VoidCallback onPickFrom;
  final VoidCallback onPickTo;

  const _DateRangePicker({
    required this.fromDate,
    required this.toDate,
    required this.onPickFrom,
    required this.onPickTo,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _dateButton('Từ ngày', fromDate, onPickFrom)),
        const SizedBox(width: 8),
        Expanded(child: _dateButton('Đến ngày', toDate, onPickTo)),
      ],
    );
  }

  Widget _dateButton(String label, DateTime date, VoidCallback onTap) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: const Icon(Icons.calendar_today_outlined, size: 16),
      label: Text('$label ${date.day}/${date.month}/${date.year}'),
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
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
