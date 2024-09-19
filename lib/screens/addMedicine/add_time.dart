import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timed/screens/home_screen.dart';

class AddMed3_1 extends StatefulWidget {
  final int time;
  final String UserInput;

  const AddMed3_1({required this.time, required this.UserInput});

  @override
  State<AddMed3_1> createState() => _AddMed3State();
}

class _AddMed3State extends State<AddMed3_1> {
  late List<TimeOfDay?> timeList;
  late List<int> doseList;

  @override
  void initState() {
    super.initState();
    timeList = List<TimeOfDay?>.filled(widget.time, null);
    doseList = List<int>.filled(widget.time, 0);
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

  Future<void> _saveMedications() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User not logged in")),
      );
      return;
    }

    final uid = user.uid;
    final medicationCollection = FirebaseFirestore.instance
        .collection('user')
        .doc(uid)
        .collection('medications')
        .doc(widget.UserInput);

    try {
      // Prepare data to save
      final Map<String, dynamic> data = {};
      for (int i = 0; i < widget.time; i++) {
        if (timeList[i] != null && doseList[i] > 0) {
          data['time${i + 1}'] = Timestamp.fromDate(DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
            timeList[i]!.hour,
            timeList[i]!.minute,
          ));
          data['dose${i + 1}'] = doseList[i];
        }
      }

      await medicationCollection.set(data, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Medication times and doses saved successfully")),
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
        title: Text('Medicine Add Page 3'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
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
                  await _saveMedications();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Homescreen(),
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
