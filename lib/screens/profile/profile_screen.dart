import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: John Doe', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Email: john.doe@example.com', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement logout logic
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
