import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:timed/services/notification_logic.dart';
import 'package:timed/utils/app_colors.dart';
import 'package:timed/widgets/forReminder/add_reminder.dart';
import 'package:timed/widgets/forReminder/delete_reminder.dart';
import 'package:timed/widgets/switcher.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  User? user;
  bool on = true;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      NotificationLogic.init(context, user!.uid);
      listenNotification();
    }
  }

  void listenNotification() {
    NotificationLogic.onNotifications.listen((payload) {
      onClickedNotifications(payload);
    });
  }

  void onClickedNotifications(String? payload) {
    // Handle the notification tap, e.g., navigate to a specific screen or show a dialog
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Homescreen()),
    );
  }

  Future<void> scheduleAlarmForReminder(DateTime dateTime, int id) async {
    // Schedule an alarm with the given dateTime and id
    await NotificationLogic.scheduleAlarm(
      id: id,
      title: "Reminder Title",
      body: "Don't forget to drink water",
      dateTime: dateTime,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          leading: Container(),
          backgroundColor: AppColors.whiteColor,
          centerTitle: true,
          elevation: 0,
          title: const Text(
            "Reminder",
            style: TextStyle(
              color: AppColors.blackColor,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: user == null
            ? const Center(child: Text("User not logged in"))
            : StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("user")
                    .doc(user!.uid)
                    .collection('reminder')
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4FA8C5)),
                      ),
                    );
                  }
                  if (snapshot.data?.docs.isEmpty ?? true) {
                    return const Center(
                      child: Text("Nothing to show"),
                    );
                  }
                  final data = snapshot.data;
                  return ListView.builder(
                    itemCount: data?.docs.length,
                    itemBuilder: (context, index) {
                      Timestamp t = data?.docs[index].get('time');
                      DateTime date = DateTime.fromMicrosecondsSinceEpoch(t.microsecondsSinceEpoch);
                      String formattedTime = DateFormat.jm().format(date);
                      on = data!.docs[index].get('onOff');
                      if (on) {
                        // Schedule the alarm for the reminder
                        scheduleAlarmForReminder(date, index);
                      } else {
                        // Optionally cancel the alarm if it's turned off
                        NotificationLogic.cancelAlarm(index);
                      }
                      return Padding(
                        padding: const EdgeInsets.all(8),
                        child: Card(
                          child: ListTile(
                            title: Text(
                              formattedTime,
                              style: const TextStyle(fontSize: 30),
                            ),
                            subtitle: const Text("Everyday"),
                            trailing: SizedBox(
                              width: 110,
                              child: Row(
                                children: [
                                  Switcher(
                                    on,
                                    user!.uid,
                                    data.docs[index].id,
                                    data.docs[index].get('time'),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      deleteReminder(context, data.docs[index].id, user!.uid);
                                    },
                                    icon: const FaIcon(FontAwesomeIcons.circleXmark),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}
