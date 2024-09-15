class ReminderModel {
  Timestamp? timeStamp;
  bool? onOff;

  ReminderModel({this.timeStamp, this.onOff});

  // Convert ReminderModel to Map
  Map<String, dynamic> toMap() {
    return {
      'time': timeStamp,
      'onOff': onOff, // Make sure the key name matches
    };
  }

  // Create ReminderModel from Map
  factory ReminderModel.fromMap(Map<String, dynamic> map) {
    return ReminderModel(
      timeStamp: map['time'] as Timestamp?,
      onOff: map['onOff'] as bool?,
    );
  }
}
