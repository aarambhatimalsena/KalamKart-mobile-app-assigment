import 'package:flutter/material.dart';

class PayoutScreen extends StatelessWidget {
  final double total;

  const PayoutScreen({super.key, required this.total});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1B2E),
      appBar: AppBar(
        title: const Text("Choose Payment Method"),
        backgroundColor: const Color(0xFF0A1B2E),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Total to pay: NPR ${total.toStringAsFixed(2)}",
              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            _buildPaymentOption(context, 'eSewa', Icons.phone_android, Colors.green.shade400),
            const SizedBox(height: 20),
            _buildPaymentOption(context, 'Khalti', Icons.account_balance_wallet, Colors.purple.shade400),
            const SizedBox(height: 20),
            _buildPaymentOption(context, 'Bank Transfer', Icons.account_balance, Colors.blue.shade400),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(BuildContext context, String method, IconData icon, Color color) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$method payment option selected (demo only).')),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 28, color: Colors.white),
            const SizedBox(width: 16),
            Text(
              method,
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
