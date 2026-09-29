import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/database_helper.dart';

class AppProvider extends ChangeNotifier {
  final db = DatabaseHelper.instance;

  List<Contact> contacts = [];
  List<LoanTransaction> transactions = [];

  Future<void> loadData() async {
    contacts = await db.getContacts();
    transactions = await db.getTransactions();
    notifyListeners();
  }

  Future<void> addContact(Contact contact) async {
    await db.addContact(contact);
    await loadData();
  }

  Future<void> addTransaction(LoanTransaction transaction) async {
    await db.addTransaction(transaction);
    await loadData();
  }

  Future<void> addPayment(Payment payment) async {
    await db.addPayment(payment);
    await loadData();
  }

  Contact? findContact(int id) {
    try {
      return contacts.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }
}
