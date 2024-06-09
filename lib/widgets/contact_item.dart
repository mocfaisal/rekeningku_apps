import 'package:flutter/material.dart';
import '../models/contact.dart';

class ContactItem extends StatelessWidget {
  final Contact contact;

  ContactItem({required this.contact});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(contact.name),
      subtitle: Text(contact.note),
      onTap: () {
        // Handle contact item tap
      },
    );
  }
}
