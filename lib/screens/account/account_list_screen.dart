import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/models/account.dart';
import 'add_account_screen.dart';

class AccountListScreen extends StatelessWidget {
  final String contactName;

  AccountListScreen({required this.contactName});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _deleteAccount(String id) async {
    await _firestore.collection('accounts').doc(id).delete();
  }

  void _editAccount(String id) {
    // Implement edit account logic
  }

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
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('accounts')
            .where('contactName', isEqualTo: contactName)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final accounts = snapshot.data!.docs.map((doc) {
            return ListTile(
              title: Text(doc['name']),
              subtitle: Text('${doc['bank']}\n${doc['accountNumber']}'),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'Copy') {
                    // Implement copy logic
                  } else if (value == 'Edit') {
                    _editAccount(doc.id);
                  } else if (value == 'Delete') {
                    _deleteAccount(doc.id);
                  }
                },
                itemBuilder: (BuildContext context) {
                  return {'Copy', 'Edit', 'Delete'}.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              ),
            );
          }).toList();

          return ListView(children: accounts);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddAccountScreen(contactName: contactName),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
