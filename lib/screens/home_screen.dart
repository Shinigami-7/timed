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
  String? tappedContainerId;
  TextEditingController quantityController = TextEditingController();
  String? selectedDocId;
  bool isAddButtonVisible = true;

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
      if (payload != null) {
        print("Notification payload: $payload");
        onClickedNotifications(payload);
      } else {
        print("No payload received from notification.");
      }
    });
  }

  void onClickedNotifications(String? payload) {
    // Navigate or handle the notification click
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Homescreen()),
    );
  }

  String getCurrentDayAndDate() {
    DateTime now = DateTime.now();
    return '${DateFormat('EEEE').format(now)}, ${DateFormat('d MMM').format(now)}';
  }

  void scheduleNotificationsForIntakes(
      List<Map<String, dynamic>> intakes, String medicineName, String medicationId) {
    for (var intake in intakes) {
      Timestamp timestamp = intake['time'];
      DateTime time = timestamp.toDate();
      int dose = intake['dose'];

      NotificationLogic.scheduleAlarm(
        uid: user!.uid,
        id: time.hashCode,
        title: 'Medication Reminder',
        body: 'Time to take $medicineName ($dose mg)',
        dateTime: time,
        medicationId: medicationId,
      );
    }
  }

  Future<void> handleTakeButton(String docId, Map<String, dynamic> intake) async {
    try {
      final int currentDose = intake['dose'] ?? 0;
      if (currentDose > 0) {
        final updatedDose = currentDose - 1;

        await FirebaseFirestore.instance
            .collection("user")
            .doc(user!.uid)
            .collection("medications")
            .doc(docId)
            .update({
          "intakes": FieldValue.arrayRemove([intake]),
        });

        final updatedIntake = {...intake, "dose": updatedDose};
        await FirebaseFirestore.instance
            .collection("user")
            .doc(user!.uid)
            .collection("medications")
            .doc(docId)
            .update({
          "intakes": FieldValue.arrayUnion([updatedIntake]),
        });

        print("Dose reduced by 1");
        setState(() {});
      } else {
        print("Dose is already 0, cannot reduce further.");
      }
    } catch (e) {
      print("Error reducing dose: $e");
    }
  }

  Future<void> handleAddQuantityButton(String docId, Map<String, dynamic> intake) async {
    try {
      final quantity = int.tryParse(quantityController.text) ?? 0;
      if (quantity > 0) {
        final currentDose = intake['dose'] ?? 0;
        final updatedDose = currentDose + quantity;

        await FirebaseFirestore.instance
            .collection("user")
            .doc(user!.uid)
            .collection("medications")
            .doc(docId)
            .update({
          "intakes": FieldValue.arrayRemove([intake]),
        });

        final updatedIntake = {...intake, "dose": updatedDose};
        await FirebaseFirestore.instance
            .collection("user")
            .doc(user!.uid)
            .collection("medications")
            .doc(docId)
            .update({
          "intakes": FieldValue.arrayUnion([updatedIntake]),
        });

        setState(() {
          quantityController.clear();
          isAddButtonVisible = true;
        });

        print("Dose increased by $quantity");
      } else {
        print("Invalid quantity entered.");
      }
    } catch (e) {
      print("Error adding quantity: $e");
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
                child: CircularProgressIndicator(),
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
                final doc = data!.docs[index];
                final docData = doc.data() as Map<String, dynamic>;
                String medicineName = docData['medicineName'] ?? 'No medicine name';
                int frequency = docData['frequency'] ?? 0;
                List<Map<String, dynamic>> intakes =
                List<Map<String, dynamic>>.from(docData['intakes'] ?? []);

                scheduleNotificationsForIntakes(intakes, medicineName, doc.id);

                return Card(
                  margin: const EdgeInsets.all(8),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              tappedContainerId =
                              doc.id == tappedContainerId ? null : doc.id;
                            });
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                medicineName,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              ...intakes.map((intake) {
                                Timestamp timestamp = intake['time'];
                                DateTime time = timestamp.toDate();
                                int dose = intake['dose'];

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Stack(
                                              alignment: Alignment.center, // Center the text within the circle
                                              children: [
                                                CircularProgressIndicator(
                                                  value: dose >= 20 ? 1.0 : dose / 20.0,
                                                  backgroundColor: Colors.grey[200],
                                                  valueColor: AlwaysStoppedAnimation<Color>(
                                                    dose >= 12
                                                        ? Colors.green
                                                        : dose <= 11 && dose >= 6
                                                        ? Colors.orange
                                                        : Colors.red,
                                                  ),
                                                  strokeWidth: 5,
                                                ),
                                                Text(
                                                  '$dose', // Display the dose value
                                                  style: const TextStyle(
                                                    fontSize: 14, // Adjust font size as needed
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black, // Text color
                                                  ),
                                                ),

                                              ],
                                            ),
                                            SizedBox(width: 10,),
                                            Text(
                                              'Frequency: $frequency times daily',
                                              style: const TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),

                                        Text(
                                          DateFormat.jm().format(time),
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    if (tappedContainerId == doc.id)
                                      Row(
                                        children: [
                                          ElevatedButton(
                                            onPressed: () => handleTakeButton(
                                                doc.id, intake),
                                            child: const Text("Take"),
                                          ),
                                          const SizedBox(width: 8),
                                          if (isAddButtonVisible)
                                            ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  selectedDocId = doc.id;
                                                  isAddButtonVisible = false;
                                                });
                                              },
                                              child: const Text("Add"),
                                            ),
                                          if (!isAddButtonVisible)
                                            Padding(
                                              padding: const EdgeInsets.only(left: 8),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 100,
                                                    child: TextField(
                                                      controller: quantityController,
                                                      keyboardType: TextInputType.number,
                                                      decoration: const InputDecoration(
                                                        hintText: "Quantity",
                                                      ),
                                                    ),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () =>
                                                        handleAddQuantityButton(
                                                            doc.id, intake),
                                                    child: const Text("Add"),
                                                  ),
                                                ],
                                              ),
                                            ),
                                        ],
                                      ),
                                    const SizedBox(height: 8),
                                  ],
                                );
                              }).toList(),
                            ],
                          ),
                        ),
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
