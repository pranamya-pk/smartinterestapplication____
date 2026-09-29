import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/app_provider.dart';
import '../services/interest_service.dart';
import '../utils/app_format.dart';

class TransactionDetailScreen extends StatefulWidget {
  final LoanTransaction transaction;

  const TransactionDetailScreen({super.key, required this.transaction});

  @override
  State<TransactionDetailScreen> createState() => _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  final paymentAmount = TextEditingController();
  String mode = 'UPI';
  String? proofPath;

  Future<void> addPayment() async {
    final value = double.tryParse(paymentAmount.text);
    if (value == null || value <= 0) return;

    await context.read<AppProvider>().addPayment(
          Payment(
            transactionId: widget.transaction.id!,
            amount: value,
            date: DateTime.now(),
            mode: mode,
            proofPath: proofPath,
          ),
        );

    paymentAmount.clear();
    setState(() => proofPath = null);
  }

  Future<void> chooseProof() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => proofPath = image.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.transaction;
    final provider = context.watch<AppProvider>();
    final contact = provider.findContact(t.contactId);
    final todayInterest = InterestService.interestTillDate(
      principal: t.amount,
      rate: t.rate,
      rateType: t.rateType,
      startDate: t.startDate,
    );
    final dueInterest = t.dueDate == null
        ? null
        : InterestService.interestTillDate(
            principal: t.amount,
            rate: t.rate,
            rateType: t.rateType,
            startDate: t.startDate,
            endDate: t.dueDate,
          );

    return Scaffold(
      appBar: AppBar(title: const Text('Transaction Details')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact?.name ?? 'Unknown contact',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 10),
                  Text('Type: ${t.type}'),
                  Text('Principal: ${AppFormat.money(t.amount)}'),
                  Text('Rate: ${t.rate}% ${t.rateType}'),
                  Text('Start: ${AppFormat.date(t.startDate)}'),
                  Text(
                    'Due: ${t.dueDate == null ? 'Not set' : AppFormat.date(t.dueDate!)}',
                  ),
                  if (t.note.isNotEmpty) Text('Note: ${t.note}'),
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text('Interest Calculation'),
                  const SizedBox(height: 10),
                  Text('Interest till today: ${AppFormat.money(todayInterest)}'),
                  if (dueInterest != null)
                    Text('Interest till due date: ${AppFormat.money(dueInterest)}'),
                  Text(
                    'Total till today: ${AppFormat.money(t.amount + todayInterest)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text('Record Payment', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          TextField(
            controller: paymentAmount,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Payment amount'),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: mode,
            items: const [
              DropdownMenuItem(value: 'UPI', child: Text('UPI')),
              DropdownMenuItem(value: 'Bank Transfer', child: Text('Bank Transfer')),
              DropdownMenuItem(value: 'Cash', child: Text('Cash')),
              DropdownMenuItem(value: 'Other', child: Text('Other')),
            ],
            onChanged: (v) => setState(() => mode = v!),
            decoration: const InputDecoration(labelText: 'Payment mode'),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: chooseProof,
            icon: const Icon(Icons.receipt_long),
            label: Text(proofPath == null ? 'Attach proof' : 'Proof selected'),
          ),
          const SizedBox(height: 10),
          FilledButton(
            onPressed: addPayment,
            child: const Text('Save Payment'),
          ),
          const SizedBox(height: 20),
          Text('Payment History', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          FutureBuilder<List<Payment>>(
            future: context.read<AppProvider>().db.getPayments(t.id!),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }

              final payments = snapshot.data!;
              if (payments.isEmpty) {
                return const Text('No payments recorded.');
              }

              return Column(
                children: payments
                    .map(
                      (p) => Card(
                        child: ListTile(
                          leading: const Icon(Icons.payments),
                          title: Text(AppFormat.money(p.amount)),
                          subtitle: Text(
                            '${AppFormat.date(p.date)} • ${p.mode}',
                          ),
                          trailing: p.proofPath == null
                              ? null
                              : const Icon(Icons.attachment),
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
