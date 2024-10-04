import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timed/utils/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "Health Reports",
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
          return ListView.builder(
            itemCount: data?.docs.length,
            itemBuilder: (context, index) {
              final report = data?.docs[index];
              final reportDate = (report?['timeStamp'] as Timestamp).toDate();
              String formattedDate = DateFormat('yMMMd').format(reportDate);

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
          );
        },
      ),
    );
  }
}
