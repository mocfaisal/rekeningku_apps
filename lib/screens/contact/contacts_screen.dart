import 'package:flutter/material.dart';
import '/models/contact.dart';
import 'add_contact_screen.dart';
import '/screens/account/account_list_screen.dart';

class ContactsScreen extends StatefulWidget {
  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final List<Contact> contacts = [
    Contact(name: 'John Doe', note: 'Friend from college'),
    Contact(name: 'Jane Smith', note: 'Work colleague'),
  ];

  void _deleteContact(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Contact'),
          content: Text('Are you sure you want to delete this contact?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  contacts.removeAt(index);
                });
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _editContact(int index) {
    // Implement edit contact logic
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(contacts[index].name),
            subtitle: Text(contacts[index].note),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AccountListScreen(contactName: contacts[index].name),
                ),
              );
            },
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'Edit') {
                  _editContact(index);
                } else if (value == 'Delete') {
                  _deleteContact(index);
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
