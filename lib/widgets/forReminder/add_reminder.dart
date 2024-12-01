import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:timed/model/reminder_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:timed/utils/app_colors.dart';

addReminder(BuildContext context, String uid) {
  TimeOfDay time = TimeOfDay.now();
  String medicineName = ""; 

  add(String uid, TimeOfDay time, String medicineName) {
    try {
      DateTime d = DateTime.now();
      DateTime dateTime = DateTime(d.year, d.month, d.day, time.hour, time.minute);
      Timestamp timestamp = Timestamp.fromDate(dateTime);

      ReminderModel reminderModel = ReminderModel(
        timeStamp: timestamp,
        onOff: false,
        medicineName: medicineName,
      );

      FirebaseFirestore.instance
          .collection('user')
          .doc(uid)
          .collection('reminder')
          .doc()
          .set(reminderModel.toMap());

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Reminder Set'),
            content: Text('Your alarm for $medicineName will ring at ${time.format(context)}.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  return showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (BuildContext context, void Function(void Function()) setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            title: const Text("Add Reminder"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  const Text("Select a Time for Reminder"),
                  const SizedBox(height: 20),
                  MaterialButton(
                    onPressed: () async {
                      TimeOfDay? newTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (newTime == null) return;
                      setState(() {
                        time = newTime;
                      });
                    },
                    child: Row(
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.clock,
                          color: AppColors.primaryColor1,
                          size: 40,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          time.format(context),
                          style: const TextStyle(
                            color: AppColors.primaryColor1,
                            fontSize: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextField(
                    onChanged: (value) {
                      medicineName = value;
                    },
                    decoration: const InputDecoration(
                      labelText: "Medicine Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  add(uid, time, medicineName);
                  Navigator.pop(context);
                },
                child: const Text('ADD'),
              ),
            ],
          );
        },
      );
    },
  );
}