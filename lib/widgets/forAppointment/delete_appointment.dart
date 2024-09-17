import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

deleteAppointment(BuildContext context, String id, String uid) {
  return showDialog(
    context: context,
    builder: (content) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        title: const Text("Delete Appointment"),
        content: const Text("Are you sure you want to delete this appointment?"),
        actions: [
          TextButton(
            onPressed: () {
              try {
                FirebaseFirestore.instance
                    .collection("user")
                    .doc(uid)
                    .collection("appointments")
                    .doc(id)
                    .delete();
                Fluttertoast.showToast(msg: "Appointment Deleted");
              } catch (e) {
                Fluttertoast.showToast(msg: e.toString());
              }
              Navigator.pop(context);
            },
            child: const Text("Delete"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
        ],
      );
    },
  );
}
