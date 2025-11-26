import 'package:flutter/material.dart';
import 'package:rentcar/services/cars_service.dart';
import '../models/car.dart';
import '../theme.dart';

class CarsScreen extends StatefulWidget {
  const CarsScreen({super.key});

  @override
  State<CarsScreen> createState() => _CarsScreenState();
}

class _CarsScreenState extends State<CarsScreen> {
  final CarsService _carService = CarsService();
  final TextEditingController _searchCtrl = TextEditingController();
  List<Car> _allCars = [];
  List<Car> _filteredCars = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Available Cars')),
      body: FutureBuilder<List<Car>>(
        future: _carService.getAvaibleCars(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            // return Center(child: Text("Error: ${snapshot.error}"));
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Error'),
                    content: Text('Error en traer coches: ${snapshot.error}'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          setState(() {});
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            });
            
            return const SizedBox.shrink();
          }

          final cars = snapshot.data ?? [];

          // initialize lists only once when data is first available
          if (_allCars.isEmpty) {
            _allCars = List.from(cars);
            _filteredCars = List.from(cars);
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                child: TextField(
                  controller: _searchCtrl,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Search cars...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                  ),
                  onChanged: (q) {
                    final query = q.toLowerCase().trim();
                    setState(() {
                      if (query.isEmpty) {
                        _filteredCars = List.from(_allCars);
                      } else {
                        _filteredCars = _allCars.where((c) {
                          final name = c.name.toLowerCase();
                          final desc = (c.description ?? '').toLowerCase();
                          final loc = (c.store?.location ?? '').toLowerCase();
                          return name.contains(query) || desc.contains(query) || loc.contains(query);
                        }).toList();
                      }
                    });
                  },
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _filteredCars.length,
                  itemBuilder: (context, idx) {
                    final car = _filteredCars[idx];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                // Price and location (model doesn't provide battery)
                                Row(children: [
                                  const Icon(Icons.monetization_on, color: Colors.green),
                                  const SizedBox(width: 6),
                                  Text('\$${car.price.toStringAsFixed(2)}', style: const TextStyle(color: Colors.grey)),
                                  const SizedBox(width: 12),
                                  const Icon(Icons.location_on, color: Colors.grey),
                                  const SizedBox(width: 6),
                                  Expanded(child: Text(car.store?.location ?? 'Unknown', style: const TextStyle(color: Colors.grey))),
                                ]),
                                const SizedBox(height: 8),
                                Text(car.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text(car.description, style: const TextStyle(color: Colors.grey)),
                                const SizedBox(height: 8),
                                Row(children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                                    onPressed: () => Navigator.of(context).pushNamed('/payment_qr', arguments: car),
                                    child: const Text('Control'),
                                  ),
                                  const SizedBox(width: 8),
                                  OutlinedButton(onPressed: () {}, child: const Text('Details')),
                                ])
                              ]),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 1,
                              child: Container(
                                height: 90,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: const Color(0xFFF6F7F8)),
                                child: const SizedBox.shrink(),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
