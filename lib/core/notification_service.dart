import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin plugin =
      FlutterLocalNotificationsPlugin();

  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future<void> initNotifications() async {
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings iosInit = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestSoundPermission: false,
      requestBadgePermission: false,
    );

    final InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await plugin.initialize(initSettings);
  }

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<bool> requestIosPermissions() async {
    final result = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
    return result ?? false;
  }

  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    final iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final notificationDetails = NotificationDetails(iOS: iosDetails);

    final tzTime = tz.TZDateTime.from(scheduledDate, tz.local);

    if (tzTime.isAfter(DateTime.now())) {
      await _notifications.zonedSchedule(
        id,
        title,
        body,
        tzTime,
        notificationDetails,

        androidScheduleMode:
            AndroidScheduleMode.exactAllowWhileIdle, // iOS'то таасир бербейт
        matchDateTimeComponents: DateTimeComponents.dateAndTime,
      );
    }
  }
}
