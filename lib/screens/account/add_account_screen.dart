import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dropdown_search/dropdown_search.dart';
import '/models/bank.dart';
import '/utils/bank_loader.dart';

class AddAccountScreen extends StatefulWidget {
  final String? accountId;
  final String contactName;
  final String? initialName;
  final String? initialBank;
  final String? initialAccountNumber;
  final String? initialNote;

  AddAccountScreen({
    this.accountId,
    required this.contactName,
    this.initialName,
    this.initialBank,
    this.initialAccountNumber,
    this.initialNote,
  });

  @override
  _AddAccountScreenState createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends State<AddAccountScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  Bank? _selectedBank;
  List<Bank> _banks = [];

  @override
  void initState() {
    super.initState();
    _loadBanks();

    if (widget.initialName != null) {
      _nameController.text = widget.initialName!;
    }
    if (widget.initialAccountNumber != null) {
      _accountNumberController.text = widget.initialAccountNumber!;
    }
    if (widget.initialNote != null) {
      _noteController.text = widget.initialNote!;
    }
  }

  Future<void> _loadBanks() async {
    final banks = await loadBanks();
    setState(() {
      _banks = banks;
      if (widget.initialBank != null) {
        _selectedBank =
            _banks.firstWhere((bank) => bank.name == widget.initialBank);
      }
    });
  }

  Future<void> _saveAccount(BuildContext context) async {
    final name = _nameController.text.trim();
    final accountNumber = _accountNumberController.text.trim();
    final note = _noteController.text.trim();
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('No user is logged in')));
      return;
    }

    if (name.isEmpty || _selectedBank == null || accountNumber.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('All fields are required')));
      return;
    }

    try {
      if (widget.accountId == null) {
        await FirebaseFirestore.instance.collection('accounts').add({
          'name': name,
          'bank': _selectedBank!.name,
          'accountNumber': accountNumber,
          'note': note,
          'userId': user.uid,
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Account added successfully')));
      } else {
        await FirebaseFirestore.instance
            .collection('accounts')
            .doc(widget.accountId)
            .update({
          'name': name,
          'bank': _selectedBank!.name,
          'accountNumber': accountNumber,
          'note': note,
          'userId': user.uid,
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Account updated successfully')));
      }
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to save account: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.accountId == null
            ? 'Add Account for ${widget.contactName}'
            : 'Edit Account for ${widget.contactName}'),
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
              selectedItem: _selectedBank,
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
              onPressed: () => _saveAccount(context),
              child: Text(
                  widget.accountId == null ? 'Add Account' : 'Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
