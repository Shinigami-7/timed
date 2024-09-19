import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:timed/screens/Report_screen.dart';
import 'package:timed/screens/addMedicine/select_medicine.dart';
import 'package:timed/utils/app_colors.dart';
import 'package:timed/widgets/forAppointment/add_appointment.dart';
import 'package:timed/widgets/forReminder/add_reminder.dart';

class PopupMenuWidget extends StatefulWidget {
  const PopupMenuWidget({super.key});

  @override
  State<PopupMenuWidget> createState() => _PopupMenuWidgetState();
}

class _PopupMenuWidgetState extends State<PopupMenuWidget> {
  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser; // Initialize user here
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await showMenu(
          context: context,
          position: RelativeRect.fromLTRB(
            MediaQuery.of(context).size.width / 2 - 100, // Center horizontally
            MediaQuery.of(context).size.height - 200, // Adjust vertical position to appear above the bottom navigation bar
            MediaQuery.of(context).size.width / 2 - 100, // Center horizontally
            MediaQuery.of(context).padding.bottom + 50, // Ensure it appears above the bottom navigation bar
          ),
          items: [
            PopupMenuItem(
              child: ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>AddMed()));
                },
              ),
            ),
            PopupMenuItem(
              child: ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Appointments'),
                onTap: () {
                  if (user != null) {
                    addAppointment(context, user!.uid); // Ensure user is not null
                  } else {
                    Fluttertoast.showToast(msg: 'User not logged in');
                  }
                },
              ),
            ),
            PopupMenuItem(
              child: ListTile(
                leading: const Icon(Icons.file_copy),
                title: const Text('Reports'),
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const ReportScreen()),
                  );
                },
              ),
            ),
          ],
        );
      },
      child: Container(
        width: 60, // Adjust width as needed
        height: 60, // Adjust height as needed
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.primaryG, // Customize gradient colors
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              blurRadius: 3,
              offset: Offset(0, 2),
            ),
          ],
          borderRadius: BorderRadius.circular(30), // Rounded corners
        ),
        child: const Center(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
