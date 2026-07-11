import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../models/device_register_request.dart';
import '../service/device_service.dart';
import 'dart:io';
import 'firebase_local_notification_service.dart';

class FirebaseNotificationService {
  FirebaseNotificationService._();

  static final FirebaseNotificationService instance =
  FirebaseNotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  NotificationSettings? _notificationSettings;

  /// Khởi tạo Firebase Notification
  Future<void> initialize() async {
    try {
      debugPrint("========== Firebase Notification ==========");

      debugPrint("Request permission...");

      await requestPermission();

      debugPrint("Register device...");

      await registerDevice();

      debugPrint("Listen token refresh...");

      listenTokenRefresh();

      debugPrint("Listen foreground notification...");

      listenForegroundMessage();

      debugPrint("========== Notification Ready ==========");
    } catch (e, stackTrace) {
      debugPrint("========== Firebase Notification Error ==========");
      debugPrint(e.toString());
      debugPrint(stackTrace.toString());
    }
  }

  /// Xin quyền nhận Notification
  Future<NotificationSettings> requestPermission() async {
    _notificationSettings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
    );

    debugPrint(
      "Notification Permission: ${_notificationSettings!.authorizationStatus}",
    );

    return _notificationSettings!;
  }

  /// Đăng ký thiết bị
  ///
  /// Hiện tại:
  /// - Lấy FCM Token
  /// - In ra Console
  ///
  /// Bước tiếp theo:
  /// - Gọi API Spring Boot
  /// - Lưu token vào PostgreSQL
  Future<void> registerDevice() async {
    debugPrint(
        "Device Type : ${Platform.isAndroid ? "ANDROID" : "IOS"}");

    final token = await getToken();

    if (Platform.isIOS) {
      final apnsToken = await _messaging.getAPNSToken();
      debugPrint("APNS Token:");
      debugPrint(apnsToken);
    }

    if (token == null) {
      debugPrint("FCM Token is null");
      return;
    }

    debugPrint("========== Register Device ==========");
    debugPrint("FCM Token:");
    debugPrint(token);

    final request = DeviceRegisterRequest(
      username: null,
      fcmToken: token,
      deviceType: Platform.isAndroid ? "ANDROID" : "IOS",
    );

    debugPrint("Sending device to backend...");

    await DeviceService.registerDevice(request);

    debugPrint("Device registration completed.");
  }

  /// Lấy FCM Token hiện tại
  Future<String?> getToken() async {
    return await _messaging.getToken();
  }

  /// Theo dõi khi Firebase đổi Token
  void listenTokenRefresh() {
    _messaging.onTokenRefresh.listen((newToken) async {
      debugPrint("========== Token Refreshed ==========");
      debugPrint("New FCM Token:");
      debugPrint(newToken);

      try {
        final request = DeviceRegisterRequest(
          username: null,
          fcmToken: newToken,
          deviceType: Platform.isAndroid ? "ANDROID" : "IOS",
        );

        await DeviceService.registerDevice(request);

        debugPrint("Token updated successfully.");
      } catch (e) {
        debugPrint("Update token failed: $e");
      }
    });
  }

  /// Khi app đang mở và nhận Notification
  void listenForegroundMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("========== Foreground Notification ==========");

      final notification = message.notification;
      debugPrint(
          "Message Id : ${message.messageId}");
      debugPrint("Title : ${message.notification?.title}");
      debugPrint("Body : ${message.notification?.body}");
      debugPrint("Data : ${message.data}");

      if (notification == null) {
        return;
      }

      FirebaseLocalNotificationService.instance.show(
        title: notification.title ?? '',
        body: notification.body ?? '',
      );
    });
  }

  NotificationSettings? get notificationSettings => _notificationSettings;

  FirebaseMessaging get messaging => _messaging;
}