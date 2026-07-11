import 'package:flutter/material.dart';

class NotificationRouter {
  NotificationRouter._();

  static final NotificationRouter instance =
  NotificationRouter._();

  final navigatorKey = GlobalKey<NavigatorState>();

  Future<void> openNotification(Map<String, dynamic> data) async {
    debugPrint("Notification Data:");
    debugPrint(data.toString());

    final type = data["type"];

    switch (type) {
      case "chat":
        debugPrint("Open Chat Screen");
        break;

      case "video_call":
        debugPrint("Open Video Call");
        break;

      case "notification":
        debugPrint("Open Notification Screen");
        break;

      default:
        debugPrint("Unknown notification type");
    }
  }
}