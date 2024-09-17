// lib/widgets/popup_menu_widget.dart
import 'package:flutter/material.dart';
import 'package:timed/screens/Report_screen.dart';
import 'package:timed/screens/appointment_screen.dart';
import 'package:timed/screens/home_screen.dart';
import 'package:timed/utils/app_colors.dart';

class PopupMenuWidget extends StatelessWidget {
  const PopupMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await showMenu(
          context: context,
          position: RelativeRect.fromLTRB(
            0,
            MediaQuery.of(context).size.height - 200, // Adjust vertical position as needed
            0,
            0,
          ),
          items: [
            PopupMenuItem(
              child: ListTile(
                leading: Icon(Icons.home),
                title: Text('Home'),
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const Homescreen()));
                },
              ),
            ),
            PopupMenuItem(
              child: ListTile(
                leading: Icon(Icons.calendar_today),
                title: Text('Appointments'),
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const AppointmentScreen()));
                },
              ),
            ),
            PopupMenuItem(
              child: ListTile(
                leading: Icon(Icons.file_copy),
                title: Text('Reports'),
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const ReportScreen()));
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
                borderRadius: BorderRadius.circular(30), // Rounded corners
              ),
              child: Center(
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ), 
    );
  }
}
