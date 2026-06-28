import 'package:flutter/material.dart';
import '../core/strings.dart';
import '../core/theme.dart';
import '../mock/mock_data.dart';
import '../models/models.dart';

/// Menstrual-cycle accent colors (kept local so they don't leak into the
/// app-wide blue palette).
const _cycleColor = Color(0xFFE0567B); // rose — actual period days
const _cycleColorDim = Color(0xFFF3B8C8); // light rose — predicted days

class CycleTab extends StatefulWidget {
  final ChildProfile child;

  const CycleTab({super.key, required this.child});

  @override
  State<CycleTab> createState() => _CycleTabState();
}

class _CycleTabState extends State<CycleTab> {
  late DateTime _focusedMonth; // always the 1st of the focused month

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _focusedMonth = DateTime(now.year, now.month);
  }

  DateTime _addMonths(DateTime m, int n) => DateTime(m.year, m.month + n);

  @override
  Widget build(BuildContext context) {
    final periods = MockData.periodsFor(widget.child.id);

    if (periods.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.calendar_month, size: 64, color: AppColors.pending),
              const SizedBox(height: 16),
              Text(
                widget.child.isFemale
                    ? S.cycleNoData
                    : 'Tính năng theo dõi dậy thì cho nam\nsẽ sớm ra mắt!',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final stats = _CycleStats.from(periods);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SummaryStats(stats: stats),
          const SizedBox(height: 16),
          _buildCalendarCard(stats),
          const SizedBox(height: 16),
          _buildAssessment(stats),
          const SizedBox(height: 20),
          _buildHistory(),
        ],
      ),
    );
  }

  // ---- Monthly calendar ----------------------------------------------------

  Widget _buildCalendarCard(_CycleStats stats) {
    final today = DateUtils.dateOnly(DateTime.now());
    final currentMonth = DateTime(today.year, today.month);
    final canPrev = _focusedMonth.isAfter(stats.earliestMonth);
    final canNext = _focusedMonth.isBefore(stats.latestMonth);
    final isCurrent = _focusedMonth == currentMonth;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          // Month navigation header
          Row(
            children: [
              _navButton(
                Icons.chevron_left_rounded,
                canPrev ? () => setState(() => _focusedMonth = _addMonths(_focusedMonth, -1)) : null,
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'Tháng ${_focusedMonth.month}/${_focusedMonth.year}',
                    style: const TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              _navButton(
                Icons.chevron_right_rounded,
                canNext ? () => setState(() => _focusedMonth = _addMonths(_focusedMonth, 1)) : null,
              ),
            ],
          ),
          if (!isCurrent)
            TextButton.icon(
              onPressed: () => setState(() => _focusedMonth = currentMonth),
              icon: const Icon(Icons.today_rounded, size: 16),
              label: const Text('Về hôm nay'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                visualDensity: VisualDensity.compact,
              ),
            ),
          const SizedBox(height: 4),
          // Weekday header
          Row(
            children: ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN']
                .map((d) => Expanded(
                      child: Center(
                        child: Text(
                          d,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: d == 'CN'
                                ? _cycleColor
                                : AppColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 6),
          ..._buildWeeks(stats, today),
          const SizedBox(height: 14),
          _legend(),
        ],
      ),
    );
  }

  List<Widget> _buildWeeks(_CycleStats stats, DateTime today) {
    final daysInMonth =
        DateUtils.getDaysInMonth(_focusedMonth.year, _focusedMonth.month);
    final firstWeekday =
        DateTime(_focusedMonth.year, _focusedMonth.month, 1).weekday; // 1..7
    final leading = firstWeekday - 1;
    final totalCells = leading + daysInMonth;
    final rowCount = (totalCells / 7).ceil();

    final weeks = <Widget>[];
    var dayNum = 1 - leading;
    for (var r = 0; r < rowCount; r++) {
      final cells = <Widget>[];
      for (var c = 0; c < 7; c++) {
        if (dayNum < 1 || dayNum > daysInMonth) {
          cells.add(const Expanded(child: SizedBox(height: 44)));
        } else {
          final date =
              DateTime(_focusedMonth.year, _focusedMonth.month, dayNum);
          cells.add(Expanded(child: _dayCell(date, stats, today)));
        }
        dayNum++;
      }
      weeks.add(Row(children: cells));
    }
    return weeks;
  }

  Widget _dayCell(DateTime date, _CycleStats stats, DateTime today) {
    final isPeriod = stats.periodDays.contains(date);
    final isPredicted = !isPeriod && stats.predictedDays.contains(date);
    final isToday = date == today;

    Color? fill;
    Color textColor = AppColors.onSurface;
    BoxBorder? border;

    if (isPeriod) {
      fill = _cycleColor;
      textColor = Colors.white;
    } else if (isPredicted) {
      border = Border.all(color: _cycleColorDim, width: 1.5);
      textColor = _cycleColor;
    }

    Widget inner = Container(
      width: 38,
      height: 38,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: fill,
        shape: BoxShape.circle,
        border: border,
      ),
      child: Text(
        '${date.day}',
        style: TextStyle(
          fontSize: 13.5,
          fontWeight: isPeriod || isPredicted ? FontWeight.w700 : FontWeight.w500,
          color: textColor,
        ),
      ),
    );

    if (isToday) {
      inner = Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primary, width: 2),
        ),
        child: inner,
      );
    }

    return SizedBox(height: 44, child: Center(child: inner));
  }

  Widget _navButton(IconData icon, VoidCallback? onTap) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon),
      color: AppColors.primary,
      disabledColor: AppColors.outlineVariant,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _legend() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 18,
      runSpacing: 8,
      children: [
        _legendItem(
          dot: Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(color: _cycleColor, shape: BoxShape.circle),
          ),
          label: 'Hành kinh',
        ),
        _legendItem(
          dot: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: _cycleColorDim, width: 1.5),
            ),
          ),
          label: 'Dự kiến',
        ),
        _legendItem(
          dot: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 2),
            ),
          ),
          label: 'Hôm nay',
        ),
      ],
    );
  }

  Widget _legendItem({required Widget dot, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        dot,
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
        ),
      ],
    );
  }

  // ---- Assessment ----------------------------------------------------------

  Widget _buildAssessment(_CycleStats stats) {
    final String assessment;
    final Color color;
    if (stats.cycleGaps.isEmpty) {
      assessment = S.cycleNoDataAssess;
      color = AppColors.textSecondary;
    } else if (stats.isIrregular) {
      assessment = S.cycleUnstable;
      color = AppColors.overdue;
    } else {
      assessment = S.cycleNormal;
      color = AppColors.checkedIn;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
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
                child: const Icon(Icons.favorite_rounded, size: 18, color: Colors.white),
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
          const SizedBox(height: 12),
          Text(
            '"$assessment"',
            style: const TextStyle(
              fontSize: 14.5,
              height: 1.55,
              color: Colors.white,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            color == AppColors.overdue
                ? 'Chu kỳ dao động ${stats.minGap}–${stats.maxGap} ngày. Điều này thường gặp ở tuổi dậy thì.'
                : 'Chu kỳ trung bình ${stats.avgCycle} ngày, khá đều đặn.',
            style: TextStyle(
              fontSize: 12.5,
              height: 1.5,
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }

  // ---- 12-month history (collapsible) -------------------------------------

  Widget _buildHistory() {
    final cycleData = MockData.cycleDataFor(widget.child.id);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
      ),
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          leading: const Icon(Icons.history_rounded, color: AppColors.primary),
          title: const Text(
            'Lịch sử 12 tháng',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          children: [
            Table(
              border: TableBorder.all(
                color: AppColors.pending.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              children: [
                const TableRow(
                  decoration: BoxDecoration(color: AppColors.background),
                  children: [
                    _TableHeader('Tháng'),
                    _TableHeader('Tần suất'),
                    _TableHeader('Tình trạng'),
                  ],
                ),
                ...cycleData.map((c) {
                  final statusText = c.status == 'yes'
                      ? 'Đều đặn'
                      : (c.status == 'no' ? 'Không ghi nhận' : S.cycleNoData);
                  final statusColor = c.status == 'yes'
                      ? _cycleColor
                      : (c.status == 'no'
                          ? AppColors.textPrimary
                          : AppColors.textSecondary);
                  final parts = c.month.split('-');
                  final label = '${int.parse(parts[1])}/${parts[0]}';
                  return TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(label, style: const TextStyle(fontSize: 13)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Icon(
                          c.status == 'yes'
                              ? Icons.check_circle
                              : (c.status == 'no'
                                  ? Icons.cancel_outlined
                                  : Icons.help_outline),
                          size: 18,
                          color: c.status == 'yes'
                              ? AppColors.checkedIn
                              : (c.status == 'no'
                                  ? AppColors.outline
                                  : AppColors.primary),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          statusText,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Derived cycle statistics from a list of period ranges (most recent first).
class _CycleStats {
  final Set<DateTime> periodDays;
  final Set<DateTime> predictedDays;
  final List<int> cycleGaps; // days between consecutive starts
  final int avgCycle;
  final int avgPeriod;
  final DateTime nextStart;
  final DateTime earliestMonth;
  final DateTime latestMonth;

  _CycleStats({
    required this.periodDays,
    required this.predictedDays,
    required this.cycleGaps,
    required this.avgCycle,
    required this.avgPeriod,
    required this.nextStart,
    required this.earliestMonth,
    required this.latestMonth,
  });

  int get minGap => cycleGaps.isEmpty ? 0 : cycleGaps.reduce((a, b) => a < b ? a : b);
  int get maxGap => cycleGaps.isEmpty ? 0 : cycleGaps.reduce((a, b) => a > b ? a : b);
  bool get isIrregular => cycleGaps.isNotEmpty && (maxGap - minGap) > 7;

  int get daysUntilNext =>
      nextStart.difference(DateUtils.dateOnly(DateTime.now())).inDays;

  String get nextLabel {
    final d = daysUntilNext;
    if (d < 0) return 'Trễ ${-d}n';
    if (d == 0) return 'Hôm nay';
    return '$d ngày';
  }

  String get nextDate => '${nextStart.day}/${nextStart.month}';

  static _CycleStats from(List<DateTimeRange> periods) {
    final periodDays = <DateTime>{};
    for (final r in periods) {
      for (var d = r.start;
          !d.isAfter(r.end);
          d = d.add(const Duration(days: 1))) {
        periodDays.add(DateUtils.dateOnly(d));
      }
    }

    // Starts are most-recent-first; gaps between consecutive starts.
    final starts = periods.map((r) => r.start).toList();
    final gaps = <int>[];
    for (var i = 0; i < starts.length - 1; i++) {
      gaps.add(starts[i].difference(starts[i + 1]).inDays);
    }
    final avgCycle = gaps.isEmpty
        ? 28
        : (gaps.reduce((a, b) => a + b) / gaps.length).round();
    final avgPeriod = periods.isEmpty
        ? 5
        : (periods
                    .map((r) => r.duration.inDays + 1)
                    .reduce((a, b) => a + b) /
                periods.length)
            .round();

    // Predict the next 3 cycles forward so navigation reveals upcoming periods.
    final predictedDays = <DateTime>{};
    var nextStart = starts.isEmpty
        ? DateUtils.dateOnly(DateTime.now())
        : starts.first.add(Duration(days: avgCycle));
    final firstNext = nextStart;
    DateTime lastPredictedEnd = nextStart;
    for (var c = 0; c < 3; c++) {
      for (var i = 0; i < avgPeriod; i++) {
        final day = nextStart.add(Duration(days: i));
        predictedDays.add(DateUtils.dateOnly(day));
        lastPredictedEnd = day;
      }
      nextStart = nextStart.add(Duration(days: avgCycle));
    }

    final earliest = periods.last.start;
    return _CycleStats(
      periodDays: periodDays,
      predictedDays: predictedDays,
      cycleGaps: gaps,
      avgCycle: avgCycle,
      avgPeriod: avgPeriod,
      nextStart: firstNext,
      earliestMonth: DateTime(earliest.year, earliest.month),
      latestMonth: DateTime(lastPredictedEnd.year, lastPredictedEnd.month),
    );
  }
}

/// Three-stat summary row at the top of the cycle tab.
class _SummaryStats extends StatelessWidget {
  final _CycleStats stats;
  const _SummaryStats({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: _stat(
              icon: Icons.event_rounded,
              iconColor: _cycleColor,
              value: stats.nextLabel,
              label: 'Kỳ tới · ${stats.nextDate}',
            ),
          ),
          _divider(),
          Expanded(
            child: _stat(
              icon: Icons.autorenew_rounded,
              iconColor: AppColors.primary,
              value: '${stats.avgCycle} ngày',
              label: 'Chu kỳ TB',
            ),
          ),
          _divider(),
          Expanded(
            child: _stat(
              icon: Icons.water_drop_rounded,
              iconColor: _cycleColor,
              value: '${stats.avgPeriod} ngày',
              label: 'Mỗi kỳ',
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() => Container(
        width: 1,
        height: 44,
        color: AppColors.surfaceVariant,
      );

  Widget _stat({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, color: iconColor, size: 22),
        const SizedBox(height: 8),
        Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 10.5, color: AppColors.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _TableHeader extends StatelessWidget {
  final String text;
  const _TableHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
