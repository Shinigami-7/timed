import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timed/screens/home_screen.dart';
import 'package:timed/widgets/navigation_bar.dart';

class AddMed3_1_Custom extends StatefulWidget {
  final int time;

  const AddMed3_1_Custom({required this.time});

  @override
  State<AddMed3_1_Custom> createState() => _AddMed3State_Custom();
}

class _AddMed3State_Custom extends State<AddMed3_1_Custom> {
  late List<TimeOfDay?> timeList;
  late List<int> doseList;

  @override
  void initState() {
    super.initState();
    timeList = List<TimeOfDay?>.filled(widget.time, null); // Initialize list with null values
    doseList = List<int>.filled(widget.time, 0); // Initialize doses with default values
  }

  void _showTimePicker(int index) {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((value) {
      if (value != null) {
        setState(() {
          timeList[index] = value;
        });
      }
    });
  }

  Future<void> _saveIntakeData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User not logged in")),
      );
      return;
    }

    final uid = user.uid;
    final CollectionReference intakeCollection = FirebaseFirestore.instance
        .collection('user')
        .doc(uid)
        .collection('intake');

    try {
      for (int i = 0; i < widget.time; i++) {
        if (timeList[i] != null && doseList[i] > 0) {
          await intakeCollection.add({
            'time': Timestamp.fromDate(DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
              timeList[i]!.hour,
              timeList[i]!.minute,
            )),
            'dose': doseList[i],
          });
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Intake times and doses saved successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save data: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medicine Add Page 3 Custom'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(
                      'assets/images/medicine.png',
                      height: 250,
                      width: 250,
                    ),
                  ),
                  Text(
                    "Set the reminder times for your \nmedication",
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  for (int i = 0; i < widget.time; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Intake ${i + 1}",
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                          Row(
                            children: [
                              Icon(Icons.access_time_outlined),
                              MaterialButton(
                                onPressed: () => _showTimePicker(i),
                                child: Text(
                                  timeList[i] != null ? timeList[i]!.format(context) : 'Select Time',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(right: 25),
                                child: Row(
                                  children: [
                                    Text("Dose"),
                                    SizedBox(width: 8),
                                    Container(
                                      width: 50,
                                      child: TextField(
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          border: UnderlineInputBorder(),
                                          hintText: "1",
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            doseList[i] = int.tryParse(value) ?? 0;
                                          });
                                        },
                                      ),
                                    ),
                                    Text("pill(s)"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await _saveIntakeData();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainNavigationBar(),
                      settings: RouteSettings(arguments: 0),
                    ),
                  );
                },
                child: Text("Done"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
