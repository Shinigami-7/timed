import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timed/screens/add_prescription.dart';

class AddMed3_1_Custom extends StatefulWidget {
  final String medication;
  final int frequency;

  const AddMed3_1_Custom({super.key, required this.medication, required this.frequency});

  @override
  State<AddMed3_1_Custom> createState() => _AddMed3State_Custom();
}

class _AddMed3State_Custom extends State<AddMed3_1_Custom> {
  late List<TimeOfDay?> timeList;
  late List<int> doseList;

  @override
  void initState() {
    super.initState();
    timeList = List<TimeOfDay?>.filled(widget.frequency, null);
    doseList = List<int>.filled(widget.frequency, 0);
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

  Future<void> _saveMedication() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not logged in")),
      );
      return;
    }

    final uid = user.uid;
    try {
      final medicationData = {
        'medicineName': widget.medication,
        'frequency': widget.frequency,
        'createdAt': Timestamp.now(),
        'intakes': List.generate(widget.frequency, (index) => {
          'time': timeList[index] != null
              ? Timestamp.fromDate(DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                  timeList[index]!.hour,
                  timeList[index]!.minute,
                ))
              : null,
          'dose': doseList[index],
        }),
      };

      await FirebaseFirestore.instance
          .collection('user')
          .doc(uid)
          .collection('medications')
          .add(medicationData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Medication saved successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save medication: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicine Add Page 3 Custom'),
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
                  const Text(
                    "Set the reminder times for your \nmedication",
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  for (int i = 0; i < widget.frequency; i++)
                    _buildIntakeRow(i),
                  const SizedBox(height: 20),
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
                  await _saveMedication();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UploadPrescriptionScreen()),
                  );
                },
                child: const Text("Next"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntakeRow(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Intake ${index + 1}",
            style: const TextStyle(fontSize: 18, color: Colors.grey),
          ),
          Row(
            children: [
              const Icon(Icons.access_time_outlined),
              MaterialButton(
                onPressed: () => _showTimePicker(index),
                child: Text(
                  timeList[index] != null ? timeList[index]!.format(context) : 'Select Time',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 25),
                child: Row(
                  children: [
                    const Text("Dose"),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 50,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          hintText: "1",
                        ),
                        onChanged: (value) {
                          setState(() {
                            doseList[index] = int.tryParse(value) ?? 0;
                          });
                        },
                      ),
                    ),
                    const Text("pill(s)"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}