import 'dart:convert';
import 'dart:math';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rentcar/auth/auth.dart';
import 'package:rentcar/classes/session_manager.dart';
import 'package:rentcar/models/car.dart';
import 'package:http/http.dart' as http;

class CarsService {
  DateTime lastSend = DateTime.now().subtract(const Duration(milliseconds: 200));

  final _baseUrl = dotenv.env['API_URL'];
  String? _ipCar;

  CarsService();

  void setIpCar(String ip) {
    _ipCar = ip;
  }

  String getIpCar() {
    return _ipCar ?? '';
  }

  Future<List<Car>> getAvaibleCars() async {
    try {
      Auth? auth = await SessionManager.getInstance()?.getSession();
      String token = auth?.accessToken ?? "";

      var request = http.Request("GET", Uri.parse('$_baseUrl/cars/avaibles'));
      request.headers["Accept"] = 'application/json';
      request.headers["Authorization"] = "Bearer $token";

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.body.isNotEmpty
            ? List<dynamic>.from(json.decode(response.body))
            : [];
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
      Auth? auth = await SessionManager.getInstance()?.getSession();
      String token = auth?.accessToken ?? "";
      var request = http.Request("GET", Uri.parse('$_baseUrl/cars'));
      request.headers["Accept"] = 'application/json';
      request.headers["Authorization"] = "Bearer $token";


      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.body.isNotEmpty
            ? List<dynamic>.from(json.decode(response.body))
            : [];
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

  Future<Car> getCarById(String id) async {
    try {
      Auth? auth = await SessionManager.getInstance()?.getSession();
      String token = auth?.accessToken ?? "";

      var request = http.Request("GET", Uri.parse('$_baseUrl/cars/$id'));
      request.headers["Accept"] = 'application/json';
      request.headers["Authorization"] = "Bearer $token";


      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200) {
        final dynamic data = response.body.isNotEmpty
            ? json.decode(response.body)
            : null;
        return Car.fromJson(data);
      } else {
        throw Exception('Error al obtener el coche: ${response.statusCode}');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error en traer el coche: $e');
      throw Exception('Error de conexión: $e');
    }
  }
  void sendStop() async{
    try {
      final url = Uri.parse("http://$_ipCar/stop?speed=0");
      final response = await http.get(url);
      print("RESPUESTA: ${response.body}");
    } catch (e) {
      print('Error al enviar el comando: $e');
    }
  }

  void sendCommand(double x, double y) async {
    if(DateTime.now().difference(lastSend).inMilliseconds < 150) {
      return;
    }
    lastSend = DateTime.now();

    try {
      double dist = sqrt(x * x + y * y);
      int speed = (dist * 8).clamp(0, 255).toInt();

      int xt = _normalize(x);
      int yt = _normalize(y);
      y /= 32;
      String command = "stop";
      print('$xt , $yt');
      
      if (xt == 0 && yt == 1) {
        command = "forward";
      } else if (xt == 0 && yt == -1) {
        command = "backward";
      } else if (xt == 1 && yt == 0) {
        command = "right";
      } else if (xt == -1 && yt == 0) {
        command = "left";
      } else if (xt > 0 && yt > 0) {
        command = "right";
      } else if (xt < 0 && yt > 0) {
        command = "left";
      } else if (xt > 0 && yt < 0) {
        command = "right";
      } if (xt < 0 && yt < 0) {
        command = "left";
      }

      final url = Uri.parse("http://$_ipCar/$command?speed=$speed");
      final response = await http.get(url);
      print("RESPUESTA: ${response.body}");

    } catch (e) {
      print('Error al enviar el comando: $e');
    }
  }

  int _normalize(double v) {
    if (v > 10) return 1;
    if (v < -10) return -1;
    return 0;
  }
}
