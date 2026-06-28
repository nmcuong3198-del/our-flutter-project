import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../mock/mock_data.dart';
import '../models/models.dart';
import 'add_child_flow.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notifCheckin = true;
  bool _notifCalendar = true;
  bool _notifEducation = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(title: const Text('Quản lý tài khoản')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Section 1: Thông tin tài khoản ---
            _SectionHeader('Thông tin tài khoản'),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Avatar + name
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: AppColors.primaryFixed,
                          child: const Text('H',
                              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.primary)),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(MockData.userName,
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                              const SizedBox(height: 2),
                              Text(MockData.userRole,
                                  style: const TextStyle(fontSize: 14, color: AppColors.onSurfaceVariant)),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, color: AppColors.primary),
                          onPressed: () => _showEditDialog('Tên hiển thị', MockData.userName),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    _InfoRow('Vai trò', MockData.userRole, Icons.badge,
                        onEdit: () => _showEditDialog('Vai trò', MockData.userRole)),
                    _InfoRow('Ngày sinh', '15/06/1988', Icons.cake,
                        onEdit: () => _showEditDialog('Ngày sinh', '15/06/1988')),
                    _InfoRow('Email', MockData.userEmail, Icons.email),
                    _InfoRow('Số điện thoại', MockData.userPhone, Icons.phone),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),
            // Change password
            Card(
              child: ListTile(
                leading: const Icon(Icons.lock_outlined, color: AppColors.primary),
                title: const Text('Thay đổi mật khẩu', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                trailing: const Icon(Icons.chevron_right, color: AppColors.onSurfaceVariant),
                onTap: () => _showPasswordDialog(),
              ),
            ),

            const SizedBox(height: 24),

            // --- Section 2: Quản lý hồ sơ con ---
            _SectionHeader('Quản lý hồ sơ con'),
            const SizedBox(height: 12),
            ...MockData.children.map((child) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: child.avatarColor.withValues(alpha: 0.2),
                          child: Text(child.initials,
                              style: TextStyle(fontWeight: FontWeight.w700, color: child.avatarColor)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(child.nickname,
                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                              Text('${child.age} tuổi · ${child.isFemale ? "Nữ" : "Nam"}',
                                  style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, size: 20, color: AppColors.primary),
                          onPressed: () => _showEditChildDialog(child),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, size: 20, color: AppColors.error),
                          onPressed: () => _showDeleteChildDialog(child),
                        ),
                      ],
                    ),
                  ),
                )),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _openAddChild(),
                icon: const Icon(Icons.add),
                label: const Text('Thêm hồ sơ con'),
              ),
            ),

            const SizedBox(height: 24),

            // --- Section 3: Thông báo ---
            _SectionHeader('Cài đặt thông báo'),
            const SizedBox(height: 12),
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    secondary: const Icon(Icons.edit_notifications, color: AppColors.primary),
                    title: const Text('Nhắc cập nhật', style: TextStyle(fontSize: 14)),
                    value: _notifCheckin,
                    onChanged: (v) => setState(() => _notifCheckin = v),
                    activeTrackColor: AppColors.primary,
                  ),
                  const Divider(height: 1, indent: 56),
                  SwitchListTile(
                    secondary: const Icon(Icons.calendar_month, color: AppColors.success),
                    title: const Text('Lịch nhắc nhớ', style: TextStyle(fontSize: 14)),
                    value: _notifCalendar,
                    onChanged: (v) => setState(() => _notifCalendar = v),
                    activeTrackColor: AppColors.success,
                  ),
                  const Divider(height: 1, indent: 56),
                  SwitchListTile(
                    secondary: const Icon(Icons.school, color: AppColors.tertiaryFixedDim),
                    title: const Text('Kiến thức', style: TextStyle(fontSize: 14)),
                    value: _notifEducation,
                    onChanged: (v) => setState(() => _notifEducation = v),
                    activeTrackColor: AppColors.tertiaryFixedDim,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // --- Section 4: Gói tài khoản ---
            _SectionHeader('Gói tài khoản'),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.tertiaryFixed,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.workspace_premium, color: AppColors.tertiary, size: 28),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Cơ bản', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                          SizedBox(height: 2),
                          Text('Quản lý 1 hồ sơ con', style: TextStyle(fontSize: 13, color: AppColors.onSurfaceVariant)),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Nâng cấp', style: TextStyle(fontSize: 13)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(String field, String currentValue) {
    final controller = TextEditingController(text: currentValue);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Sửa $field', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber, color: AppColors.warning, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text('$field chỉ được thay đổi 1 lần.',
                        style: const TextStyle(fontSize: 12, color: AppColors.warning)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: field,
                filled: true,
                fillColor: AppColors.surfaceContainerLow,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Huỷ')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Đã lưu $field'), behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              );
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  void _showPasswordDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Thay đổi mật khẩu', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(obscureText: true, decoration: InputDecoration(labelText: 'Mật khẩu hiện tại',
                filled: true, fillColor: AppColors.surfaceContainerLow,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
            const SizedBox(height: 12),
            TextField(obscureText: true, decoration: InputDecoration(labelText: 'Mật khẩu mới',
                filled: true, fillColor: AppColors.surfaceContainerLow,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
            const SizedBox(height: 12),
            TextField(obscureText: true, decoration: InputDecoration(labelText: 'Nhập lại mật khẩu mới',
                filled: true, fillColor: AppColors.surfaceContainerLow,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Huỷ')),
          ElevatedButton(onPressed: () {
            Navigator.pop(ctx);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: const Text('Đã đổi mật khẩu'), behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            );
          }, child: const Text('Lưu')),
        ],
      ),
    );
  }

  void _showEditChildDialog(ChildProfile child) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Sửa hồ sơ ${child.nickname}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: TextEditingController(text: child.nickname),
              decoration: InputDecoration(labelText: 'Tên gọi', filled: true, fillColor: AppColors.surfaceContainerLow,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: TextEditingController(text: '${child.dateOfBirth.day}/${child.dateOfBirth.month}/${child.dateOfBirth.year}'),
              decoration: InputDecoration(labelText: 'Ngày sinh', filled: true, fillColor: AppColors.surfaceContainerLow,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Huỷ')),
          ElevatedButton(onPressed: () {
            Navigator.pop(ctx);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: const Text('Đã lưu hồ sơ con'), behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            );
          }, child: const Text('Lưu')),
        ],
      ),
    );
  }

  void _showDeleteChildDialog(ChildProfile child) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Xoá hồ sơ con?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        content: Text('Bạn có chắc chắn xoá hồ sơ "${child.nickname}"? Thao tác này không thể hoàn tác.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Huỷ')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Đã xoá ${child.nickname}'), behavior: SnackBarBehavior.floating,
                    backgroundColor: AppColors.error,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Xoá'),
          ),
        ],
      ),
    );
  }

  Future<void> _openAddChild() async {
    final added = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const AddChildScreen()),
    );
    if (added == true && mounted) setState(() {});
  }
}

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'PlusJakartaSans',
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.primary,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final VoidCallback? onEdit;

  const _InfoRow(this.label, this.value, this.icon, {this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant)),
                Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          if (onEdit != null)
            IconButton(
              icon: const Icon(Icons.edit, size: 18, color: AppColors.primary),
              onPressed: onEdit,
            ),
        ],
      ),
    );
  }
}
