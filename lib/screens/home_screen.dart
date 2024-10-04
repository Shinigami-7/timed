import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timed/services/notification_logic.dart';
import 'package:timed/utils/app_colors.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  User? user;

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
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Homescreen()),
    );
  }

  String getCurrentDayAndDate() {
    DateTime now = DateTime.now();
    return '${DateFormat('EEEE').format(now)}, ${DateFormat('d MMM').format(now)}';
  }

  void scheduleNotificationsForIntakes(List<Map<String, dynamic>> intakes, String medicineName) {
    for (var intake in intakes) {
      Timestamp timestamp = intake['time'];
      DateTime time = timestamp.toDate();
      int dose = intake['dose'];

      // Schedule a notification for this intake time
      NotificationLogic.scheduleAlarm(
        id: time.hashCode,  // Use a unique ID for each notification
        title: 'Medication Reminder',
        body: 'Time to take $medicineName ($dose mg)',
        dateTime: time,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
          elevation: 0,
          title: Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    getCurrentDayAndDate(),
                    style: const TextStyle(
                      color: AppColors.blackColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              
            ],
          ),
        ),
        body: user == null
            ? const Center(child: Text("User not logged in"))
            : StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("user")
                    .doc(user!.uid)
                    .collection('medications')
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4FA8C5)),
                      ),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text("Nothing to show"),
                    );
                  }
                  final data = snapshot.data;
                  return ListView.builder(
                    itemCount: data?.docs.length,
                    itemBuilder: (context, index) {
                      final doc = data!.docs[index].data() as Map<String, dynamic>;

                      String medicineName = doc['medicineName'] ?? 'No medicine name';
                      int frequency = doc['frequency'] ?? 0;
                      List<Map<String, dynamic>> intakes = List<Map<String, dynamic>>.from(doc['intakes'] ?? []);

                      // Schedule notifications for each intake
                      scheduleNotificationsForIntakes(intakes, medicineName);

                      return Card(
                        margin: const EdgeInsets.all(8),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                medicineName,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Frequency: $frequency times daily',
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 8),
                              ...intakes.map((intake) {
                                Timestamp timestamp = intake['time'];
                                DateTime time = timestamp.toDate();
                                int dose = intake['dose'];
                                return Text(
                                  'Time: ${DateFormat.jm().format(time)}, Dose: $dose mg',
                                  style: const TextStyle(fontSize: 16),
                                );
                              }),
                            ],
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
