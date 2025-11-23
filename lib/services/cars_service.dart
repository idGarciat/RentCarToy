import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rentcar/models/car.dart';
import 'package:http/http.dart' as http;

class CarsService {
  final _baseUrl = dotenv.env['API_URL'];

  Future<List<Car>> getAvaibleCars() async {
    try {
      var request = http.Request("GET", Uri.parse('$_baseUrl/cars/avibles'));
      request.headers["Accept"] = 'application/json';

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200) {
        
        final List<dynamic> data = response.body.isNotEmpty ? List<dynamic>.from(json.decode(response.body)) : [];
        return data.map((json) => Car.fromJson(json)).toList();

      } else {
        throw Exception('Error al obtener los coches: ${response.statusCode}');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error en traer los coches: $e');
      throw Exception('Error de conexión: $e');
    }
  }

  Future<List<Car>> getCars() async {
    try {
      var request = http.Request("GET", Uri.parse('$_baseUrl/cars'));
      request.headers["Accept"] = 'application/json';

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200) {
        
        final List<dynamic> data = response.body.isNotEmpty ? List<dynamic>.from(json.decode(response.body)) : [];
        return data.map((json) => Car.fromJson(json)).toList();

      } else {
        throw Exception('Error al obtener los coches: ${response.statusCode}');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error en traer los coches: $e');
      throw Exception('Error de conexión: $e');
    }
  }
}
