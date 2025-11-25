import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HorizontalScreen extends StatefulWidget {
  const HorizontalScreen({super.key});

  @override
  _HorizontalScreenState createState() => _HorizontalScreenState();
}

class _HorizontalScreenState extends State<HorizontalScreen> {
  @override
  void initState() {
    super.initState();
    // Forzar orientación horizontal al entrar
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void dispose() {
    // Restaurar orientación al salir
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Vista Horizontal')),
      body: Center(
        child: Text('Esta pantalla está en horizontal'),
      ),
    );
  }
}
