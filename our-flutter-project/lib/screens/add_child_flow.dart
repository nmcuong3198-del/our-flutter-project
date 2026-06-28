import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/theme.dart';
import '../models/models.dart';
import '../mock/mock_data.dart';
import '../shared/app_modals.dart';

/// Full-screen "Thêm hồ sơ con" form (design 7.3) with the legal consent flow
/// (7.4 → 7.5 → 7.6 → 7.7 → 7.8) required for children aged 7+.
class AddChildScreen extends StatefulWidget {
  const AddChildScreen({super.key});

  @override
  State<AddChildScreen> createState() => _AddChildScreenState();
}

class _AddChildScreenState extends State<AddChildScreen> {
  final _nameController = TextEditingController();
  final _shareController = TextEditingController();
  DateTime? _dob;
  Gender _gender = Gender.female;
  late final String _profileCode;

  @override
  void initState() {
    super.initState();
    _profileCode = _generateProfileCode();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _shareController.dispose();
    super.dispose();
  }

  String _generateProfileCode() {
    const letters = 'ABCDEFGHJKLMNPQRSTUVWXYZ';
    const digits = '0123456789';
    final rng = Random();
    final l = List.generate(3, (_) => letters[rng.nextInt(letters.length)]).join();
    final d = List.generate(5, (_) => digits[rng.nextInt(digits.length)]).join();
    return '$l$d';
  }

  int? get _age {
    if (_dob == null) return null;
    return DateTime.now().difference(_dob!).inDays ~/ 365;
  }

  bool get _isValid => _nameController.text.trim().isNotEmpty && _dob != null;

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dob ?? DateTime(now.year - 8, now.month, now.day),
      firstDate: DateTime(now.year - 18),
      lastDate: now,
      helpText: 'Chọn ngày sinh của con',
    );
    if (picked != null) setState(() => _dob = picked);
  }

  void _submit() {
    if (!_isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Vui lòng nhập tên và ngày sinh của con'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }
    if ((_age ?? 0) >= 7) {
      _showLegalNotice();
    } else {
      _commitAndFinish();
    }
  }

  // 7.4 — Legal notice
  void _showLegalNotice() {
    showDialog(
      context: context,
      barrierColor: AppColors.primary.withValues(alpha: 0.2),
      builder: (ctx) => BrandedModalCard(
        icon: Icons.gavel_rounded,
        title: 'Thông báo pháp lý',
        messageWidget: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
          ),
          child: RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              style: TextStyle(
                fontSize: 14.5,
                height: 1.55,
                color: AppColors.onSurface,
                fontWeight: FontWeight.w500,
                fontFamily: 'Inter',
              ),
              children: [
                TextSpan(text: 'Với trẻ từ '),
                TextSpan(
                  text: '7 tuổi',
                  style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary),
                ),
                TextSpan(
                  text: ' trở lên, phụ huynh vui lòng đảm bảo con đã được biết và '
                      'đồng ý xác nhận việc khai báo thông tin theo quy định pháp luật hiện hành.',
                ),
              ],
            ),
          ),
        ),
        primaryLabel: 'Đã hiểu',
        onPrimary: () {
          Navigator.of(ctx).pop();
          _showTransferToChild();
        },
      ),
    );
  }

  // 7.5 — Transfer phone to child
  void _showTransferToChild() {
    showDialog(
      context: context,
      barrierColor: AppColors.primary.withValues(alpha: 0.2),
      builder: (ctx) => BrandedModalCard(
        icon: Icons.verified_user_rounded,
        title: 'Xác nhận từ con',
        message: 'Bước cuối cùng: Để đảm bảo quyền riêng tư của trẻ theo pháp luật, '
            'con cần trực tiếp xác nhận các thông tin trên. Phụ huynh vui lòng chuyển '
            'điện thoại cho con thực hiện bước này.',
        primaryLabel: 'Chuyển cho con',
        onPrimary: () {
          Navigator.of(ctx).pop();
          _showChildConfirm();
        },
      ),
    );
  }

  // 7.6 — Child's own confirmation
  void _showChildConfirm() {
    showDialog(
      context: context,
      barrierColor: AppColors.primary.withValues(alpha: 0.2),
      builder: (ctx) => BrandedModalCard(
        icon: Icons.verified_user_rounded,
        title: 'Hồ sơ của con đã sẵn sàng!',
        messageWidget: RichText(
          textAlign: TextAlign.center,
          text: const TextSpan(
            style: TextStyle(
              fontSize: 14.5,
              height: 1.55,
              color: AppColors.onSurfaceVariant,
              fontWeight: FontWeight.w500,
              fontFamily: 'Inter',
            ),
            children: [
              TextSpan(text: 'Theo quy định bảo mật, con hãy xác nhận lại sự đồng ý của mình để phụ huynh và '),
              TextSpan(
                text: 'SSCare',
                style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary),
              ),
              TextSpan(text: ' có thể bắt đầu đồng hành, hỗ trợ con!'),
            ],
          ),
        ),
        primaryLabel: 'Xác nhận đồng ý',
        onPrimary: () {
          Navigator.of(ctx).pop();
          _commitAndFinish();
        },
        secondaryLabel: 'Xem chi tiết điều khoản',
        onSecondary: () => _showTerms(),
      ),
    );
  }

  // 7.7 — Terms & conditions
  void _showTerms() {
    showDialog(
      context: context,
      barrierColor: AppColors.onSurface.withValues(alpha: 0.2),
      builder: (ctx) => const _TermsDialog(),
    );
  }

  // 7.8 — Success
  void _commitAndFinish() {
    // Persist into mock data so the new profile actually appears.
    final colors = [
      const Color(0xFFFF6B9D),
      const Color(0xFF6C63FF),
      const Color(0xFF00B8A9),
      const Color(0xFFF6A609),
    ];
    MockData.children.add(
      ChildProfile(
        id: 'c${DateTime.now().millisecondsSinceEpoch}',
        nickname: _nameController.text.trim(),
        dateOfBirth: _dob!,
        gender: _gender,
        avatarColor: colors[MockData.children.length % colors.length],
      ),
    );

    showSuccessModal(
      context,
      icon: Icons.check_circle_rounded,
      iconColor: AppColors.primary,
      iconBgColor: AppColors.secondaryContainer,
      title: 'Tạo hồ sơ con thành công!',
      message: 'Thông tin của con đã được lưu trữ an toàn. '
          'Bắt đầu hành trình đồng hành cùng SSCare.',
      buttonLabel: 'Tiếp tục',
      footer: _agePhaseLabel(),
      onClose: () => Navigator.of(context).pop(true),
    );
  }

  String _agePhaseLabel() {
    final age = _age ?? 0;
    if (age < 2) return 'Giai đoạn: Sơ sinh • 0-24 tháng';
    if (age < 6) return 'Giai đoạn: Mầm non • 2-5 tuổi';
    if (age < 11) return 'Giai đoạn: Nhi đồng • 6-10 tuổi';
    return 'Giai đoạn: Thiếu niên • 11+ tuổi';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Thêm hồ sơ con'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            // Avatar uploader
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 104,
                    height: 104,
                    decoration: const BoxDecoration(
                      color: AppColors.secondaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.child_care_rounded, size: 52, color: AppColors.primary),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.photo_camera_rounded, size: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            _FieldLabel('Tên gọi của con'),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              onChanged: (_) => setState(() {}),
              decoration: _inputDecoration('Ví dụ: Bé Bún', Icons.badge_outlined),
            ),
            const SizedBox(height: 20),

            _FieldLabel('Ngày sinh'),
            const SizedBox(height: 8),
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: _pickDob,
              child: InputDecorator(
                decoration: _inputDecoration(null, Icons.calendar_today_outlined),
                child: Text(
                  _dob == null ? 'Chọn ngày sinh' : DateFormat('dd/MM/yyyy').format(_dob!),
                  style: TextStyle(
                    fontSize: 15,
                    color: _dob == null ? AppColors.onSurfaceVariant : AppColors.onSurface,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            _FieldLabel('Giới tính'),
            const SizedBox(height: 8),
            Row(
              children: [
                _GenderOption(
                  label: 'Nam',
                  icon: Icons.male_rounded,
                  selected: _gender == Gender.male,
                  onTap: () => setState(() => _gender = Gender.male),
                ),
                const SizedBox(width: 12),
                _GenderOption(
                  label: 'Nữ',
                  icon: Icons.female_rounded,
                  selected: _gender == Gender.female,
                  onTap: () => setState(() => _gender = Gender.female),
                ),
              ],
            ),
            const SizedBox(height: 20),

            _FieldLabel('Tài khoản của con (tuỳ chọn)'),
            const SizedBox(height: 8),
            TextField(
              controller: _shareController,
              decoration: _inputDecoration('Tên đăng nhập để con tự truy cập', Icons.alternate_email_rounded),
            ),
            const SizedBox(height: 24),

            // Profile code + QR
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.qr_code_2_rounded, size: 56, color: AppColors.primary),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Mã hồ sơ',
                          style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _profileCode,
                          style: const TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Dùng mã hoặc QR để liên kết hồ sơ con với thiết bị khác.',
                          style: TextStyle(fontSize: 11.5, color: AppColors.onSurfaceVariant, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Legal note
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.secondaryContainer.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(16),
                border: const Border(left: BorderSide(color: AppColors.primary, width: 4)),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline_rounded, size: 20, color: AppColors.primary),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Với trẻ từ 7 tuổi trở lên, con cần trực tiếp xác nhận đồng ý '
                      'khai báo thông tin theo quy định pháp luật.',
                      style: TextStyle(fontSize: 12.5, height: 1.5, color: AppColors.onSurface),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _isValid ? _submit : null,
                child: const Text('Tạo hồ sơ con'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String? hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
      filled: true,
      fillColor: AppColors.surfaceContainerHigh,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13.5,
        fontWeight: FontWeight.w700,
        color: AppColors.onSurface,
      ),
    );
  }
}

class _GenderOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _GenderOption({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary.withValues(alpha: 0.1) : AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? AppColors.primary : Colors.transparent,
              width: 2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: selected ? AppColors.primary : AppColors.onSurfaceVariant),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: selected ? AppColors.primary : AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 7.7 — Scrollable terms & conditions dialog.
class _TermsDialog extends StatelessWidget {
  const _TermsDialog();

  @override
  Widget build(BuildContext context) {
    const sections = [
      ['1. Chấp nhận các điều khoản',
        'Chào mừng bạn đến với SSCare. Bằng cách truy cập hoặc sử dụng ứng dụng, bạn đồng ý '
        'tuân thủ và chịu sự ràng buộc bởi các Điều khoản sử dụng này. Nếu bạn không đồng ý với '
        'bất kỳ phần nào, vui lòng không sử dụng dịch vụ của chúng tôi.'],
      ['2. Dịch vụ chăm sóc & Dinh dưỡng',
        'SSCare cung cấp thông tin hướng dẫn về dinh dưỡng và phát triển của trẻ. Thông tin này '
        'mang tính chất tham khảo và không thay thế cho lời khuyên y tế chuyên nghiệp, chẩn đoán '
        'hoặc điều trị từ bác sĩ.'],
      ['3. Quyền riêng tư & Bảo mật',
        'Chúng tôi cam kết bảo vệ dữ liệu cá nhân của bạn và con bạn. Dữ liệu được mã hóa và lưu '
        'trữ theo các tiêu chuẩn bảo mật cao nhất. Vui lòng xem Chính sách quyền riêng tư để biết '
        'thêm chi tiết.'],
      ['4. Trách nhiệm người dùng',
        'Bạn có trách nhiệm duy trì tính bảo mật của tài khoản và mật khẩu của mình. Bạn đồng ý '
        'thông báo cho chúng tôi ngay lập tức về bất kỳ hành vi sử dụng trái phép nào.'],
      ['5. Giới hạn trách nhiệm',
        'Trong mọi trường hợp, SSCare sẽ không chịu trách nhiệm cho bất kỳ thiệt hại trực tiếp, '
        'gián tiếp, ngẫu nhiên hoặc do hậu quả nào phát sinh từ việc bạn sử dụng hoặc không thể '
        'sử dụng dịch vụ.'],
    ];

    return Dialog(
      backgroundColor: AppColors.surfaceContainerLowest,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 14, 12, 14),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.surfaceContainer)),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Điều khoản sử dụng',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: AppColors.onSurfaceVariant),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Cập nhật lần cuối: 24 Tháng 5, 2024',
                      style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
                    ),
                  ),
                  const SizedBox(height: 20),
                  for (final s in sections) ...[
                    Text(
                      s[0],
                      style: const TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      s[1],
                      style: const TextStyle(
                        fontSize: 13.5,
                        height: 1.6,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Đã hiểu'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
