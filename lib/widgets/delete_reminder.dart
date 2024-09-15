import 'dart:js_interop_unsafe';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

deleteReminder(BuildContext context, String id, String uid){
  return showDialog(context: context, builder: (content){
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      title: Text("Delete Reminder"),
      content: Text("Are you sure you want to delete"),
      actions: [
        TextButton(onPressed: (){
          try{
            FirebaseFirestore.instance.collection("user").doc(uid).collection("reminder").doc(id).delete();
            Fluttertoast.showToast(msg: "Reminder Delete");
          }catch(e){
            Fluttertoast.showToast(msg: e.toString());
          }
          Navigator.pop(context);
        }, child: Text("Delete"),
        ),
        TextButton(onPressed: (){
          Navigator.pop(context);
        }, child: Text("Cancel"),
        ),
      ],
    );
  },
  );
}