class Store {
  final String id;
  final String name;
  final String description;
  final String image;
  final String location;
  Store({required this.id, required this.name, required this.description, required this.image, required this.location});
  
  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
      location: json['location'],
    );
  }
}