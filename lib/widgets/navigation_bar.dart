import 'package:flutter/material.dart';
import 'package:timed/screens/Report_screen.dart';
import 'package:timed/screens/appointment_screen.dart';
import 'package:timed/screens/home_screen.dart';
import 'package:timed/screens/profile_screen.dart';
import 'package:timed/utils/app_colors.dart';
import 'package:timed/widgets/pop_up_menu.dart';

class MainNavigationBar extends StatefulWidget {
  const MainNavigationBar({super.key});

  @override
  State<MainNavigationBar> createState() => _MainNavigationBarState();
}

class _MainNavigationBarState extends State<MainNavigationBar> {
  int myIndex = 0;

  final List<Widget> widgetList = const [
    Homescreen(),
    AppointmentScreen(),
    PopupMenuWidget(),
    ReportScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: myIndex,
        children: widgetList,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: myIndex,
        selectedItemColor: AppColors.primaryColor2,
        onTap: (index) {
          if (index == 2) {
          } else {
            setState(() {
              myIndex = index;
            });
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: PopupMenuWidget(),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.file_copy),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
