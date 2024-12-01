import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

class NotificationLogic {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  // Method to request notification permissions
  static Future<void> requestNotificationPermissions() async {
    var status = await Permission.notification.status;
    if (status != PermissionStatus.granted) {
      final result = await Permission.notification.request();
      if (result != PermissionStatus.granted) {
        print("Notification Permission Denied");
      } else {
        print("Notification Permission Granted");
      }
    } else {
      print("Notification Permission Already Granted");
    }
  }

  // Initialization settings for the notifications
  static Future<void> _initializeNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    final settings = const InitializationSettings(android: android);

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (notificationResponse) {
        // Handle notification tap or action click here
        if (notificationResponse.actionId == 'take_action') {
          print('Take button clicked!');
          // Logic for "Take" action
        } else if (notificationResponse.actionId == 'skip_action') {
          print('Skip button clicked!');
          // Logic for "Skip" action
        } else {
          print('Notification tapped');
        }
        onNotifications.add(notificationResponse.payload);
      },
    );
  }

  // Initialization of the notification logic
  static Future<void> init(BuildContext context, String uid) async {
    tz.initializeTimeZones();
    await _initializeNotifications();
    await requestNotificationPermissions();
  }

  // Method to configure notification details with actions
  static Future<NotificationDetails> _notificationDetails() async {
    const androidDetails = AndroidNotificationDetails(
      "reminder_channel_id",
      "Reminder Channel",
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      enableVibration: true,
      actions: [
        AndroidNotificationAction(
          'take_action',
          '✅ Take', // Text label with a checkmark (use an emoji for an icon-like appearance)
        ),
        AndroidNotificationAction(
          'skip_action',
          '❌ Skip', // Text label with a cross mark (use an emoji for an icon-like appearance)
        ),
      ],
    );

    return const NotificationDetails(android: androidDetails);
  }

  // Method to schedule alarms
  static Future<void> scheduleAlarm({
    required int id,
    required String title,
    required String body,
    required DateTime dateTime,
  }) async {
    if (dateTime.isBefore(DateTime.now())) {
      dateTime = dateTime.add(const Duration(days: 1));
    }

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(dateTime, tz.local),
      await _notificationDetails(),
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  // Method to cancel a scheduled alarm
  static Future<void> cancelAlarm(int id) async {
    await _notifications.cancel(id);
  }

  // Method to check if an alarm is scheduled
  static Future<bool> isAlarmScheduled(int id) async {
    final pendingNotifications = await _notifications.pendingNotificationRequests();
    return pendingNotifications.any((notification) => notification.id == id);
  }
}
