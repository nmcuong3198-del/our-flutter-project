import 'package:flutter/material.dart';
import '../core/strings.dart';
import '../core/theme.dart';
import '../mock/mock_data.dart';
import '../models/models.dart';

class PracticeTab extends StatefulWidget {
  final ChildProfile child;
  const PracticeTab({super.key, required this.child});

  @override
  State<PracticeTab> createState() => _PracticeTabState();
}

class _PracticeTabState extends State<PracticeTab> {
  late List<PracticeItem> _items;

  @override
  void initState() {
    super.initState();
    _items = MockData.practiceFor(widget.child.id);
  }

  List<PracticeItem> _byCategory(String cat) =>
      _items.where((i) => i.category == cat).toList();

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final monthLabel = 'Tháng ${now.month}/${now.year}';
    final completed = _items.where((i) => i.isCompleted).length;

    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          // Month header + progress
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                const Icon(Icons.calendar_today,
                    size: 18, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  monthLabel,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$completed/${_items.length} đã thực hiện',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.accent,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Category tabs
          const TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            tabs: [
              Tab(text: 'Quan sát'),
              Tab(text: 'Giao tiếp'),
              Tab(text: 'Hỗ trợ'),
            ],
          ),

          // Items
          Expanded(
            child: TabBarView(
              children: [
                _CategoryList(
                  items: _byCategory('quan_sat'),
                  onToggle: _onToggle,
                ),
                _CategoryList(
                  items: _byCategory('giao_tiep'),
                  onToggle: _onToggle,
                ),
                _CategoryList(
                  items: _byCategory('ho_tro'),
                  onToggle: _onToggle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onToggle(PracticeItem item) {
    setState(() => item.isCompleted = !item.isCompleted);
  }
}

class _CategoryList extends StatelessWidget {
  final List<PracticeItem> items;
  final void Function(PracticeItem) onToggle;

  const _CategoryList({required this.items, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(
        child: Text('Chưa có hành động', style: TextStyle(color: AppColors.textSecondary)),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title + checkbox
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => onToggle(item),
                      child: Container(
                        width: 24,
                        height: 24,
                        margin: const EdgeInsets.only(top: 2),
                        decoration: BoxDecoration(
                          color: item.isCompleted
                              ? AppColors.accent
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: item.isCompleted
                                ? AppColors.accent
                                : AppColors.pending,
                            width: 2,
                          ),
                        ),
                        child: item.isCompleted
                            ? const Icon(Icons.check,
                                size: 16, color: Colors.white)
                            : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: item.isCompleted
                              ? AppColors.textSecondary
                              : AppColors.textPrimary,
                          decoration: item.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Executor + planned week
                Row(
                  children: [
                    _Tag(Icons.person, item.executor, AppColors.primary),
                    const SizedBox(width: 8),
                    _Tag(Icons.date_range, 'Tuần ${item.plannedWeek}',
                        AppColors.secondary),
                    if (item.isCompleted) ...[
                      const SizedBox(width: 8),
                      _Tag(Icons.check_circle, 'Đã thực hiện',
                          AppColors.accent),
                    ],
                  ],
                ),

                // Notes
                if (item.notes != null && item.notes!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item.notes!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Tag extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _Tag(this.icon, this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
