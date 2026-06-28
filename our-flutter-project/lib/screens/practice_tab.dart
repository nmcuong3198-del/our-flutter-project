import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../data/repositories/action_repository.dart';
import '../models/models.dart';

class PracticeTab extends StatefulWidget {
  final ChildProfile child;
  const PracticeTab({super.key, required this.child});

  @override
  State<PracticeTab> createState() => _PracticeTabState();
}

class _PracticeTabState extends State<PracticeTab> {
  List<PracticeItem> _items = [];
  bool _isLoading = true;
  String? _error;
  late DateTime _selectedMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedMonth = DateTime(now.year, now.month);
    _loadItems();
  }

  List<PracticeItem> _byCategory(String cat) =>
      _items.where((i) => i.category == cat).toList();

  @override
  Widget build(BuildContext context) {
    final monthLabel = 'Tháng ${_selectedMonth.month}/${_selectedMonth.year}';
    final completed = _items.where((i) => i.isCompleted).length;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: AppColors.error),
              const SizedBox(height: 8),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: _loadItems,
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      );
    }

    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          // Month header + progress
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                IconButton(
                  onPressed: _goToPreviousMonth,
                  icon: const Icon(Icons.chevron_left),
                  tooltip: 'Tháng trước',
                  color: AppColors.primary,
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 18,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          monthLabel,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
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
                IconButton(
                  onPressed: _isCurrentMonth ? null : _goToNextMonth,
                  icon: const Icon(Icons.chevron_right),
                  tooltip: 'Tháng sau',
                  color: AppColors.primary,
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
                  onEdit: _showEditSheet,
                ),
                _CategoryList(
                  items: _byCategory('giao_tiep'),
                  onToggle: _onToggle,
                  onEdit: _showEditSheet,
                ),
                _CategoryList(
                  items: _byCategory('ho_tro'),
                  onToggle: _onToggle,
                  onEdit: _showEditSheet,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onToggle(PracticeItem item) {
    final nextValue = !item.isCompleted;
    setState(() => item.isCompleted = nextValue);
    ActionRepository.instance.setCompleted(item.id, nextValue).catchError((_) {
      if (!mounted) return;
      setState(() => item.isCompleted = !nextValue);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Chưa lưu được trạng thái hành động'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    });
  }

  Future<void> _loadItems() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final items = await ActionRepository.instance.getOrCreateMonthlyActions(
        child: widget.child,
        monthDate: _selectedMonth,
      );
      if (!mounted) return;
      setState(() {
        _items = items;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _error = 'Chưa tải được danh sách hành động. Vui lòng thử lại.';
      });
    }
  }

  bool get _isCurrentMonth {
    final now = DateTime.now();
    return _selectedMonth.year == now.year && _selectedMonth.month == now.month;
  }

  void _goToPreviousMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
    });
    _loadItems();
  }

  void _goToNextMonth() {
    if (_isCurrentMonth) return;
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
    });
    _loadItems();
  }

  Future<void> _showEditSheet(PracticeItem item) async {
    const executors = ['Ông', 'Bà', 'Bố', 'Mẹ'];
    var executor = executors.contains(item.executor) ? item.executor : 'Mẹ';
    var plannedWeek = item.plannedWeek.clamp(1, 4);
    final noteController = TextEditingController(text: item.notes ?? '');

    final updated = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Cập nhật hành động',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 18),
              _sheetLabel('Người thực hiện'),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: executor,
                items: executors
                    .map(
                      (value) =>
                          DropdownMenuItem(value: value, child: Text(value)),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) setSheetState(() => executor = value);
                },
                decoration: _sheetDecoration(null),
              ),
              const SizedBox(height: 14),
              _sheetLabel('Tuần dự kiến thực hiện'),
              const SizedBox(height: 6),
              DropdownButtonFormField<int>(
                initialValue: plannedWeek,
                items: [1, 2, 3, 4]
                    .map(
                      (value) => DropdownMenuItem(
                        value: value,
                        child: Text('Tuần $value'),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) setSheetState(() => plannedWeek = value);
                },
                decoration: _sheetDecoration(null),
              ),
              const SizedBox(height: 14),
              _sheetLabel('Chi tiết'),
              const SizedBox(height: 6),
              TextField(
                controller: noteController,
                maxLength: 100,
                maxLines: 3,
                decoration: _sheetDecoration('Nhập chi tiết nếu cần...'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Huỷ'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () async {
                        await ActionRepository.instance.updateActionDetails(
                          actionId: item.id,
                          executor: executor,
                          plannedWeek: plannedWeek,
                          note: noteController.text,
                        );
                        if (ctx.mounted) Navigator.pop(ctx, true);
                      },
                      child: const Text('Lưu'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    noteController.dispose();
    if (updated == true) {
      await _loadItems();
    }
  }

  Widget _sheetLabel(String text) => Text(
    text,
    style: const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w700,
      color: AppColors.onSurface,
    ),
  );

  InputDecoration _sheetDecoration(String? hint) => InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: AppColors.surfaceContainerHigh,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    ),
  );
}

class _CategoryList extends StatelessWidget {
  final List<PracticeItem> items;
  final void Function(PracticeItem) onToggle;
  final void Function(PracticeItem) onEdit;

  const _CategoryList({
    required this.items,
    required this.onToggle,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(
        child: Text(
          'Chưa có hành động',
          style: TextStyle(color: AppColors.textSecondary),
        ),
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
                            ? const Icon(
                                Icons.check,
                                size: 16,
                                color: Colors.white,
                              )
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
                    IconButton(
                      onPressed: () => onEdit(item),
                      icon: const Icon(Icons.edit_note, size: 20),
                      tooltip: 'Sửa hành động',
                      color: AppColors.primary,
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Executor + planned week
                Row(
                  children: [
                    _Tag(Icons.person, item.executor, AppColors.primary),
                    const SizedBox(width: 8),
                    _Tag(
                      Icons.date_range,
                      'Tuần ${item.plannedWeek}',
                      AppColors.secondary,
                    ),
                    if (item.isCompleted) ...[
                      const SizedBox(width: 8),
                      _Tag(
                        Icons.check_circle,
                        'Đã thực hiện',
                        AppColors.accent,
                      ),
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
