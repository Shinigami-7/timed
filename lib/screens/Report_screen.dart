import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timed/utils/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timed/widgets/round_gradient_button.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  Future<void> calculateAverages() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('user')
          .doc(user!.uid)
          .collection('journal')
          .get();

      if (snapshot.docs.isEmpty) {
        // Show dialog for no data
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('No journal'),
            content: const Text('No journal are available to calculate averages.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        return;
      }

      double totalBloodPressure = 0;
      double totalSugarLevel = 0;

      for (var doc in snapshot.docs) {
        totalBloodPressure += (doc['bloodPressure'] ?? 0).toDouble();
        totalSugarLevel += (doc['sugarLevel'] ?? 0).toDouble();
      }

      final avgBloodPressure = totalBloodPressure / snapshot.docs.length;
      final avgSugarLevel = totalSugarLevel / snapshot.docs.length;

      // Show averages in a dialog
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Average Report'),
          content: Text(
            'Average Blood Pressure: ${avgBloodPressure.toStringAsFixed(1)} mmHg\n'
                'Average Sugar Level: ${avgSugarLevel.toStringAsFixed(1)} mg/dL',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      // Handle errors
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Error'),
          content: Text('Failed to calculate averages: ${e.toString()}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "Journal",
          style: TextStyle(
            color: AppColors.blackColor,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('user')
            .doc(user!.uid)
            .collection('reports')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor2),
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No reports available"),
            );
          }

          final data = snapshot.data;
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: data?.docs.length,
                  itemBuilder: (context, index) {
                    final report = data?.docs[index];
                    final reportDate =
                    (report?['timeStamp'] as Timestamp).toDate();
                    String formattedDate =
                    DateFormat('yMMMd').format(reportDate);

                    return Padding(
                      padding: const EdgeInsets.all(8),
                      child: Card(
                        child: ListTile(
                          title: Text(
                            'BP: ${report?['bloodPressure']} mmHg, Sugar: ${report?['sugarLevel']} mg/dL',
                            style: const TextStyle(fontSize: 20),
                          ),
                          subtitle: Text(formattedDate),
                        ),
                      ),
                    );
                  },
                ),
              ),
              
            ],
          );
        },
      ),
    );
  }
}
