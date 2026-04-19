import 'package:flutter/material.dart';
import '../core/strings.dart';
import '../core/theme.dart';
import '../models/models.dart';
import 'checkin_tab.dart';
import 'measurements_tab.dart';
import 'cycle_tab.dart';
import 'reports_tab.dart';

class ChildDetailScreen extends StatelessWidget {
  final ChildProfile child;

  const ChildDetailScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(child.nickname),
          bottom: TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            tabs: const [
              Tab(icon: Icon(Icons.edit_note), text: S.tabCheckin),
              Tab(icon: Icon(Icons.straighten), text: S.tabMeasure),
              Tab(icon: Icon(Icons.calendar_month), text: S.tabCycle),
              Tab(icon: Icon(Icons.bar_chart), text: S.tabReport),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            CheckinTab(child: child),
            MeasurementsTab(child: child),
            CycleTab(child: child),
            ReportsTab(child: child),
          ],
        ),
      ),
    );
  }
}
