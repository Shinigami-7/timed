import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:timed/model/appointment_model.dart';
import 'package:timed/utils/app_colors.dart';

addAppointment(BuildContext context, String uid) {
  final TextEditingController hospitalController = TextEditingController();
  final TextEditingController appointmentController = TextEditingController();
  final TextEditingController dayController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  // Function to get the day of the week from a date
  String getDayOfWeek(DateTime date) {
    return DateFormat('EEEE').format(date); // 'EEEE' gives the full name of the day
  }

  add(String uid, String hospitalName, String appointmentName, String day, DateTime date) {
    try {
      // Convert the selected date to a Timestamp
      Timestamp timestamp = Timestamp.fromDate(date);

      AppointmentModel appointmentModel = AppointmentModel(
        hospitalName: hospitalName,
        appointmentName: appointmentName,
        day: day,
        appointmentDate: timestamp,
      );

      // Store the appointment data in Firestore
      FirebaseFirestore.instance
          .collection('user')
          .doc(uid)
          .collection('appointments')
          .doc()
          .set(appointmentModel.toMap());

      Fluttertoast.showToast(msg: 'Appointment Added');
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  return showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (BuildContext context, Function(void Function()) setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            title: const Text("Add Appointment"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  // Hospital Name Input
                  TextField(
                    controller: hospitalController,
                    decoration: const InputDecoration(
                      labelText: 'Hospital Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),
                  
                  // Appointment Name Input
                  TextField(
                    controller: appointmentController,
                    decoration: const InputDecoration(
                      labelText: 'Appointment Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),
                   MaterialButton(
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          selectedDate = pickedDate;
                          // Update the day controller with the selected day
                          dayController.text = getDayOfWeek(selectedDate);
                        });
                      }
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, color: AppColors.primaryColor1),
                        const SizedBox(width: 10),
                        Text(
                          DateFormat('yMMMd').format(selectedDate),
                          style: const TextStyle(
                            fontSize: 18,
                            color: AppColors.primaryColor1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                   const SizedBox(height: 15),

                  // Day Input (automatically filled)
                  TextField(
                    controller: dayController,
                    decoration: const InputDecoration(
                      labelText: 'Day',
                      border: OutlineInputBorder(),
                    ),
                    enabled: false, // Make it read-only
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
                  if (hospitalController.text.isEmpty ||
                      appointmentController.text.isEmpty ||
                      dayController.text.isEmpty) {
                    Fluttertoast.showToast(msg: 'Please fill all the fields');
                    return;
                  }

                  // Add the appointment details to Firestore
                  add(
                    uid,
                    hospitalController.text,
                    appointmentController.text,
                    dayController.text,
                    selectedDate,
                  );
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
