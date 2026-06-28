import 'package:flutter/material.dart';
import '../core/strings.dart';
import '../core/theme.dart';
import '../models/models.dart';
import 'checkin_tab.dart';
import 'mood_calendar_tab.dart';
import 'measurements_tab.dart';
import 'cycle_tab.dart';
import 'reports_tab.dart';
import 'practice_tab.dart';
import 'reminders_tab.dart';

class ChildDetailScreen extends StatelessWidget {
  final ChildProfile child;
  final int initialTab;

  const ChildDetailScreen({super.key, required this.child, this.initialTab = 0});

  @override
  Widget build(BuildContext context) {
    // The cycle tab is only relevant for girls (menstrual tracking).
    final showCycle = child.isFemale;

    // Canonical tab order (used by callers via `initialTab`):
    // 0 check-in · 1 emotions · 2 measurements · 3 cycle · 4 reports ·
    // 5 practice · 6 notes. The cycle entry is omitted for boys.
    final tabs = <({IconData icon, String label, Widget view})>[
      (icon: Icons.edit_note, label: S.tabCheckin, view: CheckinTab(child: child)),
      (icon: Icons.emoji_emotions, label: 'Cảm xúc', view: MoodCalendarTab(child: child)),
      (icon: Icons.straighten, label: S.tabMeasure, view: MeasurementsTab(child: child)),
      if (showCycle)
        (icon: Icons.calendar_month, label: S.tabCycle, view: CycleTab(child: child)),
      (icon: Icons.bar_chart, label: S.tabReport, view: ReportsTab(child: child)),
      (icon: Icons.task_alt, label: 'Hành động', view: PracticeTab(child: child)),
      (icon: Icons.event_note, label: 'Ghi chú', view: RemindersTab(child: child)),
    ];

    return DefaultTabController(
      length: tabs.length,
      initialIndex: _resolveInitialIndex(showCycle),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(child.nickname),
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            tabs: [
              for (final t in tabs) Tab(icon: Icon(t.icon), text: t.label),
            ],
          ),
        ),
        body: TabBarView(
          children: [for (final t in tabs) t.view],
        ),
      ),
    );
  }

  /// Maps a canonical [initialTab] index to the actual index once the cycle
  /// tab has been removed for boys (tabs after cycle shift down by one).
  int _resolveInitialIndex(bool showCycle) {
    if (showCycle) return initialTab.clamp(0, 6);
    if (initialTab == 3) return 0; // cycle requested but unavailable
    if (initialTab > 3) return initialTab - 1;
    return initialTab;
  }
}
