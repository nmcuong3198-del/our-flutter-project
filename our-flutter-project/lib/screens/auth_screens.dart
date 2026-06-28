import 'package:flutter/material.dart';
import '../core/theme.dart';

class LoginScreen extends StatelessWidget {
  final VoidCallback onLogin;
  final VoidCallback onRegister;

  const LoginScreen({super.key, required this.onLogin, required this.onRegister});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.favorite, color: Colors.white, size: 28),
            ),
            const SizedBox(height: 24),
            const Text(
              'Đăng nhập',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Chào mừng bạn quay lại SSCare',
              style: TextStyle(fontSize: 15, color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: 32),

            // Email/Phone
            const Text('Email hoặc Số điện thoại',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: 'Nhập email hoặc số điện thoại',
                hintStyle: const TextStyle(color: AppColors.outlineVariant),
                filled: true,
                fillColor: AppColors.surfaceContainerLow,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.email_outlined, color: AppColors.secondary),
              ),
            ),
            const SizedBox(height: 20),

            // Password
            const Text('Mật khẩu',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Nhập mật khẩu',
                hintStyle: const TextStyle(color: AppColors.outlineVariant),
                filled: true,
                fillColor: AppColors.surfaceContainerLow,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.lock_outlined, color: AppColors.secondary),
                suffixIcon: const Icon(Icons.visibility_off_outlined, color: AppColors.secondary),
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: const Text('Quên mật khẩu?',
                    style: TextStyle(fontSize: 13, color: AppColors.primary)),
              ),
            ),
            const SizedBox(height: 24),

            // Login button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onLogin,
                child: const Text('Đăng nhập →'),
              ),
            ),
            const SizedBox(height: 16),

            // Register link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Chưa có tài khoản? ',
                    style: TextStyle(color: AppColors.onSurfaceVariant)),
                GestureDetector(
                  onTap: onRegister,
                  child: const Text(
                    'Đăng ký ngay',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  final VoidCallback onRegister;
  final VoidCallback onLogin;

  const RegisterScreen({super.key, required this.onRegister, required this.onLogin});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  int _step = 0; // 0 = role selection, 1 = account creation
  String _role = 'Mẹ';

  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _submitted = false;

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  String? get _passwordError {
    if (!_submitted) return null;
    final p = _passwordController.text;
    if (p.length < 8) return 'Mật khẩu tối thiểu 8 ký tự';
    if (!RegExp(r'[A-Za-z]').hasMatch(p) || !RegExp(r'[0-9]').hasMatch(p)) {
      return 'Mật khẩu phải gồm cả chữ và số';
    }
    return null;
  }

  String? get _confirmError {
    if (!_submitted) return null;
    if (_confirmController.text != _passwordController.text) {
      return 'Mật khẩu nhập lại không khớp';
    }
    return null;
  }

  void _finish() {
    setState(() => _submitted = true);
    if (_nameController.text.trim().isEmpty ||
        _contactController.text.trim().isEmpty ||
        _passwordError != null ||
        _confirmError != null) {
      return;
    }
    widget.onRegister();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: BackButton(
          onPressed: () {
            if (_step == 1) {
              setState(() => _step = 0);
            } else {
              widget.onLogin();
            }
          },
        ),
        title: const Text('Đăng ký'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress
            Row(
              children: [
                Expanded(child: _progressSegment(true)),
                const SizedBox(width: 8),
                Expanded(child: _progressSegment(_step >= 1)),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Bước ${_step + 1} của 2',
              style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: 24),
            if (_step == 0) ..._buildRoleStep() else ..._buildAccountStep(),
          ],
        ),
      ),
    );
  }

  Widget _progressSegment(bool filled) {
    return Container(
      height: 6,
      decoration: BoxDecoration(
        color: filled ? AppColors.primary : AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  List<Widget> _buildRoleStep() {
    return [
      const Text(
        'Bạn là:',
        style: TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: AppColors.primary,
        ),
      ),
      const SizedBox(height: 20),
      _RoleCard(
        label: 'Bố',
        icon: Icons.face_6_rounded,
        selected: _role == 'Bố',
        onTap: () => setState(() => _role = 'Bố'),
      ),
      const SizedBox(height: 12),
      _RoleCard(
        label: 'Mẹ',
        icon: Icons.face_3_rounded,
        selected: _role == 'Mẹ',
        onTap: () => setState(() => _role = 'Mẹ'),
      ),
      const SizedBox(height: 12),
      _RoleCard(
        label: 'Người giám hộ khác',
        icon: Icons.groups_rounded,
        selected: _role == 'Người giám hộ khác',
        onTap: () => setState(() => _role = 'Người giám hộ khác'),
      ),
      const SizedBox(height: 32),
      SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => setState(() => _step = 1),
          child: const Text('Tiếp tục'),
        ),
      ),
    ];
  }

  List<Widget> _buildAccountStep() {
    return [
      const Text(
        'Tạo tài khoản mới',
        style: TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: AppColors.primary,
        ),
      ),
      const SizedBox(height: 8),
      const Text(
        'Hoàn tất thông tin để bắt đầu đồng hành cùng con',
        style: TextStyle(fontSize: 14, color: AppColors.onSurfaceVariant),
      ),
      const SizedBox(height: 24),
      _field(
        label: 'Tên hiển thị',
        hint: 'Nhập tên hiển thị của bạn',
        icon: Icons.person_outlined,
        controller: _nameController,
        help: 'Tên hiển thị của bạn trên ứng dụng',
      ),
      const SizedBox(height: 18),
      _field(
        label: 'Email hoặc SĐT',
        hint: 'Nhập email hoặc số điện thoại',
        icon: Icons.alternate_email_rounded,
        controller: _contactController,
        help: 'Dùng để đăng nhập và khôi phục tài khoản',
      ),
      const SizedBox(height: 18),
      _field(
        label: 'Mật khẩu',
        hint: 'Nhập mật khẩu',
        icon: Icons.lock_outlined,
        controller: _passwordController,
        obscure: _obscurePassword,
        onToggleObscure: () => setState(() => _obscurePassword = !_obscurePassword),
        help: 'Tối thiểu 8 ký tự, bao gồm chữ và số',
        error: _passwordError,
      ),
      const SizedBox(height: 18),
      _field(
        label: 'Nhắc lại mật khẩu',
        hint: 'Nhập lại mật khẩu',
        icon: Icons.verified_user_outlined,
        controller: _confirmController,
        obscure: _obscureConfirm,
        onToggleObscure: () => setState(() => _obscureConfirm = !_obscureConfirm),
        help: 'Xác nhận lại mật khẩu đã nhập',
        error: _confirmError,
      ),
      const SizedBox(height: 28),
      SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _finish,
          child: const Text('Hoàn thành'),
        ),
      ),
      const SizedBox(height: 16),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Đã có tài khoản? ', style: TextStyle(color: AppColors.onSurfaceVariant)),
          GestureDetector(
            onTap: widget.onLogin,
            child: const Text('Đăng nhập',
                style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    ];
  }

  Widget _field({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    String? help,
    String? error,
    bool obscure = false,
    VoidCallback? onToggleObscure,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.outlineVariant),
            filled: true,
            fillColor: AppColors.surfaceContainerLow,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            errorText: error,
            prefixIcon: Icon(icon, color: AppColors.secondary),
            suffixIcon: onToggleObscure != null
                ? IconButton(
                    icon: Icon(
                      obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: AppColors.secondary,
                    ),
                    onPressed: onToggleObscure,
                  )
                : null,
          ),
        ),
        if (help != null && error == null) ...[
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              help,
              style: TextStyle(fontSize: 11.5, color: AppColors.onSurfaceVariant.withValues(alpha: 0.8)),
            ),
          ),
        ],
      ],
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? AppColors.surfaceContainerLowest : AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: selected ? AppColors.primary.withValues(alpha: 0.12) : AppColors.surfaceContainerHigh,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: selected ? AppColors.primary : AppColors.onSurfaceVariant),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: selected ? AppColors.primary : AppColors.onSurface,
                ),
              ),
            ),
            if (selected) const Icon(Icons.check_circle_rounded, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
