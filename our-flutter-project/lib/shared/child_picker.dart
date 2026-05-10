import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../mock/mock_data.dart';
import '../models/models.dart';
import '../screens/child_detail_screen.dart';

/// Shows a bottom sheet child picker, then navigates to child detail at [initialTab].
void showChildPickerThenNavigate(BuildContext context, {int initialTab = 0}) {
  final children = MockData.children;
  if (children.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Bạn chưa tạo hồ sơ con. Tạo hồ sơ con tại Quản lý con!'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    return;
  }
  if (children.length == 1) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChildDetailScreen(child: children.first, initialTab: initialTab),
      ),
    );
    return;
  }
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Chọn con',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          ...children.map((child) => ListTile(
                leading: CircleAvatar(
                  backgroundColor: child.avatarColor.withValues(alpha: 0.2),
                  child: Text(
                    child.initials,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: child.avatarColor,
                    ),
                  ),
                ),
                title: Text(child.nickname,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(
                    '${child.age} tuổi · ${child.isFemale ? "Nữ" : "Nam"}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ChildDetailScreen(
                          child: child, initialTab: initialTab),
                    ),
                  );
                },
              )),
          const SizedBox(height: 8),
        ],
      ),
    ),
  );
}
