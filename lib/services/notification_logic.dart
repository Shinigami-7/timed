import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationLogic{
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNoticications = BehaviorSubject<String?>();

  static Future _notificationsDetail() async{
    return NotificationDetails(
      android: AndroidNotificationDetails(
        "Shedule Reminder", "Don't Forget to Drink Water",
        importance: Importance.max,priority: Priority.max
      )
    );
  }
}