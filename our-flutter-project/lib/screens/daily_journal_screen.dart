import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/theme.dart';
import '../models/models.dart';
import '../shared/app_modals.dart';

/// Daily journal (design 3.3): meals (breakfast/lunch/dinner), sleep duration,
/// and notes, with an overwrite-confirm popup when a day already has an entry.
class DailyJournalScreen extends StatefulWidget {
  final ChildProfile child;
  const DailyJournalScreen({super.key, required this.child});

  @override
  State<DailyJournalScreen> createState() => _DailyJournalScreenState();
}

class _DailyJournalScreenState extends State<DailyJournalScreen> {
  // In-memory store so re-saving a day triggers the overwrite flow.
  static final Set<String> _savedDays = {};

  final _breakfast = TextEditingController();
  final _lunch = TextEditingController();
  final _dinner = TextEditingController();
  final _notes = TextEditingController();
  DateTime _date = DateTime.now();
  double _sleepHours = 8;

  String get _dayKey => DateFormat('yyyy-MM-dd').format(_date);

  @override
  void dispose() {
    _breakfast.dispose();
    _lunch.dispose();
    _dinner.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _date = picked);
  }

  void _save() {
    if (_savedDays.contains(_dayKey)) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Đã có dữ liệu', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          content: const Text(
            'Thời gian này đã có thông tin lưu trước đó, bạn có muốn thay đổi không?',
            style: TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Không')),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                _commit();
              },
              child: const Text('Có'),
            ),
          ],
        ),
      );
    } else {
      _commit();
    }
  }

  void _commit() {
    _savedDays.add(_dayKey);
    showSuccessModal(
      context,
      icon: Icons.check_circle_rounded,
      iconColor: AppColors.primary,
      iconBgColor: AppColors.secondaryContainer,
      title: 'Đã lưu nhật ký!',
      message: 'Nhật ký ngày ${DateFormat('dd/MM/yyyy').format(_date)} của '
          '${widget.child.nickname} đã được lưu.',
      buttonLabel: 'Tiếp tục',
      onClose: () => Navigator.of(context).pop(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Nhật ký hôm nay'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          // Date
          GestureDetector(
            onTap: _pickDate,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, size: 18, color: AppColors.primary),
                  const SizedBox(width: 10),
                  Text(
                    DateFormat('dd/MM/yyyy').format(_date),
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.primary),
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_drop_down, color: AppColors.onSurfaceVariant),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          _sectionTitle('Bữa ăn'),
          const SizedBox(height: 10),
          _mealField('Bữa sáng', Icons.free_breakfast_rounded, _breakfast, 'Ví dụ: Cháo yến mạch'),
          const SizedBox(height: 10),
          _mealField('Bữa trưa', Icons.lunch_dining_rounded, _lunch, 'Ví dụ: Cơm, cá, rau'),
          const SizedBox(height: 10),
          _mealField('Bữa tối', Icons.dinner_dining_rounded, _dinner, 'Ví dụ: Cơm, thịt, canh'),
          const SizedBox(height: 24),

          _sectionTitle('Giấc ngủ'),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.bedtime_rounded, size: 20, color: AppColors.primary),
                    const SizedBox(width: 10),
                    const Flexible(
                      child: Text(
                        'Thời lượng ngủ',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${_sleepHours.toStringAsFixed(1)} giờ',
                      style: const TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: _sleepHours,
                  min: 0,
                  max: 14,
                  divisions: 28,
                  activeColor: AppColors.primary,
                  label: '${_sleepHours.toStringAsFixed(1)} giờ',
                  onChanged: (v) => setState(() => _sleepHours = v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          _sectionTitle('Ghi chú'),
          const SizedBox(height: 10),
          TextField(
            controller: _notes,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Bé ăn ngoan, vận động nhiều...',
              filled: true,
              fillColor: AppColors.surfaceContainerHigh,
              contentPadding: const EdgeInsets.all(14),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 28),

          SizedBox(
            height: 54,
            child: ElevatedButton(
              onPressed: _save,
              child: const Text('Lưu'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String t) => Text(
        t,
        style: const TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
        ),
      );

  Widget _mealField(String label, IconData icon, TextEditingController c, String hint) {
    return TextField(
      controller: c,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
        filled: true,
        fillColor: AppColors.surfaceContainerHigh,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      ),
    );
  }
}
