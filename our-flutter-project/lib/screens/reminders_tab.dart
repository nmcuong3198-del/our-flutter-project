import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../mock/mock_data.dart';
import '../models/models.dart';

class RemindersTab extends StatefulWidget {
  final ChildProfile child;
  const RemindersTab({super.key, required this.child});

  @override
  State<RemindersTab> createState() => _RemindersTabState();
}

class _RemindersTabState extends State<RemindersTab> {
  late List<Reminder> _reminders;

  @override
  void initState() {
    super.initState();
    _reminders = MockData.remindersFor(widget.child.id);
  }

  @override
  Widget build(BuildContext context) {
    final active = _reminders.where((r) => r.isActive).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    final inactive = _reminders.where((r) => !r.isActive).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Icon(Icons.event_note, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Ghi chú & nhắc nhở',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_reminders.length}/10',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Active reminders
          if (active.isNotEmpty) ...[
            const Text(
              'Sắp tới',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            ...active.map((r) => _ReminderCard(
                  reminder: r,
                  onToggle: () => setState(() => r.isActive = !r.isActive),
                  onDelete: () => setState(() => _reminders.remove(r)),
                )),
          ],

          if (inactive.isNotEmpty) ...[
            const SizedBox(height: 20),
            const Text(
              'Đã hoàn thành',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            ...inactive.map((r) => _ReminderCard(
                  reminder: r,
                  onToggle: () => setState(() => r.isActive = !r.isActive),
                  onDelete: () => setState(() => _reminders.remove(r)),
                )),
          ],

          const SizedBox(height: 20),

          // Add button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _showAddNoteSheet,
              icon: const Icon(Icons.add),
              label: const Text('Thêm ghi chú'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  void _showAddNoteSheet() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));

    showModalBottomSheet(
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
                'Thêm ghi chú',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Lưu trữ các thông tin cần chú ý để hỗ trợ con tốt hơn!',
                style: TextStyle(fontSize: 13, color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: 18),
              _sheetLabel('Tên ghi chú'),
              const SizedBox(height: 6),
              TextField(
                controller: titleController,
                onChanged: (_) => setSheetState(() {}),
                decoration: _sheetDecoration('Ví dụ: Đưa con đi khám răng'),
              ),
              const SizedBox(height: 14),
              _sheetLabel('Thời gian thực hiện dự kiến'),
              const SizedBox(height: 6),
              InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: ctx,
                    initialDate: selectedDate,
                    firstDate: DateTime.now().subtract(const Duration(days: 1)),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) setSheetState(() => selectedDate = picked);
                },
                child: InputDecorator(
                  decoration: _sheetDecoration(null).copyWith(
                    prefixIcon: const Icon(Icons.calendar_today_outlined,
                        size: 18, color: AppColors.primary),
                  ),
                  child: Text(
                    '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              _sheetLabel('Nội dung ghi chú'),
              const SizedBox(height: 6),
              TextField(
                controller: contentController,
                maxLines: 4,
                decoration: _sheetDecoration('Nhập nội dung chi tiết...'),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Huỷ'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: titleController.text.trim().isEmpty
                          ? null
                          : () {
                              setState(() {
                                _reminders.add(Reminder(
                                  id: 'r${DateTime.now().millisecondsSinceEpoch}',
                                  childId: widget.child.id,
                                  date: selectedDate,
                                  label: titleController.text.trim(),
                                  note: contentController.text.trim().isEmpty
                                      ? null
                                      : contentController.text.trim(),
                                ));
                              });
                              Navigator.pop(ctx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Đã thêm ghi chú'),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              );
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
  }

  Widget _sheetLabel(String text) => Text(
        text,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.onSurface),
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

class _ReminderCard extends StatelessWidget {
  final Reminder reminder;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const _ReminderCard({
    required this.reminder,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final diff = reminder.date.difference(now);
    final isPast = diff.isNegative;
    final daysText = isPast
        ? '${-diff.inDays} ngày trước'
        : (diff.inDays == 0
            ? 'Hôm nay'
            : (diff.inDays == 1 ? 'Ngày mai' : '${diff.inDays} ngày nữa'));
    final dateStr =
        '${reminder.date.day}/${reminder.date.month}/${reminder.date.year}';

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: reminder.isActive ? AppColors.surface : AppColors.background,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // Date badge
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: (reminder.isActive
                        ? (isPast ? AppColors.overdue : AppColors.primary)
                        : AppColors.pending)
                    .withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${reminder.date.day}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: reminder.isActive
                          ? (isPast ? AppColors.overdue : AppColors.primary)
                          : AppColors.pending,
                    ),
                  ),
                  Text(
                    'T${reminder.date.month}',
                    style: TextStyle(
                      fontSize: 10,
                      color: reminder.isActive
                          ? AppColors.textSecondary
                          : AppColors.pending,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reminder.label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: reminder.isActive
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                      decoration:
                          reminder.isActive ? null : TextDecoration.lineThrough,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$dateStr · $daysText',
                    style: TextStyle(
                      fontSize: 11,
                      color: isPast && reminder.isActive
                          ? AppColors.overdue
                          : AppColors.textSecondary,
                    ),
                  ),
                  if (reminder.note != null && reminder.note!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      reminder.note!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.35,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Actions
            IconButton(
              icon: Icon(
                reminder.isActive
                    ? Icons.check_circle_outline
                    : Icons.refresh,
                color: reminder.isActive
                    ? AppColors.accent
                    : AppColors.textSecondary,
                size: 22,
              ),
              onPressed: onToggle,
              tooltip: reminder.isActive ? 'Hoàn thành' : 'Khôi phục',
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline,
                  color: AppColors.textSecondary, size: 22),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Xoá ghi chú?',
                        style: TextStyle(fontSize: 16)),
                    content:
                        Text('Bạn có chắc chắn xoá "${reminder.label}"?'),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Huỷ')),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          onDelete();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.error),
                        child: const Text('Xoá'),
                      ),
                    ],
                  ),
                );
              },
              tooltip: 'Xoá',
            ),
          ],
        ),
      ),
    );
  }
}
