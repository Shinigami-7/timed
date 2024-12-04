import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timed/screens/addMedicine/add_prescription.dart';

class AddMed3_1 extends StatefulWidget {
  final String medication;
  final int frequency;

  const AddMed3_1({super.key, required this.medication, required this.frequency});

  @override
  State<AddMed3_1> createState() => _AddMed3State();
}

class _AddMed3State extends State<AddMed3_1> {
  late List<TimeOfDay?> timeList;
  late int dose;

  @override
  void initState() {
    super.initState();
    timeList = List<TimeOfDay?>.filled(widget.frequency, null);
    dose = 0; // Initial dose set to 0
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
      if (dose <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter a valid dose")),
        );
        return;
      }

      final medicationData = {
        'medicineName': widget.medication,
        'frequency': widget.frequency,
        'dose': dose, // Save the dose as a single field
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
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UploadPrescriptionScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save medication: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicine Add Page'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: Image.asset(
                      'assets/images/medicine.png',
                      height: media.height * 0.2,
                      width: media.width * 0.4,
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        const Text("Quantity"),
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
                                dose = int.tryParse(value) ?? 0;
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
            ],
          ),
        ],
      ),
    );
  }
}
