import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '/models/bank.dart';

Future<List<Bank>> loadBanks() async {
  final String response = await rootBundle.loadString('assets/indonesia-bank.json');
  final List<dynamic> data = json.decode(response);
  List<Bank> banks = data.map((json) => Bank.fromJson(json)).toList();

  // Sorting banks by name
  banks.sort((a, b) => a.name.compareTo(b.name));
  return banks;
}
