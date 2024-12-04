import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timed/screens/addMedicine/medicine_intake.dart';

class AddMed extends StatefulWidget {
  const AddMed({super.key});

  @override
  State<AddMed> createState() => _AddMedState();
}

class _AddMedState extends State<AddMed> {
  String? selectedMedication;

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
                      height: media.height*0.2,
                      width: media.width*0.4,
                    ),
                  ),
                  const Text(
                    "Select a medication for reminder",
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(18.0),
                    child: Divider(
                      color: Colors.blue,
                      thickness: 2,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: Row(
                      children: [
                        
                        
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection("medicine").snapshots(), 
                          builder: (context,snapshot){
                            List<DropdownMenuItem> medicineName = [];
                            if(!snapshot.hasData){
                              const CircularProgressIndicator();
                            }
                            else{
                              final medName = snapshot.data?.docs.reversed.toList();
                              medicineName.add(DropdownMenuItem(
                                value: "0",
                                child: Text("Select Medicine"),
                                ));
                              for(var medicine in medName!){
                                medicineName.add(DropdownMenuItem(
                                  value: medicine.id,
                                  child: Text(medicine['name'],
                                  )
                                  )
                                  );
                              }
                            }
                            return DropdownButton(
                              items: medicineName, 
                              onChanged: (MedicationValue){
                                setState(() {
                                  selectedMedication = MedicationValue;
                                });
                              },
                              value: selectedMedication,
                              isExpanded: false,
                              );
                          }
                        )
                       
                      ],
                    ),
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
                onPressed: () {
                  if (selectedMedication != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddMed2(
                          medication: selectedMedication!,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please select a medication")),
                    );
                  }
                },
                child: const Text("Next"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}