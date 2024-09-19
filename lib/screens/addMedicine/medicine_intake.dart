import 'package:flutter/material.dart';
import 'package:timed/screens/addMedicine/add_time.dart';
import 'package:timed/screens/addMedicine/custom_add_time.dart';

class AddMed2 extends StatefulWidget {
  final String medication;

  const AddMed2({super.key, required this.medication});

  @override
  State<AddMed2> createState() => _AddMed2State();
}

class _AddMed2State extends State<AddMed2> {
  int? _value = 0;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicine add Page'),
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
                      height: media.height*0.2,
                      width: media.width*0.4,
                    ),
                  ),
                  const Text(
                    "How often do you take this\n medication?",
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(18.0),
                    child: Divider(
                      color: Colors.blue,
                      thickness: 2,
                    ),
                  ),
                  Column(
                    children: [
                      _buildFrequencyOption("Once daily", 1),
                      _buildFrequencyOption("Twice daily", 2),
                      _buildFrequencyOption("Three times daily", 3),
                      _buildFrequencyOption("Other", 4),
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
                child: const Text("Next"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFrequencyOption(String label, int value) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 20),
        ),
        const Spacer(),
        Radio<int?>(
          value: value,
          groupValue: _value,
          onChanged: (int? value) {
            setState(() {
              _value = value;
            });
          },
        ),
      ],
    );
  }

  void _navigate() {
    if (_value != null) {
      if (_value! > 3) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddMed3_1_Custom(
              medication: widget.medication,
              frequency: _value!,
            ),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddMed3_1(
              medication: widget.medication,
              frequency: _value!,
            ),
          ),
        );
      }
    }
  }
}