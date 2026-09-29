import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

class PinScreen extends StatefulWidget {
  const PinScreen({super.key});

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  final controller = TextEditingController();
  String message = '';

  Future<void> continueApp() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPin = prefs.getString('app_pin');

    if (savedPin == null) {
      if (controller.text.length < 4) {
        setState(() => message = 'PIN must have at least 4 digits.');
        return;
      }
      await prefs.setString('app_pin', controller.text);
      openHome();
    } else if (controller.text == savedPin) {
      openHome();
    } else {
      setState(() => message = 'Wrong PIN.');
    }
  }

  void openHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            children: [
              const Icon(Icons.account_balance_wallet, size: 72),
              const SizedBox(height: 18),
              const Text(
                'SmartInterestX',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('Loan & Interest Management'),
              const SizedBox(height: 30),
              TextField(
                controller: controller,
                obscureText: true,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'App PIN',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 12),
              if (message.isNotEmpty)
                Text(message, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: continueApp,
                  child: const Text('Continue'),
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'First time? Enter a new PIN. It will be saved on this device.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
