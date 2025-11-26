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
        title: const Text('Payment Methods'),
        leading: IconButton(onPressed: () => Navigator.of(context).maybePop(), icon: const Icon(Icons.arrow_back)),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('Payment methods placeholder — coming soon', textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
        ),
      ),
    );
  }
}
