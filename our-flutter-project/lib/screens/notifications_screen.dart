import 'package:flutter/material.dart';
import '../core/strings.dart';
import '../core/theme.dart';
import '../mock/mock_data.dart';
import '../models/models.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // 'all' | 'child' | 'other'
  String _filter = 'all';

  List<AppNotification> get _filtered {
    final all = MockData.notifications;
    if (_filter == 'all') return all;
    return all.where((n) => n.category == _filter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final notifs = _filtered;
    final unreadCount = MockData.notifications.where((n) => !n.isRead).length;

    // Group by day bucket preserving order.
    final today = <AppNotification>[];
    final yesterday = <AppNotification>[];
    final earlier = <AppNotification>[];
    final now = DateTime.now();
    for (final n in notifs) {
      final days = DateUtils.dateOnly(now).difference(DateUtils.dateOnly(n.date)).inDays;
      if (days <= 0) {
        today.add(n);
      } else if (days == 1) {
        yesterday.add(n);
      } else {
        earlier.add(n);
      }
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(S.notifTitle),
            if (unreadCount > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$unreadCount ${S.notifNew}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
      body: Column(
        children: [
          // Filter pills
          SizedBox(
            height: 56,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                _FilterPill(
                  label: 'Tất cả',
                  selected: _filter == 'all',
                  onTap: () => setState(() => _filter = 'all'),
                ),
                _FilterPill(
                  label: 'Quản lý con',
                  selected: _filter == 'child',
                  onTap: () => setState(() => _filter = 'child'),
                ),
                _FilterPill(
                  label: 'Khác',
                  selected: _filter == 'other',
                  onTap: () => setState(() => _filter = 'other'),
                ),
              ],
            ),
          ),
          Expanded(
            child: notifs.isEmpty
                ? _buildEmpty()
                : ListView(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                    children: [
                      if (today.isNotEmpty) ...[
                        const _DateHeader('Hôm nay'),
                        ...today.map(_card),
                      ],
                      if (yesterday.isNotEmpty) ...[
                        const _DateHeader('Hôm qua'),
                        ...yesterday.map(_card),
                      ],
                      if (earlier.isNotEmpty) ...[
                        const _DateHeader('Trước đó'),
                        ...earlier.map(_card),
                      ],
                      const SizedBox(height: 12),
                      Center(
                        child: Text(
                          'Bạn đã xem hết thông báo mới nhất',
                          style: TextStyle(
                            fontSize: 12.5,
                            color: AppColors.onSurfaceVariant.withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.notifications_none, size: 64, color: AppColors.pending),
          const SizedBox(height: 16),
          const Text(
            'Bạn đã xem hết thông báo mới nhất',
            style: TextStyle(fontSize: 15, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _card(AppNotification n) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: n.isRead ? AppColors.surface : AppColors.primary.withValues(alpha: 0.04),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => setState(() => n.isRead = true),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _iconBg(n.type),
                  shape: BoxShape.circle,
                ),
                child: Icon(_iconData(n.type), color: _iconColor(n.type), size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            n.title,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: n.isRead ? FontWeight.w500 : FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _timeAgo(n.date),
                          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                        ),
                        if (!n.isRead) ...[
                          const SizedBox(width: 8),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      n.body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13, height: 1.35, color: AppColors.onSurfaceVariant),
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

  IconData _iconData(String type) {
    switch (type) {
      case 'article':
        return Icons.lightbulb_outline_rounded;
      case 'checkin':
        return Icons.event_note_rounded;
      default:
        return Icons.info_outline_rounded;
    }
  }

  Color _iconColor(String type) {
    switch (type) {
      case 'article':
        return AppColors.primary;
      case 'checkin':
        return AppColors.tertiary;
      default:
        return AppColors.secondary;
    }
  }

  Color _iconBg(String type) {
    switch (type) {
      case 'article':
        return AppColors.primaryFixed;
      case 'checkin':
        return AppColors.tertiaryFixed;
      default:
        return AppColors.secondaryFixed;
    }
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút';
    if (diff.inHours < 24) return '${diff.inHours} giờ';
    return '${diff.inDays} ngày';
  }
}

class _FilterPill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterPill({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(9999),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : AppColors.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}

class _DateHeader extends StatelessWidget {
  final String label;
  const _DateHeader(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 12, 0, 10),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
