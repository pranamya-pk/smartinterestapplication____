import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/models.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _openDatabase();
    return _database!;
  }

  Future<Database> _openDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'smart_interest_x.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE contacts(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            mobile TEXT NOT NULL,
            email TEXT,
            type TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE transactions(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            contact_id INTEGER NOT NULL,
            amount REAL NOT NULL,
            type TEXT NOT NULL,
            rate REAL NOT NULL,
            rate_type TEXT NOT NULL,
            start_date TEXT NOT NULL,
            due_date TEXT,
            note TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE payments(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            transaction_id INTEGER NOT NULL,
            amount REAL NOT NULL,
            payment_date TEXT NOT NULL,
            mode TEXT NOT NULL,
            proof_path TEXT
          )
        ''');
      },
    );
  }

  Future<int> addContact(Contact contact) async {
    final db = await database;
    return db.insert('contacts', contact.toMap());
  }

  Future<List<Contact>> getContacts() async {
    final db = await database;
    final rows = await db.query('contacts', orderBy: 'name ASC');
    return rows.map(Contact.fromMap).toList();
  }

  Future<int> addTransaction(LoanTransaction item) async {
    final db = await database;
    return db.insert('transactions', item.toMap());
  }

  Future<List<LoanTransaction>> getTransactions() async {
    final db = await database;
    final rows = await db.query('transactions', orderBy: 'start_date DESC');
    return rows.map(LoanTransaction.fromMap).toList();
  }

  Future<int> addPayment(Payment payment) async {
    final db = await database;
    return db.insert('payments', payment.toMap());
  }

  Future<List<Payment>> getPayments(int transactionId) async {
    final db = await database;
    final rows = await db.query(
      'payments',
      where: 'transaction_id = ?',
      whereArgs: [transactionId],
      orderBy: 'payment_date DESC',
    );
    return rows.map(Payment.fromMap).toList();
  }

  Future<List<Map<String, dynamic>>> getAllForExport() async {
    final db = await database;
    return db.rawQuery('''
      SELECT
        t.id, c.name AS contact, c.mobile,
        t.amount, t.type, t.rate, t.rate_type,
        t.start_date, t.due_date, t.note
      FROM transactions t
      LEFT JOIN contacts c ON c.id = t.contact_id
      ORDER BY t.start_date DESC
    ''');
  }
}
