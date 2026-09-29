import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/database_helper.dart';
import 'services/notification_service.dart';
import 'providers/app_provider.dart';
import 'screens/home_screen.dart';
import 'screens/pin_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initialize();
  await DatabaseHelper.instance.database;

  runApp(
    ChangeNotifierProvider(
      create: (_) => AppProvider()..loadData(),
      child: const SmartInterestXApp(),
    ),
  );
}

class SmartInterestXApp extends StatelessWidget {
  const SmartInterestXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SmartInterestX',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xfff7f7fb),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: const PinScreen(),
    );
  }
}
