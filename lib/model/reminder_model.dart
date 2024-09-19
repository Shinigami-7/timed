import 'package:cloud_firestore/cloud_firestore.dart';

class ReminderModel {
  Timestamp? timeStamp;
  bool? onOff;
  String? medicineName; // Add medicine name field

  ReminderModel({this.timeStamp, this.onOff, this.medicineName});

  // Convert ReminderModel to Map
  Map<String, dynamic> toMap() {
    return {
      'time': timeStamp,
      'onOff': onOff,
      'medicineName': medicineName, // Include medicine name in map
    };
  }

  // Create ReminderModel from Map
  factory ReminderModel.fromMap(Map<String, dynamic> map) {
    return ReminderModel(
      timeStamp: map['time'] as Timestamp?,
      onOff: map['onOff'] as bool?,
      medicineName: map['medicineName'] as String?, // Read medicine name from map
    );
  }
}
