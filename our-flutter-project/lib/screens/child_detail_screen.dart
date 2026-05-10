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
    return DefaultTabController(
      length: 7,
      initialIndex: initialTab,
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
            tabs: const [
              Tab(icon: Icon(Icons.edit_note), text: S.tabCheckin),
              Tab(icon: Icon(Icons.emoji_emotions), text: 'Cảm xúc'),
              Tab(icon: Icon(Icons.straighten), text: S.tabMeasure),
              Tab(icon: Icon(Icons.calendar_month), text: S.tabCycle),
              Tab(icon: Icon(Icons.bar_chart), text: S.tabReport),
              Tab(icon: Icon(Icons.task_alt), text: 'Hành động'),
              Tab(icon: Icon(Icons.event_note), text: 'Ghi chú'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            CheckinTab(child: child),
            MoodCalendarTab(child: child),
            MeasurementsTab(child: child),
            CycleTab(child: child),
            ReportsTab(child: child),
            PracticeTab(child: child),
            RemindersTab(child: child),
          ],
        ),
      ),
    );
  }
}
