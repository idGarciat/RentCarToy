import 'package:flutter/material.dart';
import '../theme.dart';
import '../models/car.dart';

class QrPaymentConfirmationScreen extends StatelessWidget {
  final double amount;
  const QrPaymentConfirmationScreen({super.key, this.amount = 5.0});

  @override
  Widget build(BuildContext context) {
    final car = ModalRoute.of(context)?.settings.arguments as Car?;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: const Text('Confirm Payment'),
        leading: IconButton(onPressed: () => Navigator.of(context).maybePop(), icon: const Icon(Icons.arrow_back)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.15), borderRadius: BorderRadius.circular(48)),
              child: const Icon(Icons.qr_code_scanner, color: AppColors.primary, size: 48),
            ),
            const SizedBox(height: 12),
            Text('\$${(car?.price ?? 5.0).toStringAsFixed(2)}', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            const Text('Total Rental Cost', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Car ID', style: TextStyle(color: Colors.grey)), Text(/*car?.id ??*/ 'Unknown')]),//Actualmente muestra la ID pero encriptada, cambiar eso. o no
                    const Divider(),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [Text('Rental Duration', style: TextStyle(color: Colors.grey)), Text('15 Minutes')]),
                    const SizedBox(height: 8),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Paying with', style: TextStyle(color: Colors.grey)), const Text('**** 1234')]),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.flag),
                label: const Text('Confirm & Start Race'),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                onPressed: () => Navigator.of(context).pushNamed('/control', arguments: car),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
