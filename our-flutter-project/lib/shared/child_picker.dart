import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../mock/mock_data.dart';
import '../models/models.dart';
import '../screens/add_child_flow.dart';
import '../screens/child_detail_screen.dart';
import 'app_modals.dart';

/// Entry point used by dashboard quick-actions. Routes the user to a child's
/// detail screen, prompting selection or profile creation as needed.
void showChildPickerThenNavigate(BuildContext context, {int initialTab = 0}) {
  final children = MockData.children;

  // 1.4 — no profile yet: prompt to create one.
  if (children.isEmpty) {
    showDialog(
      context: context,
      barrierColor: AppColors.primary.withValues(alpha: 0.2),
      builder: (ctx) => BrandedModalCard(
        icon: Icons.person_add_alt_1_rounded,
        title: 'Yêu cầu tạo hồ sơ con',
        message: 'Bạn cần tạo hồ sơ cho con để bắt đầu hành trình đồng hành cùng SSCare.',
        primaryLabel: 'Tạo hồ sơ con',
        onPrimary: () {
          Navigator.of(ctx).pop();
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AddChildScreen()),
          );
        },
        secondaryLabel: 'Để sau',
        onSecondary: () => Navigator.of(ctx).pop(),
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

  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => ChildPickerScreen(initialTab: initialTab),
    ),
  );
}

/// Full-screen child profile selection grid (design 2).
class ChildPickerScreen extends StatefulWidget {
  final int initialTab;
  const ChildPickerScreen({super.key, this.initialTab = 0});

  @override
  State<ChildPickerScreen> createState() => _ChildPickerScreenState();
}

class _ChildPickerScreenState extends State<ChildPickerScreen> {
  @override
  Widget build(BuildContext context) {
    final children = MockData.children;
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Chọn hồ sơ con'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Vui lòng chọn hồ sơ của con để tiếp tục hành trình đồng hành.',
                style: TextStyle(fontSize: 14, height: 1.5, color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.82,
                  children: [
                    ...children.map((c) => _ChildCard(
                          child: c,
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) => ChildDetailScreen(child: c, initialTab: widget.initialTab),
                              ),
                            );
                          },
                        )),
                    _AddCard(
                      onTap: () async {
                        final added = await Navigator.of(context).push<bool>(
                          MaterialPageRoute(builder: (_) => const AddChildScreen()),
                        );
                        if (added == true && mounted) setState(() {});
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChildCard extends StatelessWidget {
  final ChildProfile child;
  final VoidCallback onTap;
  const _ChildCard({required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.2)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 36,
              backgroundColor: child.avatarColor.withValues(alpha: 0.2),
              child: Text(
                child.initials,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: child.avatarColor,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              child.nickname,
              style: const TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${child.age} tuổi · ${child.isFemale ? "Nữ" : "Nam"}',
              style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddCard extends StatelessWidget {
  final VoidCallback onTap;
  const _AddCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline_rounded, size: 40, color: AppColors.primary),
            SizedBox(height: 10),
            Text(
              'Thêm hồ sơ',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
