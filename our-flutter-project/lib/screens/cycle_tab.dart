import 'package:flutter/material.dart';
import '../core/strings.dart';
import '../core/theme.dart';
import '../mock/mock_data.dart';
import '../models/models.dart';

class CycleTab extends StatelessWidget {
  final ChildProfile child;

  const CycleTab({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final cycleData = MockData.cycleDataFor(child.id);

    if (cycleData.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_month, size: 64, color: AppColors.pending),
            const SizedBox(height: 16),
            Text(
              child.isFemale
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
      );
    }

    // Calculate last period
    final lastYes = cycleData.indexWhere((c) => c.status == 'yes');
    final lastPeriodText = lastYes >= 0 ? '$lastYes tháng trước' : S.cycleNoData;

    // Assessment
    final last3 = cycleData.take(3).toList();
    String assessment;
    Color assessColor;
    if (last3.any((c) => c.status == 'nodata')) {
      assessment = S.cycleNoDataAssess;
      assessColor = AppColors.textSecondary;
    } else if (last3.any((c) => c.status == 'no')) {
      assessment = S.cycleUnstable;
      assessColor = AppColors.overdue;
    } else {
      assessment = child.isFemale ? S.cycleNormal : S.pubertyNormal;
      assessColor = AppColors.checkedIn;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Last period card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.calendar_today,
                        color: AppColors.secondary),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          S.lastPeriod,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          lastPeriodText,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Assessment card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: assessColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      assessColor == AppColors.checkedIn
                          ? Icons.check_circle
                          : Icons.info_outline,
                      color: assessColor,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          S.cycleAssessment,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          assessment,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: assessColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // 12-month table
          const Text(
            'Lịch sử 12 tháng',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Table(
                border: TableBorder.all(
                  color: AppColors.pending.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                children: [
                  const TableRow(
                    decoration: BoxDecoration(color: AppColors.background),
                    children: [
                      _TableHeader('Tháng'),
                      _TableHeader('Tình trạng'),
                    ],
                  ),
                  ...cycleData.map((c) {
                    final statusText = c.status == 'yes'
                        ? S.cycleYes
                        : (c.status == 'no' ? S.cycleNo : S.cycleNoData);
                    final statusColor = c.status == 'yes'
                        ? AppColors.secondary
                        : (c.status == 'no'
                            ? AppColors.textPrimary
                            : AppColors.textSecondary);
                    return TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            c.month,
                            style: const TextStyle(fontSize: 13),
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
            ),
          ),
        ],
      ),
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
