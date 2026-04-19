import 'package:flutter/material.dart';
import '../core/strings.dart';
import '../core/theme.dart';
import '../mock/mock_data.dart';
import '../models/models.dart';

class DashboardScreen extends StatefulWidget {
  final void Function(ChildProfile child) onChildTap;

  const DashboardScreen({super.key, required this.onChildTap});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _pageController = PageController(viewportFraction: 0.9);
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final children = MockData.children;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(S.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
            child: Text(
              S.appTagline,
              style: TextStyle(
                fontSize: 15,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          // Page indicator dots
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: List.generate(children.length, (i) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.only(right: 8),
                  width: _currentPage == i ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == i
                        ? AppColors.primary
                        : AppColors.pending,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ),
          // Child cards - swipeable
          SizedBox(
            height: 280,
            child: PageView.builder(
              controller: _pageController,
              itemCount: children.length,
              onPageChanged: (i) => setState(() => _currentPage = i),
              itemBuilder: (context, index) {
                return _ChildCard(
                  child: children[index],
                  onTap: () => widget.onChildTap(children[index]),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          // Quick actions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Hành động nhanh',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _QuickAction(
                  icon: Icons.edit_note,
                  label: 'Check-in',
                  color: AppColors.primary,
                  onTap: () => widget.onChildTap(children[_currentPage]),
                ),
                const SizedBox(width: 12),
                _QuickAction(
                  icon: Icons.straighten,
                  label: S.measurements,
                  color: AppColors.accent,
                  onTap: () => widget.onChildTap(children[_currentPage]),
                ),
                const SizedBox(width: 12),
                _QuickAction(
                  icon: Icons.bar_chart,
                  label: S.reports,
                  color: AppColors.secondary,
                  onTap: () => widget.onChildTap(children[_currentPage]),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Recent checkins
          Expanded(
            child: _RecentCheckins(childId: children[_currentPage].id),
          ),
        ],
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
    final isCheckedInToday = child.lastCheckinDate != null &&
        DateUtils.isSameDay(child.lastCheckinDate!, DateTime.now());

    final ringColor = isCheckedInToday
        ? AppColors.checkedIn
        : (child.streakDays == 0 ? AppColors.overdue : AppColors.pending);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Avatar with status ring
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: ringColor, width: 3),
                    ),
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor: child.avatarColor.withValues(alpha: 0.2),
                      child: Text(
                        child.initials,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: child.avatarColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          child.nickname,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${child.age} ${S.age} · ${child.isFemale ? "Nữ" : "Nam"}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 16),
              // Stats row
              Row(
                children: [
                  _StatChip(
                    icon: Icons.local_fire_department,
                    label: '${child.streakDays} ${S.streakDays}',
                    color: AppColors.secondary,
                  ),
                  const SizedBox(width: 12),
                  _StatChip(
                    icon: isCheckedInToday
                        ? Icons.check_circle
                        : Icons.schedule,
                    label: isCheckedInToday
                        ? S.todayChecked
                        : S.noCheckinYet,
                    color: isCheckedInToday
                        ? AppColors.checkedIn
                        : AppColors.textSecondary,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Progress bar (week)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${child.streakDays}/7 ngày tuần này',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: child.streakDays / 7,
                      minHeight: 6,
                      backgroundColor: AppColors.background,
                      valueColor: const AlwaysStoppedAnimation(AppColors.primary),
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
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentCheckins extends StatelessWidget {
  final String childId;

  const _RecentCheckins({required this.childId});

  @override
  Widget build(BuildContext context) {
    final checkins = MockData.checkinsFor(childId).take(3).toList();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Lịch sử gần đây',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: checkins.length,
              itemBuilder: (context, index) {
                final c = checkins[index];
                final dateStr =
                    '${c.date.day}/${c.date.month}/${c.date.year}';
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: c.emotions.isEmpty
                          ? AppColors.pending
                          : AppColors.primary.withValues(alpha: 0.1),
                      child: Text(
                        c.emotions.isNotEmpty ? '😊' : '—',
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    title: Text(
                      c.emotions.isNotEmpty
                          ? c.emotions.join(', ')
                          : S.noCheckinYet,
                      style: const TextStyle(fontSize: 14),
                    ),
                    subtitle: Text(dateStr,
                        style: const TextStyle(fontSize: 12)),
                    trailing: c.symptoms.isNotEmpty
                        ? Text(
                            c.symptoms.first,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          )
                        : null,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
