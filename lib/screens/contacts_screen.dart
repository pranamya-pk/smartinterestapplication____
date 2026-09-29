import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/app_provider.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    return Scaffold(
      body: provider.contacts.isEmpty
          ? const Center(child: Text('No borrower or lender contacts yet.'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: provider.contacts.length,
              itemBuilder: (_, index) {
                final c = provider.contacts[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text(c.name[0].toUpperCase())),
                    title: Text(c.name),
                    subtitle: Text('${c.mobile}\n${c.email ?? ''}'),
                    isThreeLine: true,
                    trailing: Text(c.type),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (_) => const AddContactDialog(),
        ),
        child: const Icon(Icons.person_add),
      ),
    );
  }
}

class AddContactDialog extends StatefulWidget {
  const AddContactDialog({super.key});

  @override
  State<AddContactDialog> createState() => _AddContactDialogState();
}

class _AddContactDialogState extends State<AddContactDialog> {
  final name = TextEditingController();
  final mobile = TextEditingController();
  final email = TextEditingController();
  String type = 'Borrower';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Contact'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(controller: name, decoration: const InputDecoration(labelText: 'Name')),
            const SizedBox(height: 10),
            TextField(
              controller: mobile,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Mobile number'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: email,
              decoration: const InputDecoration(labelText: 'Email (optional)'),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: type,
              items: const [
                DropdownMenuItem(value: 'Borrower', child: Text('Borrower')),
                DropdownMenuItem(value: 'Lender', child: Text('Lender')),
              ],
              onChanged: (v) => setState(() => type = v!),
              decoration: const InputDecoration(labelText: 'Contact type'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        FilledButton(
          onPressed: () async {
            if (name.text.trim().isEmpty || mobile.text.trim().isEmpty) return;
            await context.read<AppProvider>().addContact(
                  Contact(
                    name: name.text.trim(),
                    mobile: mobile.text.trim(),
                    email: email.text.trim().isEmpty ? null : email.text.trim(),
                    type: type,
                  ),
                );
            if (context.mounted) Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
