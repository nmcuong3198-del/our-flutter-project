import 'package:flutter/material.dart';
import '../core/strings.dart';
import '../core/theme.dart';
import '../mock/mock_data.dart';
import '../models/models.dart';

class MoodCalendarTab extends StatefulWidget {
  final ChildProfile child;
  const MoodCalendarTab({super.key, required this.child});

  @override
  State<MoodCalendarTab> createState() => _MoodCalendarTabState();
}

class _MoodCalendarTabState extends State<MoodCalendarTab> {
  late DateTime _currentMonth;
  late List<DailyCheckin> _checkins;
  late Map<String, DailyCheckin> _checkinMap;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
    _loadData();
  }

  void _loadData() {
    _checkins = MockData.checkinsFor(widget.child.id);
    _checkinMap = {};
    for (final c in _checkins) {
      final key = '${c.date.year}-${c.date.month}-${c.date.day}';
      _checkinMap[key] = c;
    }
  }

  void _prevMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    final now = DateTime.now();
    final next = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    if (!next.isAfter(DateTime(now.year, now.month + 1, 1))) {
      setState(() => _currentMonth = next);
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final daysInMonth = DateUtils.getDaysInMonth(
        _currentMonth.year, _currentMonth.month);
    final firstWeekday = _currentMonth.weekday % 7; // 0=Sun
    final monthName = _monthName(_currentMonth.month);

    // Count emotions for the month
    final emotionCounts = <String, int>{};
    int checkedDays = 0;
    for (int day = 1; day <= daysInMonth; day++) {
      final key =
          '${_currentMonth.year}-${_currentMonth.month}-$day';
      final checkin = _checkinMap[key];
      if (checkin != null && checkin.emotions.isNotEmpty) {
        checkedDays++;
        for (final e in checkin.emotions) {
          emotionCounts[e] = (emotionCounts[e] ?? 0) + 1;
        }
      }
    }
    final sortedEmotions = emotionCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Month navigator
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: _prevMonth,
                  ),
                  Text(
                    '$monthName ${_currentMonth.year}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: _nextMonth,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Calendar grid
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  // Weekday headers
                  Row(
                    children: ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7']
                        .map((d) => Expanded(
                              child: Center(
                                child: Text(
                                  d,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 8),
                  // Day cells
                  ..._buildWeeks(daysInMonth, firstWeekday, now),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Summary stats
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tổng hợp tháng $monthName',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$checkedDays/$daysInMonth ngày đã cập nhật',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (sortedEmotions.isEmpty)
                    const Text(
                      S.noCheckinYet,
                      style: TextStyle(color: AppColors.textSecondary),
                    )
                  else
                    ...sortedEmotions.map((entry) {
                      final pct = checkedDays > 0
                          ? entry.value / checkedDays
                          : 0.0;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            Text(
                              _emojiFor(entry.key),
                              style: const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 70,
                              child: Text(
                                entry.key,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: pct,
                                  minHeight: 10,
                                  backgroundColor: AppColors.background,
                                  valueColor: AlwaysStoppedAnimation(
                                      _colorFor(entry.key)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${entry.value}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Legend
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Chú thích',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    runSpacing: 6,
                    children: [
                      _LegendItem('😄', 'Vui', const Color(0xFF4CAF50)),
                      _LegendItem('🙂', 'Bình thường', const Color(0xFF8BC34A)),
                      _LegendItem('😕', 'Chán, mệt', const Color(0xFFFFC107)),
                      _LegendItem('😢', 'Buồn', const Color(0xFFFF9800)),
                      _LegendItem('😡', 'Cáu', const Color(0xFFF44336)),
                      _LegendItem('😰', 'Lo lắng', const Color(0xFF9C27B0)),
                      _LegendItem('😴', 'Uể oải', const Color(0xFF607D8B)),
                      _LegendItem('·', 'Chưa cập nhật', AppColors.pending),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  List<Widget> _buildWeeks(int daysInMonth, int firstWeekday, DateTime now) {
    final weeks = <Widget>[];
    int dayCounter = 1;

    for (int week = 0; week < 6; week++) {
      if (dayCounter > daysInMonth) break;
      final cells = <Widget>[];

      for (int dow = 0; dow < 7; dow++) {
        if ((week == 0 && dow < firstWeekday) || dayCounter > daysInMonth) {
          cells.add(const Expanded(child: SizedBox(height: 48)));
        } else {
          final day = dayCounter;
          final date = DateTime(_currentMonth.year, _currentMonth.month, day);
          final key = '${date.year}-${date.month}-${date.day}';
          final checkin = _checkinMap[key];
          final hasEmotions =
              checkin != null && checkin.emotions.isNotEmpty;
          final isToday = date.year == now.year &&
              date.month == now.month &&
              date.day == now.day;
          final isFuture = date.isAfter(now);
          final emoji = hasEmotions ? _emojiFor(checkin!.emotions.first) : null;
          final bgColor =
              hasEmotions ? _colorFor(checkin!.emotions.first).withValues(alpha: 0.15) : null;

          cells.add(
            Expanded(
              child: GestureDetector(
                onTap: hasEmotions
                    ? () => _showDayDetail(context, date, checkin!)
                    : null,
                child: Container(
                  height: 48,
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: isFuture
                        ? null
                        : (bgColor ?? AppColors.background),
                    borderRadius: BorderRadius.circular(10),
                    border: isToday
                        ? Border.all(color: AppColors.primary, width: 2)
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (emoji != null)
                        Text(emoji, style: const TextStyle(fontSize: 18))
                      else if (!isFuture)
                        Text(
                          '·',
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.pending,
                          ),
                        ),
                      Text(
                        '$day',
                        style: TextStyle(
                          fontSize: 9,
                          color: isFuture
                              ? AppColors.pending
                              : AppColors.textSecondary,
                          fontWeight:
                              isToday ? FontWeight.w700 : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
          dayCounter++;
        }
      }
      weeks.add(Row(children: cells));
    }
    return weeks;
  }

  void _showDayDetail(
      BuildContext context, DateTime date, DailyCheckin checkin) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${date.day}/${date.month}/${date.year}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            if (checkin.emotions.isNotEmpty) ...[
              const Text('Cảm xúc:',
                  style: TextStyle(
                      fontSize: 13, color: AppColors.textSecondary)),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                children: checkin.emotions
                    .map((e) => Chip(
                          avatar: Text(_emojiFor(e),
                              style: const TextStyle(fontSize: 16)),
                          label: Text(e, style: const TextStyle(fontSize: 12)),
                          backgroundColor:
                              _colorFor(e).withValues(alpha: 0.12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                                color: _colorFor(e).withValues(alpha: 0.3)),
                          ),
                        ))
                    .toList(),
              ),
            ],
            if (checkin.bodyStatus != null) ...[
              const SizedBox(height: 12),
              Text('Cơ thể: ${checkin.bodyStatus}',
                  style: const TextStyle(fontSize: 13)),
            ],
            if (checkin.symptoms.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text('Triệu chứng: ${checkin.symptoms.join(", ")}',
                  style: const TextStyle(fontSize: 13)),
            ],
            if (checkin.notes != null) ...[
              const SizedBox(height: 12),
              Text('Ghi chú: ${checkin.notes}',
                  style: const TextStyle(fontSize: 13)),
            ],
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  String _emojiFor(String emotion) {
    switch (emotion) {
      case 'Vui':
        return '😄';
      case 'Bình thường':
        return '🙂';
      case 'Chán, mệt':
        return '😕';
      case 'Buồn':
        return '😢';
      case 'Cáu':
        return '😡';
      case 'Lo lắng':
        return '😰';
      case 'Uể oải':
        return '😴';
      default:
        return '❓';
    }
  }

  Color _colorFor(String emotion) {
    switch (emotion) {
      case 'Vui':
        return const Color(0xFF4CAF50);
      case 'Bình thường':
        return const Color(0xFF8BC34A);
      case 'Chán, mệt':
        return const Color(0xFFFFC107);
      case 'Buồn':
        return const Color(0xFFFF9800);
      case 'Cáu':
        return const Color(0xFFF44336);
      case 'Lo lắng':
        return const Color(0xFF9C27B0);
      case 'Uể oải':
        return const Color(0xFF607D8B);
      default:
        return AppColors.textSecondary;
    }
  }

  String _monthName(int month) {
    const names = [
      '', 'Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4',
      'Tháng 5', 'Tháng 6', 'Tháng 7', 'Tháng 8',
      'Tháng 9', 'Tháng 10', 'Tháng 11', 'Tháng 12',
    ];
    return names[month];
  }
}

class _LegendItem extends StatelessWidget {
  final String emoji;
  final String label;
  final Color color;
  const _LegendItem(this.emoji, this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
            child: Text(emoji, style: const TextStyle(fontSize: 12)),
          ),
        ),
        const SizedBox(width: 4),
        Text(label,
            style: const TextStyle(
                fontSize: 10, color: AppColors.textSecondary)),
      ],
    );
  }
}
