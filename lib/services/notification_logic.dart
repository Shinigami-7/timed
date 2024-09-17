import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timed/screens/home_screen.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationLogic{
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNoticications = BehaviorSubject<String?>();

  static Future _notificationsDetail() async{
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        "Shedule Reminder", "Don't Forget to Drink Water",
        importance: Importance.max,priority: Priority.max
      )
    );
  }

  static Future init(BuildContext context, String uid) async{
    tz.initializeTimeZones();
    final android = const AndroidInitializationSettings("clock");
    final settings =  InitializationSettings(android: android);
    await _notifications.initialize(settings,
    onDidReceiveNotificationResponse: (payload){
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Homescreen())
        );
      onNoticications.add(payload as String?);
    }
    );
  }

  static Future showNotifications({
    int id=0,
    String? title,
    String? body,
    String? payload,
    required DateTime dateTime,
  })async{
    if(dateTime.isBefore(DateTime.now())){
      dateTime = dateTime.add(const Duration(days: 1));
    }

    _notifications.zonedSchedule(id, title, body,
        tz.TZDateTime.from(dateTime, tz.local), await _notificationsDetail(),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
        matchDateTimeComponents: DateTimeComponents.time); 
  }
}