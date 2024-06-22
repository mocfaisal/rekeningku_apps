import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/models/contact.dart';
import 'add_contact_screen.dart';
import '/screens/account/account_list_screen.dart';

class ContactsScreen extends StatefulWidget {
  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final User? _user = FirebaseAuth.instance.currentUser;
  final CollectionReference contactsCollection =
      FirebaseFirestore.instance.collection('contacts');
  final CollectionReference accountsCollection =
      FirebaseFirestore.instance.collection('accounts');

  void _deleteContact(String contactId, String contactName) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Delete'),
        content:
            Text('Are you sure you want to delete ${contactName} contact?\n All data account will be deleted'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await contactsCollection.doc(contactId).delete();
              await accountsCollection
                  .where('contactId', isEqualTo: contactId)
                  .get()
                  .then((querySnapshot) {
                for (var doc in querySnapshot.docs) {
                  doc.reference.delete();
                }
              });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      'Contact and related accounts deleted successfully')));
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _editContact(String contactId, String name, String note) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddContactScreen(
          contactId: contactId,
          initialName: name,
          initialNote: note,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Contacts'),
        ),
        body: Center(
          child: Text('No user is logged in.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: contactsCollection
            .where('userId', isEqualTo: _user!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final contacts = snapshot.data!.docs
              .map((doc) => Contact(
                    id: doc.id,
                    name: doc['name'],
                    note: doc['note'],
                  ))
              .toList();

          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contact = contacts[index];

              return ListTile(
                title: Text(contact.name),
                subtitle: Text(contact.note),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AccountListScreen(contactId: contact.id, contactName: contact.name),
                    ),
                  );
                },
                trailing: PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'Edit') {
                      _editContact(contact.id, contact.name, contact.note);
                    } else if (value == 'Delete') {
                      _deleteContact(contact.id, contact.name);
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
            },
          );
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
