import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timed/model/reminder_model.dart';

class Switcher extends StatefulWidget {
  bool onOff;
  String uid;
  Timestamp timestamp;
  String id;
  
  Switcher(this.onOff,this.uid,this.id,this.timestamp, {super.key});

  @override
  State<Switcher> createState() => _SwitcherState();
}

class _SwitcherState extends State<Switcher> {
  @override
  Widget build(BuildContext context) {
    return Switch(
      value: widget.onOff, 
    onChanged: (bool value){
      ReminderModel reminderModel = ReminderModel();
      reminderModel.onOff = value;
      reminderModel.timeStamp = widget.timestamp;
          FirebaseFirestore.instance
              .collection("user")
              .doc(widget.uid)
              .collection('reminder')
              .doc(widget.id)
              .update(reminderModel.toMap());
    },
    );
  }
}