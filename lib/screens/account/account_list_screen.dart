import 'package:flutter/material.dart';
import '/models/account.dart';
import 'add_account_screen.dart';

class AccountListScreen extends StatefulWidget {
  final String contactName;

  AccountListScreen({required this.contactName});

  @override
  _AccountListScreenState createState() => _AccountListScreenState();
}

class _AccountListScreenState extends State<AccountListScreen> {
  final List<Account> accounts = [
    Account(
      name: "John Doe",
      bank: "Bank Central Asia",
      accountNumber: "1234567890",
      note: "Primary account",
    ),
    // Add more dummy accounts if needed
  ];

  void _copyAccount(int index) {
    // Implement copy logic
  }

  void _editAccount(int index) {
    // Implement edit logic
  }

  void _deleteAccount(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Account'),
          content: Text('Are you sure you want to delete this account?'),
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
                  accounts.removeAt(index);
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
      body: ListView.builder(
        itemCount: accounts.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(accounts[index].name),
            subtitle: Text(
              '${accounts[index].bank}\n${accounts[index].accountNumber}',
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'Copy') {
                  _copyAccount(index);
                } else if (value == 'Edit') {
                  _editAccount(index);
                } else if (value == 'Delete') {
                  _deleteAccount(index);
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
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddAccountScreen(contactName: widget.contactName),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
