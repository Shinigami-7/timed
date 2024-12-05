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
  Map<String, int> skipCounts = {}; // To track skip counts for each card
  Map<String, Color> cardColors = {}; // To track colors for each card

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
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Homescreen()),
    );
  }

  String getCurrentDayAndDate() {
    DateTime now = DateTime.now();
    return '${DateFormat('EEEE').format(now)}, ${DateFormat('d MMM').format(now)}';
  }

  void scheduleNotificationsForIntakes(List<Map<String, dynamic>> intakes,
      String medicineName, String medicationId, int dose) {
    for (var intake in intakes) {
      Timestamp timestamp = intake['time'];
      DateTime time = timestamp.toDate();

      NotificationLogic.scheduleAlarm(
        
        id: time.hashCode,
        title: 'Medication Reminder',
        body: 'Time to take $medicineName ($dose mg)', // Use dose from docData
        dateTime: time,
        
      );
    }
  }

  Future<void> handleTakeButton(String docId, int dose) async {
    try {
      if (dose > 0) {
        final updatedDose = dose - 1;

        await FirebaseFirestore.instance
            .collection("user")
            .doc(user!.uid)
            .collection("medications")
            .doc(docId)
            .update({
          "dose": updatedDose, // Update dose directly in the document
        });

        setState(() {
          cardColors[docId] = const Color.fromARGB(255, 202, 250, 147);
          skipCounts[docId] = 0; // Reset skip count
        });

        print("Dose reduced by 1");

        if (updatedDose == 0) {
          print("The dose for this medication has been fully consumed.");
        }
      } else {
        print("Dose is already 0, cannot reduce further.");
      }
    } catch (e) {
      print("Error reducing dose: $e");
    }
  }

  void handleSkipButton(String docId) {
    setState(() {
      cardColors[docId] =
          const Color.fromARGB(255, 246, 150, 143); // Change card color to red
      skipCounts[docId] = (skipCounts[docId] ?? 0) + 1; // Increment skip count
    });
  }

  Future<void> handleAddQuantityButton(String docId, int dose) async {
    try {
      final quantity = int.tryParse(quantityController.text) ?? 0;
      if (quantity > 0) {
        // Update dose in the document directly
        final updatedDose = dose + quantity;

        await FirebaseFirestore.instance
            .collection("user")
            .doc(user!.uid)
            .collection("medications")
            .doc(docId)
            .update({
          "dose": updatedDose, // Update dose directly in the document
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

  Future<void> deleteCard(String cardId) async {
    try {
      await FirebaseFirestore.instance
          .collection('user')
          .doc(user!.uid) // Use the current user's UID
          .collection('medications') // Access the medications subcollection
          .doc(cardId) // Target the specific medication document
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Card deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
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
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
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
                      String medicineName =
                          docData['medicineName'] ?? 'No medicine name';
                      int frequency = docData['frequency'] ?? 0;
                      int dose = docData['dose'] ?? 0;
                      List<Map<String, dynamic>> intakes =
                          List<Map<String, dynamic>>.from(
                              docData['intakes'] ?? []);

                      scheduleNotificationsForIntakes(
                          intakes, medicineName, doc.id, dose);

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            tappedContainerId =
                                doc.id == tappedContainerId ? null : doc.id;
                          });
                        },
                        onLongPress: () {
                          // Show a dialog to confirm deletion
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Delete Card'),
                                content: const Text(
                                    'Are you sure you want to delete this card?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      deleteCard(
                                          doc.id); // Call your delete function
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                    },
                                    child: const Text('Delete'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Card(
                          color: cardColors[doc.id] ?? Colors.white,
                          margin: const EdgeInsets.all(8),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  medicineName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        CircularProgressIndicator(
                                          value: dose >= 20 ? 1.0 : dose / 20.0,
                                          backgroundColor: Colors.grey[200],
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            dose >= 12
                                                ? Colors.green
                                                : dose <= 11 && dose >= 6
                                                    ? Colors.orange
                                                    : Colors.red,
                                          ),
                                        ),
                                        Text("$dose"),
                                      ],
                                    ),
                                    const SizedBox(width: 6),
                                    Text("Frequency: $frequency / day"),
                                    Spacer(),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        for (var intake in intakes)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom:
                                                    8.0), // Add some spacing between each text
                                            child: Text(
                                              DateFormat.jm().format(
                                                  (intake['time'] as Timestamp)
                                                      .toDate()),
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                if (tappedContainerId == doc.id)
                                  Row(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () =>
                                            handleTakeButton(doc.id, dose),
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
                                          padding:
                                              const EdgeInsets.only(left: 8),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 100,
                                                child: TextField(
                                                  controller:
                                                      quantityController,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration:
                                                      const InputDecoration(
                                                    hintText: "Quantity",
                                                  ),
                                                ),
                                              ),
                                              ElevatedButton(
                                                onPressed: () =>
                                                    handleAddQuantityButton(
                                                        doc.id, dose),
                                                child: const Text("Add"),
                                              ),
                                            ],
                                          ),
                                        ),
                                      const Spacer(),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Skip Count: ${skipCounts[doc.id] ?? 0}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () =>
                                                handleSkipButton(doc.id),
                                            child: const Text("Skip"),
                                          ),
                                          const SizedBox(height: 5),
                                        ],
                                      ),
                                    ],
                                  ),
                              ],
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