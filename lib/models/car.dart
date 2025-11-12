class Car {
  final String id;
  final String name;
  final String description;

  Car({required this.id, required this.name, required this.description});

  static List<Car> samples() {
    return [
      Car(id: 'c1', name: 'Mini Racer', description: 'Red toy car with good speed.'),
      Car(id: 'c2', name: 'Crawler', description: 'Blue offroad crawler toy.'),
      Car(id: 'c3', name: 'Drift King', description: 'Small drift-capable toy car.'),
    ];
  }
}
