import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);

    await plugin.initialize(settings);
  }

  static Future<void> showSimpleReminder(String title, String body) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'smart_interest_reminders',
        'SmartInterestX Reminders',
        channelDescription: 'Due date and payment reminders',
        importance: Importance.high,
        priority: Priority.high,
      ),
    );

    await plugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
    );
  }
}
