import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddReportScreen extends StatefulWidget {
  const AddReportScreen({super.key});

  @override
  _AddReportScreenState createState() => _AddReportScreenState();
}

class _AddReportScreenState extends State<AddReportScreen> {
  final _bloodPressureController = TextEditingController();
  final _sugarLevelController = TextEditingController();
  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  void _addReport() async {
    final bloodPressure = int.tryParse(_bloodPressureController.text) ?? 0;
    final sugarLevel = int.tryParse(_sugarLevelController.text) ?? 0;

    if (bloodPressure <= 0 || sugarLevel <= 0) {
      Fluttertoast.showToast(msg: 'Please enter valid values');
      return;
    }

    try {
      DateTime now = DateTime.now();
      Timestamp timestamp = Timestamp.fromDate(now);

      await FirebaseFirestore.instance
          .collection('user')
          .doc(user!.uid)
          .collection('journal')
          .add({
        'timeStamp': timestamp,
        'bloodPressure': bloodPressure,
        'sugarLevel': sugarLevel,
      });

      Fluttertoast.showToast(msg: 'Report Added');
      Navigator.pop(context);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Report'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _bloodPressureController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Blood Pressure (mmHg)',
                hintText: 'e.g., 120',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _sugarLevelController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Sugar Level (mg/dL)',
                hintText: 'e.g., 90',
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _addReport,
              child: const Text('Add Report'),
            ),
          ],
        ),
      ),
    );
  }
}
