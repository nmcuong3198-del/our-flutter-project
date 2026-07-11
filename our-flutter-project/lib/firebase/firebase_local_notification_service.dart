import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseLocalNotificationService {
  FirebaseLocalNotificationService._();

  static final FirebaseLocalNotificationService instance =
  FirebaseLocalNotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel =
  AndroidNotificationChannel(
    'sscare_notification_channel',
    'SSCare Notifications',
    description: 'Channel used for SSCare notifications',
    importance: Importance.high,
  );

  Future<void> initialize() async {
    const androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const settings = InitializationSettings(
      android: androidSettings,
    );

    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        print("Notification clicked");
        print(response.payload);
      },
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
  }

  Future<void> show({
    required String title,
    required String body,
    String? payload,
  }) async {

    print("===============================");
    print("Show Local Notification");
    print("Title : $title");
    print("Body  : $body");
    print("===============================");

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'sscare_notification_channel',
        'SSCare Notifications',
        channelDescription: 'Channel used for SSCare notifications',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        visibility: NotificationVisibility.public,
      ),
    );

    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
      payload: payload,
    );
  }
}