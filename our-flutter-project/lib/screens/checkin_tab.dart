import 'package:flutter/material.dart';
import '../core/strings.dart';
import '../core/theme.dart';
import '../mock/mock_data.dart';
import '../models/models.dart';
import 'daily_journal_screen.dart';

class CheckinTab extends StatefulWidget {
  final ChildProfile child;

  const CheckinTab({super.key, required this.child});

  @override
  State<CheckinTab> createState() => _CheckinTabState();
}

class _CheckinTabState extends State<CheckinTab> {
  final Set<String> _selectedEmotions = {};
  String? _selectedBodyStatus;
  final Set<String> _selectedSymptoms = {};
  final _notesController = TextEditingController();
  bool _saved = false;
  late DateTime _selectedDate;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _checkExistingData();
  }

  void _checkExistingData() {
    final checkins = MockData.checkinsFor(widget.child.id);
    final existing = checkins.where((c) =>
        c.date.year == _selectedDate.year &&
        c.date.month == _selectedDate.month &&
        c.date.day == _selectedDate.day &&
        c.emotions.isNotEmpty).toList();
    if (existing.isNotEmpty) {
      _isEditing = true;
      final c = existing.first;
      _selectedEmotions.addAll(c.emotions);
      _selectedBodyStatus = c.bodyStatus;
      _selectedSymptoms.addAll(c.symptoms);
      if (c.notes != null) _notesController.text = c.notes!;
    } else {
      _isEditing = false;
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _selectedEmotions.clear();
        _selectedBodyStatus = null;
        _selectedSymptoms.clear();
        _notesController.clear();
        _saved = false;
        _checkExistingData();
      });
      if (_isEditing) {
        _showDateValidationPopup(isExisting: true);
      }
    }
  }

  void _showDateValidationPopup({required bool isExisting}) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          isExisting ? 'Ngày đã có thông tin' : 'Ngày chưa có thông tin',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        content: Text(
          isExisting
              ? 'Ngày này đã có thông tin lưu trước đó. Bạn có muốn thay đổi không?'
              : 'Ngày này chưa có thông tin. Vui lòng chọn Thêm mới.',
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Huỷ'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(isExisting ? 'Sửa' : 'Thêm mới'),
          ),
        ],
      ),
    );
  }

  List<_EmoItem> get _emotions => [
        _EmoItem('😄', S.emotionHappy),
        _EmoItem('🙂', S.emotionNormal),
        _EmoItem('😕', S.emotionTired),
        _EmoItem('😢', S.emotionSad),
        _EmoItem('😡', S.emotionAngry),
        _EmoItem('😰', S.emotionWorried),
        _EmoItem('😴', S.emotionSluggish),
        _EmoItem('❓', S.emotionOther),
      ];

  List<_BodyItem> get _bodyOptions => widget.child.isFemale
      ? [
          _BodyItem(Icons.water_drop, S.bodyInPeriod),
          _BodyItem(Icons.opacity, S.bodyDischarge),
          _BodyItem(Icons.check_circle_outline, S.bodyNotInPeriod),
          _BodyItem(Icons.trending_up, S.bodyPuberty),
        ]
      : [
          _BodyItem(Icons.nights_stay, S.bodyNocturnal),
          _BodyItem(Icons.flash_on, S.bodyTension),
          _BodyItem(Icons.check_circle_outline, S.bodyNone),
          _BodyItem(Icons.trending_up, S.bodyPuberty),
        ];

  List<_SymItem> get _symptoms => [
        _SymItem(Icons.fitness_center, S.symptomHealthy),
        _SymItem(Icons.battery_alert, S.symptomTired),
        _SymItem(Icons.psychology, S.symptomHeadache),
        _SymItem(Icons.sick, S.symptomStomach),
        _SymItem(Icons.accessibility_new, S.symptomBack),
        _SymItem(Icons.emoji_nature, S.symptomNausea),
        _SymItem(Icons.rotate_left, S.symptomDizzy),
        _SymItem(Icons.face, S.symptomAcne),
        _SymItem(Icons.sentiment_dissatisfied, S.symptomIrritable),
        _SymItem(Icons.more_horiz, S.symptomOther),
      ];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _save() {
    setState(() => _saved = true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(S.saved),
        backgroundColor: AppColors.checkedIn,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Daily journal entry (design 3.3)
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => DailyJournalScreen(child: widget.child),
                ),
              ),
              icon: const Icon(Icons.menu_book_rounded, size: 18),
              label: const Text('Nhật ký hôm nay'),
            ),
          ),
          const SizedBox(height: 16),
          // Date picker
          GestureDetector(
            onTap: _pickDate,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, size: 18, color: AppColors.primary),
                  const SizedBox(width: 10),
                  Text(
                    '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  const Spacer(),
                  if (_isEditing)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Đang sửa',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.warning),
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Thêm mới',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.success),
                      ),
                    ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_drop_down, color: AppColors.onSurfaceVariant),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Emotions
          _SectionTitle(S.emotionTitle),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _emotions.map((e) {
              final selected = _selectedEmotions.contains(e.label);
              return GestureDetector(
                onTap: () => setState(() {
                  selected
                      ? _selectedEmotions.remove(e.label)
                      : _selectedEmotions.add(e.label);
                }),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.primary.withValues(alpha: 0.15)
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selected ? AppColors.primary : AppColors.pending,
                      width: selected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(e.emoji, style: const TextStyle(fontSize: 28)),
                      const SizedBox(height: 4),
                      Text(
                        e.label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight:
                              selected ? FontWeight.w700 : FontWeight.w500,
                          color: selected
                              ? AppColors.primary
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 28),

          // Body status
          _SectionTitle(S.bodyTitle),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _bodyOptions.map((b) {
              final selected = _selectedBodyStatus == b.label;
              return GestureDetector(
                onTap: () => setState(() => _selectedBodyStatus = b.label),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.secondary.withValues(alpha: 0.15)
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          selected ? AppColors.secondary : AppColors.pending,
                      width: selected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(b.icon,
                          size: 20,
                          color: selected
                              ? AppColors.secondary
                              : AppColors.textSecondary),
                      const SizedBox(width: 6),
                      Text(
                        b.label,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight:
                              selected ? FontWeight.w700 : FontWeight.w500,
                          color: selected
                              ? AppColors.secondary
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 28),

          // Symptoms
          _SectionTitle(S.symptomsTitle),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _symptoms.map((s) {
              final selected = _selectedSymptoms.contains(s.label);
              return GestureDetector(
                onTap: () => setState(() {
                  selected
                      ? _selectedSymptoms.remove(s.label)
                      : _selectedSymptoms.add(s.label);
                }),
                child: Chip(
                  avatar: Icon(s.icon,
                      size: 18,
                      color: selected
                          ? AppColors.accent
                          : AppColors.textSecondary),
                  label: Text(s.label),
                  labelStyle: TextStyle(
                    fontSize: 12,
                    color: selected
                        ? AppColors.accent
                        : AppColors.textSecondary,
                    fontWeight:
                        selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                  backgroundColor: selected
                      ? AppColors.accent.withValues(alpha: 0.15)
                      : AppColors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color:
                          selected ? AppColors.accent : AppColors.pending,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 28),

          // Notes
          _SectionTitle(S.notesTitle),
          const SizedBox(height: 12),
          TextField(
            controller: _notesController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: S.notesHint,
              hintStyle: const TextStyle(color: AppColors.textSecondary),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.pending),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.pending),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
          ),

          const SizedBox(height: 28),

          // Save button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _saved ? null : _save,
              icon: Icon(_saved ? Icons.check : Icons.save),
              label: Text(_saved ? S.saved : S.save),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }
}

class _EmoItem {
  final String emoji;
  final String label;
  _EmoItem(this.emoji, this.label);
}

class _BodyItem {
  final IconData icon;
  final String label;
  _BodyItem(this.icon, this.label);
}

class _SymItem {
  final IconData icon;
  final String label;
  _SymItem(this.icon, this.label);
}
