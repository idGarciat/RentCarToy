import 'package:rentcar/models/store.dart';

class Car {
  final String id;
  final String name;
  final String description;
  final String image;
  final String ip;
  final double price;
  // ignore: non_constant_identifier_names
  final bool is_avaible;
  final Store? store;

  // ignore: non_constant_identifier_names
  Car({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.ip,
    required this.price,
    // ignore: non_constant_identifier_names
    required this.is_avaible,
    required this.store,
  });

  static List<Car> samples() {
    return [
      Car(
        id: 'c1',
        name: 'Mini Racer',
        description: 'Red toy car with good speed.',
        image: 'assets/car_red.png',
        ip: '192.168.100.124',
        price: 29.99,
        is_avaible: true,
        store: Store(
          id: 's1',
          name: 'Toy Store',
          description: 'Best toy store in town',
          image: 'assets/store.png',
          location: '123 Toy St',
        ),
      ),
      Car(
        id: 'c2',
        name: 'Crawler',
        description: 'Blue offroad crawler toy.',
        image: 'assets/car_blue.png',
        ip: '192.168.100.124',
        price: 39.99,
        is_avaible: true,
        store: Store(
          id: 's2',
          name: 'Outdoor Toys',
          description: 'Outdoor and adventure toys',
          image: 'assets/store2.png',
          location: '456 Adventure Rd',
        ),
      ),
      Car(
        id: 'c3',
        name: 'Drift King',
        description: 'Small drift-capable toy car.',
        image: 'assets/car_drift.png',
        ip: '192.168.100.124',
        price: 49.99,
        is_avaible: false,
        store: Store(
          id: 's3',
          name: 'Racing Toys',
          description: 'High-speed racing toys',
          image: 'assets/store3.png',
          location: '789 Speed Ave',
        ),
      ),
    ];
  }

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      ip: json['ip']?.toString() ?? '',
      price: json['price'] is num
          ? (json['price'] as num).toDouble()
          : double.tryParse(json['price']?.toString() ?? '') ?? 0.0,
      is_avaible: json['is_avaible'] == null
          ? false
          : (json['is_avaible'] is bool
              ? json['is_avaible'] as bool
              : (json['is_avaible'].toString() == '1' || json['is_avaible'].toString().toLowerCase() == 'true')),
      store: json['store'] != null ? Store.fromJson(json['store']) : null,
    );
  }
}
