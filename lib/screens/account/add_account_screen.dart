import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/models/bank.dart';
import '/utils/bank_loader.dart';

class AddAccountScreen extends StatefulWidget {
  final String contactId;
  final String contactName;
  final String? accountId;
  final String? initialName;
  final String? initialBankCode;
  final String? initialAccountNumber;
  final String? initialNote;

  AddAccountScreen({
    required this.contactId,
    required this.contactName,
    this.accountId,
    this.initialName,
    this.initialBankCode,
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
  User? _user;
  bool _isLoading = false;

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
      _initializeFields();
    });
  }

  void _initializeFields() {
    if (widget.accountId != null) {
      _nameController.text = widget.initialName ?? '';
      _accountNumberController.text = widget.initialAccountNumber ?? '';
      _noteController.text = widget.initialNote ?? '';
      _selectedBank = _getBankByCode(widget.initialBankCode ?? '');
    }
    if (_selectedBank != null) {
      print(_selectedBank!.name);
    }
    print(widget.initialBankCode);
  }

  Bank _getBankByCode(String bankCode) {
    final bank = _banks.firstWhere(
      (bank) => bank.code == bankCode,
      orElse: () => Bank(name: 'Unknown', code: bankCode),
    );
    return bank;
  }

  Future<void> _saveAccount() async {
    final name = _nameController.text.trim();
    final accountNumber = _accountNumberController.text.trim();
    final note = _noteController.text.trim();
    final user = _user;
    final selectedBank = _selectedBank?.code;
    final accountId = widget.accountId;

    if (user == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('No user is logged in')));
      return;
    }

    if (name.isEmpty || accountNumber.isEmpty || selectedBank == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Name, Bank and Account Number are required')));
      return;
    }
    setState(() {
      _isLoading = true;
    });

    try {
      final accountData = {
        'userId': user.uid,
        'contactId': widget.contactId,
        'name': name,
        'accountNumber': accountNumber,
        'note': note,
        'bankCode': selectedBank,
      };

      if (accountId == null) {
        await FirebaseFirestore.instance
            .collection('accounts')
            .add(accountData);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Account added successfully')));
      } else {
        await FirebaseFirestore.instance
            .collection('accounts')
            .doc(accountId)
            .update(accountData);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Account updated successfully')));
      }
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to save account: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
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
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
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
                        isFilterOnline: false,
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
                        onDismissed: () {
                          setState(() {
                            // Close the dropdown when clicked outside
                            print('Dismissed');
                          });
                        },
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
                      decoration:
                          const InputDecoration(labelText: 'Nomor Rekening'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _noteController,
                      decoration: const InputDecoration(labelText: 'Catatan'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _saveAccount,
                      child: Text(widget.accountId == null
                          ? 'Add Account'
                          : 'Save Changes'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
