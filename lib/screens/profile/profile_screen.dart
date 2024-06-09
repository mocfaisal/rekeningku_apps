import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
   final String? name;
   final String? email;

  const ProfileScreen({Key? key, required this.name, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/profile_avatar.png'), // Replace with your avatar asset
            ),
            SizedBox(height: 20),
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: TextEditingController(text: name),
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Nama Pengguna',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: TextEditingController(text: email),
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Correct argument for color
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      ),
                      onPressed: () {
                        // Implement logout logic
                        Navigator.of(context).pushReplacementNamed('/login');
                      },
                      child: Text('Logout'),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        // Implement navigation to change password screen
                        Navigator.of(context).pushNamed('/change-password');
                      },
                      child: Text(
                        'Ubah Password',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
