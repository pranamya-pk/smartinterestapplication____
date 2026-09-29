import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../services/interest_service.dart';
import '../utils/app_format.dart';
import 'add_transaction_screen.dart';
import 'contacts_screen.dart';
import 'transaction_detail_screen.dart';
import 'analytics_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int tab = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const DashboardTab(),
      const ContactsScreen(),
      const AnalyticsScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartInterestX'),
      ),
      body: pages[tab],
      floatingActionButton: tab == 0
          ? FloatingActionButton.extended(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AddTransactionScreen(),
                ),
              ),
              icon: const Icon(Icons.add),
              label: const Text('Transaction'),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (value) => setState(() => tab = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.people), label: 'Contacts'),
          NavigationDestination(icon: Icon(Icons.bar_chart), label: 'Analytics'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    double earned = 0;
    double paid = 0;
    double receivable = 0;
    double payable = 0;

    for (final t in provider.transactions) {
      final interest = InterestService.interestTillDate(
        principal: t.amount,
        rate: t.rate,
        rateType: t.rateType,
        startDate: t.startDate,
      );

      if (t.type == 'Given') {
        earned += interest;
        receivable += t.amount + interest;
      } else {
        paid += interest;
        payable += t.amount + interest;
      }
    }

    return RefreshIndicator(
      onRefresh: provider.loadData,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Overview',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _card('Interest Earned', earned, Icons.trending_up),
              _card('Interest Paid', paid, Icons.trending_down),
              _card('Receivables', receivable, Icons.call_received),
              _card('Payables', payable, Icons.call_made),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Transactions',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text('${provider.transactions.length} total'),
            ],
          ),
          const SizedBox(height: 8),
          if (provider.transactions.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'No transactions yet.\nTap + Transaction to add your first loan.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ...provider.transactions.map(
            (t) {
              final contact = provider.findContact(t.contactId);
              final interest = InterestService.interestTillDate(
                principal: t.amount,
                rate: t.rate,
                rateType: t.rateType,
                startDate: t.startDate,
              );

              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    child: Icon(
                      t.type == 'Given'
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
                    ),
                  ),
                  title: Text(contact?.name ?? 'Unknown contact'),
                  subtitle: Text(
                    '${t.type} • ${AppFormat.money(t.amount)} • ${t.rate}% ${t.rateType}',
                  ),
                  trailing: Text(
                    AppFormat.money(interest),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TransactionDetailScreen(transaction: t),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _card(String title, double value, IconData icon) {
    return SizedBox(
      width: 175,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon),
              const SizedBox(height: 8),
              Text(title),
              const SizedBox(height: 5),
              Text(
                AppFormat.money(value),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
