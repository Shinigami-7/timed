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

  Future<void> scheduleAlarmForReminder(DateTime dateTime, int id) async {
    await NotificationLogic.scheduleAlarm(
      id: id,
      title: "Reminder Title",
      body: "Don't forget to take your medicine",
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

                      // Extract medicine details
                      String medicineName = doc['medicineName'] ?? 'No medicine name';
                      int frequency = doc['frequency'] ?? 0;

                      // Extract times and doses
                      List<String> formattedTimes = [];
                      List<int> doses = [];
                      for (int i = 1; i <= 10; i++) {
                        String timeKey = 'time$i';
                        String doseKey = 'dose$i';
                        if (doc.containsKey(timeKey) && doc.containsKey(doseKey)) {
                          Timestamp timestamp = doc[timeKey];
                          DateTime date = DateTime.fromMicrosecondsSinceEpoch(timestamp.microsecondsSinceEpoch);
                          formattedTimes.add(DateFormat.jm().format(date));
                          doses.add(doc[doseKey] ?? 0);
                        }
                      }

                      // Display frequency in a readable format
                      String frequencyText;
                      switch (frequency) {
                        case 1:
                          frequencyText = "Once daily";
                          break;
                        case 2:
                          frequencyText = "Twice daily";
                          break;
                        case 3:
                          frequencyText = "Three times daily";
                          break;
                        default:
                          frequencyText = "Other";
                      }

                      // Schedule alarms
                      if (formattedTimes.isNotEmpty) {
                        for (int i = 0; i < formattedTimes.length; i++) {
                          scheduleAlarmForReminder(
                            DateTime.fromMicrosecondsSinceEpoch(doc['time${i + 1}'].microsecondsSinceEpoch),
                            index * 10 + i,
                          );
                        }
                      }

                      return Padding(
                        padding: const EdgeInsets.all(8),
                        child: Card(
                          child: ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$medicineName',
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Frequency: $frequencyText',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 5),
                                // Display times in a row
                                if (formattedTimes.isNotEmpty)
                                  Row(
                                    children: formattedTimes.map((time) {
                                      return Padding(
                                        padding: const EdgeInsets.only(right: 8.0),
                                        child: Text(
                                          time,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                const SizedBox(height: 5),
                                // Display doses in a row
                                if (doses.isNotEmpty)
                                  Row(
                                    children: doses.map((dose) {
                                      return Padding(
                                        padding: const EdgeInsets.only(right: 8.0),
                                        child: Text(
                                          '$dose pill(s)',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                              ],
                            ),
                            subtitle: const Text("Reminder"),
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
