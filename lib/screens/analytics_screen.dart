import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../services/interest_service.dart';
import '../utils/app_format.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final transactions = context.watch<AppProvider>().transactions;

    int given = transactions.where((t) => t.type == 'Given').length;
    int taken = transactions.where((t) => t.type == 'Taken').length;

    double monthlyInterest = 0;
    for (final t in transactions) {
      monthlyInterest += InterestService.interestTillDate(
        principal: t.amount,
        rate: t.rate,
        rateType: t.rateType,
        startDate: t.startDate,
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Analytics',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 18),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              height: 220,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: given.toDouble(),
                      title: 'Given\n$given',
                      radius: 75,
                    ),
                    PieChartSectionData(
                      value: taken.toDouble(),
                      title: 'Taken\n$taken',
                      radius: 75,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            leading: const Icon(Icons.show_chart),
            title: const Text('Interest flow'),
            subtitle: const Text(
              'This simple chart uses the current stored transactions. '
              'Monthly/yearly filtering can be expanded later.',
            ),
            trailing: Text(AppFormat.money(monthlyInterest)),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'PDF filter requirements',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Text('Month • Year • Contact'),
      ],
    );
  }
}
