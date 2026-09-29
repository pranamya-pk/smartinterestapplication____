import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../services/database_helper.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> exportCsv(BuildContext context) async {
    final rows = await DatabaseHelper.instance.getAllForExport();

    final csvRows = <List<dynamic>>[
      [
        'ID',
        'Contact',
        'Mobile',
        'Amount',
        'Type',
        'Interest Rate',
        'Rate Type',
        'Start Date',
        'Due Date',
        'Note',
      ],
      ...rows.map(
        (r) => [
          r['id'],
          r['contact'],
          r['mobile'],
          r['amount'],
          r['type'],
          r['rate'],
          r['rate_type'],
          r['start_date'],
          r['due_date'],
          r['note'],
        ],
      ),
    ];

    final csv = const ListToCsvConverter().convert(csvRows);
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/smart_interest_x_export.csv');
    await file.writeAsString(csv);

    await Share.shareXFiles(
      [XFile(file.path)],
      text: 'SmartInterestX transaction export',
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Settings & Backup',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 14),
        Card(
          child: ListTile(
            leading: const Icon(Icons.file_download),
            title: const Text('Export transactions as CSV'),
            subtitle: const Text('Save and share transaction data.'),
            onTap: () => exportCsv(context),
          ),
        ),
        const Card(
          child: ListTile(
            leading: Icon(Icons.storage),
            title: Text('Local backup'),
            subtitle: Text(
              'Transactions are stored locally using SQLite. '
              'Cloud backup is not enabled in this beginner version.',
            ),
          ),
        ),
        const Card(
          child: ListTile(
            leading: Icon(Icons.cloud),
            title: Text('Cloud backup'),
            subtitle: Text(
              'The project specification recommends Firebase/Google Drive. '
              'This can be added as a future extension.',
            ),
          ),
        ),
        const Card(
          child: ListTile(
            leading: Icon(Icons.language),
            title: Text('Interface language'),
            subtitle: Text('English. The supplied PDF does not specify another required language.'),
          ),
        ),
      ],
    );
  }
}
