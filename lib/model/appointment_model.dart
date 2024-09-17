// lib/model/appointment_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentModel {
  String? hospitalName;
  String? appointmentName;
  String? day;
  Timestamp? appointmentDate;

  AppointmentModel({
    this.hospitalName,
    this.appointmentName,
    this.day,
    this.appointmentDate,
  });

  // Convert appointment details to map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'hospitalName': hospitalName,
      'appointmentName': appointmentName,
      'day': day,
      'appointmentDate': appointmentDate,
    };
  }
}
