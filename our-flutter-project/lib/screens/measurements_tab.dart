import 'package:flutter/material.dart';
import '../core/strings.dart';
import '../core/theme.dart';
import '../mock/mock_data.dart';
import '../models/models.dart';

class MeasurementsTab extends StatelessWidget {
  final ChildProfile child;

  const MeasurementsTab({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final measurements = MockData.measurementsFor(child.id);
    final who = MockData.whoFor(child);
    final latest = measurements.isNotEmpty ? measurements.first : null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current stats card
          if (latest != null) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Số đo gần nhất',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tháng ${latest.month}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _MeasureChip(
                          label: S.height,
                          value: '${latest.height.toStringAsFixed(1)} cm',
                          icon: Icons.height,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 12),
                        _MeasureChip(
                          label: S.weight,
                          value: '${latest.weight.toStringAsFixed(1)} kg',
                          icon: Icons.monitor_weight_outlined,
                          color: AppColors.secondary,
                        ),
                        const SizedBox(width: 12),
                        _MeasureChip(
                          label: S.bmi,
                          value: latest.bmi.toStringAsFixed(1),
                          icon: Icons.speed,
                          color: AppColors.accent,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // WHO comparison
          if (who != null && latest != null) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      S.whoComparison,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '${child.age} ${S.age} · ${child.isFemale ? "Nữ" : "Nam"}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _WhoRow(
                      label: 'Chiều cao',
                      childVal: latest.height,
                      whoVal: who['height']!,
                      unit: 'cm',
                    ),
                    const SizedBox(height: 10),
                    _WhoRow(
                      label: 'Cân nặng',
                      childVal: latest.weight,
                      whoVal: who['weight']!,
                      unit: 'kg',
                    ),
                    const SizedBox(height: 10),
                    _WhoRow(
                      label: 'BMI',
                      childVal: latest.bmi,
                      whoVal: who['bmi']!,
                      unit: '',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // History list
          const Text(
            'Lịch sử đo',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ...measurements.map((m) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    child: const Icon(Icons.straighten,
                        color: AppColors.primary, size: 20),
                  ),
                  title: Text(
                    'Tháng ${m.month}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    '${m.height.toStringAsFixed(1)}cm · ${m.weight.toStringAsFixed(1)}kg · BMI ${m.bmi.toStringAsFixed(1)}',
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

class _MeasureChip extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _MeasureChip({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _WhoRow extends StatelessWidget {
  final String label;
  final double childVal;
  final double whoVal;
  final String unit;

  const _WhoRow({
    required this.label,
    required this.childVal,
    required this.whoVal,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final diff = childVal - whoVal;
    final status = diff.abs() < whoVal * 0.05
        ? S.withinRange
        : (diff > 0 ? S.aboveRange : S.belowRange);
    final color = status == S.withinRange
        ? AppColors.checkedIn
        : (status == S.aboveRange ? AppColors.overdue : AppColors.error);

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(label,
              style: const TextStyle(fontSize: 14, color: AppColors.textPrimary)),
        ),
        Expanded(
          flex: 2,
          child: Text(
            '${childVal.toStringAsFixed(1)}$unit / ${whoVal.toStringAsFixed(1)}$unit',
            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            status,
            style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
