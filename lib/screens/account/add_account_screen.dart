import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Bank? _selectedBank;
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

  void _addAccount() async {
    final String name = _nameController.text.trim();
    final String accountNumber = _accountNumberController.text.trim();
    final String note = _noteController.text.trim();

    if (_selectedBank == null || name.isEmpty || accountNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    await _firestore.collection('accounts').add({
      'contactName': widget.contactName,
      'name': name,
      'bank': _selectedBank!.name,
      'accountNumber': accountNumber,
      'note': note,
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Account for ${widget.contactName}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
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
              decoration: const InputDecoration(labelText: 'Atas Nama'),
            ),
            const SizedBox(height: 10),
            DropdownSearch<Bank>(
              items: _banks,
              itemAsString: (Bank item) => item.name,
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: 'Bank',
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  border: OutlineInputBorder(),
                ),
              ),
              popupProps: PopupProps.bottomSheet(
                showSearchBox: true,
                searchFieldProps: const TextFieldProps(
                  decoration: InputDecoration(
                    labelText: 'Cari Bank',
                  ),
                ),
                fit: FlexFit.loose,
                itemBuilder: (context, Bank item, bool isSelected) {
                  return ListTile(
                    title: Text(item.name),
                  );
                },
                constraints: const BoxConstraints(
                  maxHeight: 250,
                ),
              ),
              dropdownBuilder: (context, Bank? selectedItem) {
                return Text(selectedItem?.name ?? 'Pilih Bank');
              },
              onChanged: (Bank? value) {
                setState(() {
                  _selectedBank = value;
                });
              },
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _accountNumberController,
              decoration: const InputDecoration(labelText: 'Nomor Rekening'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(labelText: 'Catatan'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addAccount,
              child: const Text('Add Account'),
            ),
          ],
        ),
      ),
    );
  }
}
