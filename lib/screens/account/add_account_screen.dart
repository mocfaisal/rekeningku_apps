import 'package:flutter/material.dart';
import '/models/bank.dart';
import '/utils/bank_loader.dart';

class AddAccountScreen extends StatefulWidget {
  final String contactName;

  AddAccountScreen({required this.contactName});

  @override
  _AddAccountScreenState createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends State<AddAccountScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  String? _selectedBank;
  List<Bank> _banks = [];

  @override
  void initState() {
    super.initState();
    _loadBanks();
  }

  Future<void> _loadBanks() async {
    final banks = await loadBanks();
    setState(() {
      _banks = banks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Account for ${widget.contactName}'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Atas Nama'),
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Bank'),
              items: _banks.map((bank) {
                return DropdownMenuItem<String>(
                  value: bank.name,
                  child: Text(bank.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedBank = value;
                });
              },
            ),
            TextField(
              controller: _accountNumberController,
              decoration: InputDecoration(labelText: 'Nomor Rekening'),
            ),
            TextField(
              controller: _noteController,
              decoration: InputDecoration(labelText: 'Catatan'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement logic to add account
                Navigator.pop(context);
              },
              child: Text('Add Account'),
            ),
          ],
        ),
      ),
    );
  }
}
