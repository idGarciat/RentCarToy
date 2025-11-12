import 'package:flutter/material.dart';
import '../models/car.dart';

class CarsScreen extends StatelessWidget {
  const CarsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cars = Car.samples();
    return Scaffold(
      appBar: AppBar(title: const Text('Available Cars')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: cars.length,
        itemBuilder: (context, idx) {
          final car = cars[idx];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(width: 100, height: 80, decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.grey.shade300)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(car.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text(car.description, style: const TextStyle(color: Colors.grey)),
                      const SizedBox(height: 8),
                      Row(children: [
                        ElevatedButton(onPressed: () => Navigator.of(context).pushNamed('/control', arguments: car), child: const Text('Control')),
                        const SizedBox(width: 8),
                        OutlinedButton(onPressed: () {}, child: const Text('Details'))
                      ])
                    ]),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
