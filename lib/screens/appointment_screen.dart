import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:timed/utils/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timed/widgets/forAppointment/delete_appointment.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
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
          "Appointment",
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
            .collection('appointments')
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
              child: Text("Nothing to show"),
            );
          }
          final data = snapshot.data;
          return ListView.builder(
            itemCount: data?.docs.length,
            itemBuilder: (context, index) {
              final appointment = data?.docs[index];
              final appointmentDate = (appointment?['appointmentDate'] as Timestamp).toDate();
              String formattedDate = DateFormat('yMMMd').format(appointmentDate);

              return Padding(
                padding: const EdgeInsets.all(8),
                child: Card(
                  child: ListTile(
                    title: Text(
                      appointment?['appointmentName'],
                      style: const TextStyle(fontSize: 20),
                    ),
                    subtitle: Text(appointment?['hospitalName']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          formattedDate,
                          style: const TextStyle(fontSize: 15),
                        ),
                        IconButton(
                          onPressed: () {
                            deleteAppointment(context, data!.docs[index].id, user!.uid);
                          },
                          icon: FaIcon(FontAwesomeIcons.circleXmark),
                        ),
                      ],
                    ),
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
