import 'package:flutter/material.dart';
import '../theme.dart';

class RentalHistoryScreen extends StatelessWidget {
  const RentalHistoryScreen({super.key});
//Esto son solo placeholders de items, no hay backend ni nada implementado aun
  @override
  Widget build(BuildContext context) {
    // sample items similar to HTML
    final items = [
      {'name': 'Red Racer GT', 'date': 'June 15, 2023', 'time': '45 min', 'price': '\$12.50'},
      {'name': 'Monster Truck X', 'date': 'June 10, 2023', 'time': '1 hour', 'price': '\$15.00'},
      {'name': 'Classic Cruiser', 'date': 'May 28, 2023', 'time': '30 min', 'price': '\$8.00'},
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: const Text('Rental History'),
        leading: IconButton(onPressed: () => Navigator.of(context).maybePop(), icon: const Icon(Icons.arrow_back)),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, idx) {
          final it = items[idx];
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                Container(width: 72, height: 72, decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColors.backgroundLight)),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(it['name']!, style: const TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height: 6), Text('${it['date']} - ${it['time']}', style: const TextStyle(color: Colors.grey))])),
                const SizedBox(width: 8),
                Text(it['price']!, style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          );
        },
      ),
    );
  }
}
