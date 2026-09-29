import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/app_provider.dart';
import '../services/notification_service.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final amount = TextEditingController();
  final rate = TextEditingController();
  final note = TextEditingController();

  String type = 'Given';
  String rateType = 'Monthly';
  int? contactId;
  DateTime startDate = DateTime.now();
  DateTime? dueDate;

  Future<void> pickDate(bool due) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: dueDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (due) {
          dueDate = picked;
        } else {
          startDate = picked;
        }
      });
    }
  }

  Future<void> save() async {
    final parsedAmount = double.tryParse(amount.text);
    final parsedRate = double.tryParse(rate.text);

    if (contactId == null || parsedAmount == null || parsedRate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields.')),
      );
      return;
    }

    final item = LoanTransaction(
      contactId: contactId!,
      amount: parsedAmount,
      type: type,
      rate: parsedRate,
      rateType: rateType,
      startDate: startDate,
      dueDate: dueDate,
      note: note.text.trim(),
    );

    await context.read<AppProvider>().addTransaction(item);

    if (dueDate != null) {
      await NotificationService.showSimpleReminder(
        'SmartInterestX reminder',
        'A payment is due on ${dueDate!.day}/${dueDate!.month}/${dueDate!.year}.',
      );
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final contacts = context.watch<AppProvider>().contacts;

    return Scaffold(
      appBar: AppBar(title: const Text('Add Transaction')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<int>(
            value: contactId,
            items: contacts
                .map(
                  (c) => DropdownMenuItem(
                    value: c.id,
                    child: Text('${c.name} (${c.type})'),
                  ),
                )
                .toList(),
            onChanged: (v) => setState(() => contactId = v),
            decoration: const InputDecoration(labelText: 'Borrower / Lender'),
          ),
          const SizedBox(height: 12),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'Given', label: Text('Given')),
              ButtonSegment(value: 'Taken', label: Text('Taken')),
            ],
            selected: {type},
            onSelectionChanged: (s) => setState(() => type = s.first),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: amount,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Amount'),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: rate,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Interest rate (%)'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: rateType,
                  items: const [
                    DropdownMenuItem(value: 'Monthly', child: Text('Monthly')),
                    DropdownMenuItem(value: 'Yearly', child: Text('Yearly')),
                  ],
                  onChanged: (v) => setState(() => rateType = v!),
                  decoration: const InputDecoration(labelText: 'Rate type'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Start date'),
            subtitle: Text('${startDate.day}/${startDate.month}/${startDate.year}'),
            trailing: const Icon(Icons.calendar_month),
            onTap: () => pickDate(false),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Due date (optional)'),
            subtitle: Text(
              dueDate == null
                  ? 'Not selected'
                  : '${dueDate!.day}/${dueDate!.month}/${dueDate!.year}',
            ),
            trailing: const Icon(Icons.event),
            onTap: () => pickDate(true),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: note,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Notes / description',
            ),
          ),
          const SizedBox(height: 22),
          FilledButton.icon(
            onPressed: save,
            icon: const Icon(Icons.save),
            label: const Text('Save Transaction'),
          ),
        ],
      ),
    );
  }
}
