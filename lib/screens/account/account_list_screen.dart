import 'package:flutter/material.dart';

class AccountListScreen extends StatelessWidget {
  final String contactName;

  AccountListScreen({required this.contactName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Daftar Rekening",
              style: TextStyle(color: Colors.black, fontSize: 16.0),
            ),
            Text(
              contactName,
              style: TextStyle(color: Colors.black, fontSize: 12.0),
            ),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Text('Daftar Rekening untuk $contactName'),
      ),
    );
  }
}
