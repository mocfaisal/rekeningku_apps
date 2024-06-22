import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:clipboard/clipboard.dart';
import 'add_account_screen.dart';
import '/models/bank.dart';
import '/utils/bank_loader.dart';
import '/helpers/formatter.dart';

class AccountListScreen extends StatefulWidget {
  final String contactId;
  final String contactName;

  AccountListScreen({required this.contactId, required this.contactName});

  @override
  _AccountListScreenState createState() => _AccountListScreenState();
}

class _AccountListScreenState extends State<AccountListScreen> {
  final CollectionReference accountsCollection =
      FirebaseFirestore.instance.collection('accounts');
  User? _user;
  List<Bank> _banks = [];

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    _loadBanks();
  }

  Future<void> _loadBanks() async {
    final banks = await loadBanks();
    setState(() {
      _banks = banks;
    });
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

  void _editAccount(String id, String name, String bankCode,
      String accountNumber, String note) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddAccountScreen(
          contactId: widget.contactId,
          contactName: widget.contactName,
          accountId: id,
          initialName: name,
          initialBankCode: bankCode,
          initialAccountNumber: accountNumber,
          initialNote: note,
        ),
      ),
    );
  }

  String _getBankName(String bankCode) {
    final bank = _banks.firstWhere((bank) => bank.code == bankCode,
        orElse: () => Bank(name: 'Unknown', code: bankCode));
    return bank.name;
  }

  void _copyAccount(String name, String bank, String accountNumber) {
    final formattedAccountNumber = formatAccountNumber(bank, accountNumber);
    ;
    // final formattedAccountNumber = accountNumber;
    final data = '$bank\n$name\n$formattedAccountNumber';
    FlutterClipboard.copy(data).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Account details copied to clipboard')));
    });
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
            .where('contactId', isEqualTo: widget.contactId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No accounts found for this contact.'));
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error.toString()}'));
          }

          final accounts = snapshot.data!.docs.map((doc) {
            final bankName = _getBankName(doc['bankCode']);
            return ListTile(
              title: Text(doc['name']),
              subtitle: Text('${bankName}\n${doc['accountNumber']}'),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'Copy') {
                    _copyAccount(doc['name'], bankName, doc['accountNumber']);
                  } else if (value == 'Edit') {
                    _editAccount(doc.id, doc['name'], doc['bankCode'],
                        doc['accountNumber'], doc['note']);
                  } else if (value == 'Delete') {
                    _deleteAccount(doc.id, doc['name'], bankName);
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
              builder: (context) => AddAccountScreen(
                  contactId: widget.contactId, contactName: widget.contactName),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
