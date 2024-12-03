import 'package:cloud_firestore/cloud_firestore.dart';

class ReminderModel {
  Timestamp? timeStamp;
  bool? onOff;
  String? medicineName;
  int? dose; // Added field to track the dose

  ReminderModel({this.timeStamp, this.onOff, this.medicineName, this.dose});

  // Convert ReminderModel to Map
  Map<String, dynamic> toMap() {
    return {
      'time': timeStamp,
      'onOff': onOff,
      'medicineName': medicineName,
      'dose': dose, // Include dose in map
    };
  }

  // Create ReminderModel from Map
  factory ReminderModel.fromMap(Map<String, dynamic> map) {
    return ReminderModel(
      timeStamp: map['time'] as Timestamp?,
      onOff: map['onOff'] as bool?,
      medicineName: map['medicineName'] as String?,
      dose: map['dose'] as int?, // Read dose from map
    );
  }
}
