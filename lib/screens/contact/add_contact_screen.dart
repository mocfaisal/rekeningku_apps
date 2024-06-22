import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddContactScreen extends StatelessWidget {
  final String? contactId;
  final String? initialName;
  final String? initialNote;
  final TextEditingController _nameController;
  final TextEditingController _noteController;

  AddContactScreen({this.contactId, this.initialName, this.initialNote})
      : _nameController = TextEditingController(text: initialName),
        _noteController = TextEditingController(text: initialNote);

  Future<void> _saveContact(BuildContext context) async {
    final name = _nameController.text.trim();
    final note = _noteController.text.trim();
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('No user is logged in')));
      return;
    }

    if (name.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Name is required')));
      return;
    }

    try {
      if (contactId == null) {
        await FirebaseFirestore.instance.collection('contacts').add({
          'name': name,
          'note': note,
          'userId': user.uid,
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Contact added successfully')));
      } else {
        await FirebaseFirestore.instance
            .collection('contacts')
            .doc(contactId)
            .update({
          'name': name,
          'note': note,
          'userId': user.uid,
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Contact updated successfully')));
      }
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to save contact: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(contactId == null ? 'Add Contact' : 'Edit Contact'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _noteController,
              decoration: InputDecoration(labelText: 'Note'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _saveContact(context),
              child: Text(contactId == null ? 'Add Contact' : 'Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
