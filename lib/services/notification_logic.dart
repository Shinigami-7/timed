import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationLogic {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  // Request notification permissions
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

  // Initialize notifications
  static Future<void> _initializeNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    final settings = const InitializationSettings(android: android);

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (notificationResponse) async {
        final payload = notificationResponse.payload;

        if (notificationResponse.actionId == 'take_action') {
          print('Take button clicked!');
          if (payload != null) {
            print('Received payload: $payload');
            await _reduceDoseInFirestore(payload);
          }
        } else if (notificationResponse.actionId == 'skip_action') {
          print('Skip button clicked!');
        } else {
          print('Notification tapped');
        }
        onNotifications.add(payload);
      },
    );
  }

  // Reduce dose in Firestore
  static Future<void> _reduceDoseInFirestore(String payload) async {
    try {
      if (payload == null || payload.isEmpty) {
        print('Invalid payload received');
        return;
      }

      final data = payload.split('|');
      if (data.length != 3) {
        print('Payload format incorrect');
        return;
      }

      final uid = data[0];
      final medicationId = data[1];
      final intakeTime = data[2];

      final medicationRef = FirebaseFirestore.instance
          .collection('user')
          .doc(uid)
          .collection('medications')
          .doc(medicationId);

      final snapshot = await medicationRef.get();
      if (snapshot.exists) {
        final medicationData = snapshot.data()!;
        final intakes = List<Map<String, dynamic>>.from(medicationData['intakes']);

        for (var intake in intakes) {
          if (intake['time'] == intakeTime) {
            intake['dose'] = (intake['dose'] as int) - 1;
          }
        }

        await medicationRef.update({'intakes': intakes});
        print('Dose reduced successfully in Firestore.');
      } else {
        print('Medication not found in Firestore');
      }
    } catch (e) {
      print('Error reducing dose: $e');
    }
  }

  // Initialize NotificationLogic
  static Future<void> init(BuildContext context, String uid) async {
    tz.initializeTimeZones();
    await _initializeNotifications();
    await requestNotificationPermissions();
  }

  // Notification details with actions
  static Future<NotificationDetails> _notificationDetails() async {
    const androidDetails = AndroidNotificationDetails(
      "reminder_channel_id",
      "Reminder Channel",
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      enableVibration: true,
      timeoutAfter: 60000, // Stay visible for 60 seconds
      actions: [
        AndroidNotificationAction(
          'take_action',
          '✅ Take',
          showsUserInterface: true,
        ),
        AndroidNotificationAction(
          'skip_action',
          '❌ Skip',
          showsUserInterface: true,
        ),
      ],
    );

    return const NotificationDetails(android: androidDetails);
  }

  // Schedule alarms
  static Future<void> scheduleAlarm({
    required int id,
    required String title,
    required String body,
    required DateTime dateTime,
    required String uid,
    required String medicationId,
  }) async {
    final payload = '$uid|$medicationId|${dateTime.toIso8601String()}';

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(dateTime, tz.local),
      await _notificationDetails(),
      payload: payload,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  // Cancel alarms
  static Future<void> cancelAlarm(int id) async {
    await _notifications.cancel(id);
  }

  // Check if an alarm is scheduled
  static Future<bool> isAlarmScheduled(int id) async {
    final pendingNotifications = await _notifications.pendingNotificationRequests();
    return pendingNotifications.any((notification) => notification.id == id);
  }
}
