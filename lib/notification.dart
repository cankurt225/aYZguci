import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notification_Api {
  static final notification_ = FlutterLocalNotificationsPlugin();

  final AndroidInitializationSettings androidInitializationSettings =
      AndroidInitializationSettings("logo");

  void InitilazeNotifications() async {
    InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitializationSettings);

    await notification_.initialize(
      initializationSettings,
    );
  }

  void sendNotifications(String? title, String? body) async {
    NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails("chanel id ", "chanel name",
            importance: Importance.max, priority: Priority.high));

    await notification_.show(0, title, body, notificationDetails);
  }
}
