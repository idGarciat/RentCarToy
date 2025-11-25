import 'package:flutter/material.dart';
import '../theme.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: const Text('Scan to Pay'),
        leading: IconButton(onPressed: () => Navigator.of(context).maybePop(), icon: const Icon(Icons.arrow_back)),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: const Color(0xFFF0F0F0)),
                child: Image.network(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuCWlW71BW6xFdOTx2ArkJYF5nFGEhmtac3xMmqFAYjsAURovrUEZzhFA4EEuNC8Q2S5QkkTzDCHMfYoDsUllC3KeypunTtidfmdGTIW7AbflgEYMN36W5CKdbakBxyK4duFPKVSwj0LXc453-EUOCwsr_thqWejGeAF0mPJU2asdpKZuoFVMDI6yw-RgLRFXLZ-sDkKkH7kjOmdN8bYSTXzH1fTJpc0xzJkAPaIXIJy7u_-yTWYn9hta-dGATBgpUMfVXsbphVLlw',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 18),
              const Text('Scan the QR code to pay', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              const Text('Use your phone\'s camera or a QR code scanner app to complete the payment.', textAlign: TextAlign.center),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                  onPressed: () => Navigator.of(context).maybePop(),
                  child: const Text('Done'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
