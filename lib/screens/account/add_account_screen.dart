import 'package:flutter/material.dart';
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
  List<Bank> _filteredBanks = [];
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
      _filteredBanks = banks;
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
  }

  Bank _getBankByCode(String bankCode) {
    return _banks.firstWhere(
      (bank) => bank.code == bankCode,
      orElse: () => Bank(name: 'Unknown', code: bankCode),
    );
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

  Future<void> _selectBank(BuildContext context) async {
    final Bank? selectedBank = await showModalBottomSheet<Bank>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              height: 400,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Search Bank',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setModalState(() {
                          _filteredBanks = _banks
                              .where((bank) => bank.name
                                  .toLowerCase()
                                  .contains(value.toLowerCase()))
                              .toList();
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _filteredBanks.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (index < 0 || index >= _filteredBanks.length) {
                          return null;
                        }
                        final bank = _filteredBanks[index];
                        return ListTile(
                          title: Text(bank.name),
                          onTap: () {
                            Navigator.pop(context, bank);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (selectedBank != null) {
      setState(() {
        _selectedBank = selectedBank;
        _filteredBanks = _banks;
      });
    }
    // Reset filtered banks back to original list when modal is dismissed
    setState(() {
      _filteredBanks = _banks;
    });
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
                    InkWell(
                      onTap: () => _selectBank(context),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Bank',
                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                          border: OutlineInputBorder(),
                        ),
                        child: Text(_selectedBank?.name ?? 'Pilih Bank'),
                      ),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: _saveAccount,
                          child: Text(widget.accountId == null
                              ? 'Add Account'
                              : 'Save Changes'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
