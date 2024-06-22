import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'add_account_screen.dart';
import '/models/account.dart';

class AccountListScreen extends StatefulWidget {
  final String contactName;

  AccountListScreen({required this.contactName});

  @override
  _AccountListScreenState createState() => _AccountListScreenState();
}

class _AccountListScreenState extends State<AccountListScreen> {
  final CollectionReference accountsCollection =
      FirebaseFirestore.instance.collection('accounts');
  User? _user;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
  }

  void _deleteAccount(String id, String name, String bank) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Delete'),
        content:
            Text('Are you sure you want to delete ${name} - ${bank} account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await accountsCollection.doc(id).delete();
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Account deleted successfully')));
              Navigator.pop(context);
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _editAccount(
      String id, String name, String bank, String accountNumber, String note) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddAccountScreen(
          contactName: widget.contactName,
          accountId: id,
          initialName: name,
          initialBank: bank,
          initialAccountNumber: accountNumber,
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
          title: Text('Accounts'),
        ),
        body: Center(
          child: Text('No user is logged in.'),
        ),
      );
    }

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
              widget.contactName,
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
        stream: accountsCollection
            .where('userId', isEqualTo: _user!.uid)
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
                    _editAccount(doc.id, doc['name'], doc['bank'],
                        doc['accountNumber'], doc['note']);
                  } else if (value == 'Delete') {
                    _deleteAccount(doc.id, doc['name'], doc['bank']);
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
              builder: (context) =>
                  AddAccountScreen(contactName: widget.contactName),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
