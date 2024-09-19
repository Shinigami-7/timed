import 'package:cloud_firestore/cloud_firestore.dart';

class ReportModel {
  final Timestamp timeStamp;
  final int bloodPressure;
  final int sugarLevel;

  ReportModel({
    required this.timeStamp,
    required this.bloodPressure,
    required this.sugarLevel,
  });

  Map<String, dynamic> toMap() {
    return {
      'timeStamp': timeStamp,
      'bloodPressure': bloodPressure,
      'sugarLevel': sugarLevel,
    };
  }

  factory ReportModel.fromMap(Map<String, dynamic> map) {
    return ReportModel(
      timeStamp: map['timeStamp'],
      bloodPressure: map['bloodPressure'],
      sugarLevel: map['sugarLevel'],
    );
  }
}
