import 'package:flutter/material.dart';
import 'package:timed/screens/profile_screen.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage>createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool _messageNotifications = true;
  bool _showPreviews = true;
  bool _showReactionNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.lightBlueAccent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            // Section title
            Text(
              "Notification",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),

            // Message Notifications Checkbox
            CheckboxListTile(
              title: Text("Message notifications"),
              subtitle: Text("Show notifications for new messages"),
              value: _messageNotifications,
              onChanged: (bool? value) {
                setState(() {
                  _messageNotifications = value ?? false;
                });
              },
              activeColor: Colors.green,
            ),

            Divider(),

            CheckboxListTile(
              title: Text("Show previews"),
              value: _showPreviews,
              onChanged: (bool? value) {
                setState(() {
                  _showPreviews = value ?? false;
                });
              },
              activeColor: Colors.green,
            ),

            Divider(),
            CheckboxListTile(
              title: Text("Show unread notifications"),
              value: _showReactionNotifications,
              onChanged: (bool? value) {
                setState(() {
                  _showReactionNotifications = value ?? false;
                });
              },
              activeColor: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}
