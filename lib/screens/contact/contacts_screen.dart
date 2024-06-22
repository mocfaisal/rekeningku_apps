import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/models/contact.dart';
import 'add_contact_screen.dart';
import '/screens/account/account_list_screen.dart';

class ContactsScreen extends StatefulWidget {
  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _deleteContact(String id) async {
    await _firestore.collection('contacts').doc(id).delete();
  }

  void _editContact(String id) {
    // Implement edit contact logic
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('contacts').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final contacts = snapshot.data!.docs.map((doc) {
            return ListTile(
              title: Text(doc['name']),
              subtitle: Text(doc['note']),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AccountListScreen(contactName: doc['name']),
                  ),
                );
              },
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'Edit') {
                    _editContact(doc.id);
                  } else if (value == 'Delete') {
                    _deleteContact(doc.id);
                  }
                },
                itemBuilder: (BuildContext context) {
                  return {'Edit', 'Delete'}.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              ),
            );
          }).toList();

          return ListView(children: contacts);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddContactScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
