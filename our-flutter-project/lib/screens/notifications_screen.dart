import 'package:flutter/material.dart';
import '../core/strings.dart';
import '../core/theme.dart';
import '../mock/mock_data.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    final notifs = MockData.notifications;
    final unreadCount = notifs.where((n) => !n.isRead).length;

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
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
      body: notifs.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_none,
                      size: 64, color: AppColors.pending),
                  const SizedBox(height: 16),
                  const Text(
                    S.notifEmpty,
                    style: TextStyle(
                        fontSize: 16, color: AppColors.textSecondary),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notifs.length,
              itemBuilder: (context, index) {
                final n = notifs[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  color: n.isRead
                      ? AppColors.surface
                      : AppColors.primary.withValues(alpha: 0.04),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _iconColor(n.type).withValues(alpha: 0.15),
                      child:
                          Icon(_iconData(n.type), color: _iconColor(n.type), size: 20),
                    ),
                    title: Text(
                      n.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            n.isRead ? FontWeight.w500 : FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 2),
                        Text(
                          n.body,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 13, height: 1.3),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _timeAgo(n.date),
                          style: const TextStyle(
                              fontSize: 11, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                    trailing: n.isRead
                        ? null
                        : Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                    onTap: () {
                      setState(() => n.isRead = true);
                    },
                  ),
                );
              },
            ),
    );
  }

  IconData _iconData(String type) {
    switch (type) {
      case 'article':
        return Icons.article;
      case 'checkin':
        return Icons.edit_note;
      default:
        return Icons.info_outline;
    }
  }

  Color _iconColor(String type) {
    switch (type) {
      case 'article':
        return AppColors.primary;
      case 'checkin':
        return AppColors.secondary;
      default:
        return AppColors.accent;
    }
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    return '${diff.inDays} ngày trước';
  }
}
