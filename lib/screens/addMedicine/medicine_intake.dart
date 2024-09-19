import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timed/screens/addMedicine/add_time.dart';
import 'package:timed/screens/addMedicine/custom_add_time.dart';

class AddMed2 extends StatefulWidget {
  final String userInput;

  AddMed2({Key? key, required this.userInput}) : super(key: key);

  @override
  State<AddMed2> createState() => _AddMed2State();
}

class _AddMed2State extends State<AddMed2> {
  int? _value = 0;

  Future<void> _saveFrequency(int frequency) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User not logged in")),
      );
      return;
    }

    final uid = user.uid;
    try {
      await FirebaseFirestore.instance
          .collection('users') // Ensure this matches your Firestore collection path
          .doc(uid)
          .collection('medications')
          .doc(widget.userInput) // Save based on medication name
          .set({
        'frequency': frequency,
        'updatedAt': Timestamp.now(),
      }, SetOptions(merge: true)); // Use merge to avoid overwriting other fields
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Frequency saved successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save frequency: $e")),
      );
    }
  }

  void _navigate() {
    if (_value != null) {
      _saveFrequency(_value!);
      if (_value! > 3) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddMed3_1_Custom(time: _value!),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddMed3_1(
              time: _value!,
              UserInput: widget.userInput,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medicine add Page'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                    "How often do you take this\n medication?",
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Divider(
                      color: Colors.blue,
                      thickness: 2,
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "Once daily",
                            style: TextStyle(fontSize: 20),
                          ),
                          Spacer(),
                          Radio<int?>(
                            value: 1,
                            groupValue: _value,
                            onChanged: (int? value) {
                              setState(() {
                                _value = value;
                              });
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Twice daily",
                            style: TextStyle(fontSize: 20),
                          ),
                          Spacer(),
                          Radio<int?>(
                            value: 2,
                            groupValue: _value,
                            onChanged: (int? value) {
                              setState(() {
                                _value = value;
                              });
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Three times daily",
                            style: TextStyle(fontSize: 20),
                          ),
                          Spacer(),
                          Radio<int?>(
                            value: 3,
                            groupValue: _value,
                            onChanged: (int? value) {
                              setState(() {
                                _value = value;
                              });
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Other",
                            style: TextStyle(fontSize: 20),
                          ),
                          Spacer(),
                          Radio<int?>(
                            value: 4,
                            groupValue: _value,
                            onChanged: (int? value) {
                              setState(() {
                                _value = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 18.0, right: 20, left: 20),
            child: SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _value != null ? _navigate : null,
                child: Text("Next"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
