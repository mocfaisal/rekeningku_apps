import 'package:flutter/material.dart';

class AddAccountScreen extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final List<String> _banks = ['Bank A', 'Bank B', 'Bank C'];
  String _selectedBank = 'Bank A';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Account'),
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
            DropdownButtonFormField(
              value: _selectedBank,
              items: _banks.map((String bank) {
                return DropdownMenuItem(
                  value: bank,
                  child: Text(bank),
                );
              }).toList(),
              onChanged: (newValue) {
                _selectedBank = newValue!;
              },
              decoration: InputDecoration(labelText: 'Bank'),
            ),
            TextField(
              controller: _accountNumberController,
              decoration: InputDecoration(labelText: 'Nomor Rekening'),
              keyboardType: TextInputType.number,
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
