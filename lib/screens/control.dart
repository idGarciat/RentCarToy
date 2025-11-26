import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';
import 'package:rentcar/services/cars_service.dart';
import '../models/car.dart';

class ControlScreen extends StatefulWidget {
  final Car? car;
  const ControlScreen({super.key, this.car});

  @override
  // ignore: no_logic_in_create_state
  State<ControlScreen> createState() => _ControlScreenState(car: car);
}

class _ControlScreenState extends State<ControlScreen> {
  final _carService = CarsService();
  double _speedValue = 70;
  final List<String> _logs = [];
  final Car? car;
  _ControlScreenState({this.car}) {
    _carService.setIpCar(car?.ip ?? "127.0.0.1");
    _carService.setSpeedCar(_speedValue.toInt());
  }

  // Joystick state for game-like controls
  Offset _joyOffset = Offset.zero;
  final double _joyMax = 32.0; // maximum thumb displacement (smaller)

  void _send(String cmd) {
    final entry =
        '${DateTime.now().toIso8601String().substring(11, 19)}: $cmd @ speed ${_speedValue.toStringAsFixed(0)}%';
    // print(  entry);

    //TODO
    //implemtar el las llamdas al coche

    setState(() {
      _logs.insert(0, entry);
    });
  }

  // Small circular icon button used in the top bar
  Widget _iconCircleButton(IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 44,
        height: 44,
        // ignore: deprecated_member_use
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }

  Widget _statsCard(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      // ignore: deprecated_member_use
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(color: Colors.white70)),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  // Build a smooth, game-like joystick. Returns a widget with gesture handling.
  Widget _buildJoystick() {
    return GestureDetector(
      onPanStart: (details) {
        // no-op; begin tracking
      },
      onPanUpdate: (details) {
        // Convert delta to local offset and clamp inside _joyMax
        setState(() {
          _joyOffset += details.delta;
          if (_joyOffset.distance > _joyMax) {
            _joyOffset = Offset.fromDirection(_joyOffset.direction, _joyMax);
          }
          // Send continuous command (directional)
          final dx = _joyOffset.dx;
          final dy = -_joyOffset.dy; // invert Y to match typical forward = up
          _send('JOY ${dx.toStringAsFixed(0)},${dy.toStringAsFixed(0)}');
          _carService.sendDirection(dx, dy);
        });
      },
      onPanEnd: (details) {
        // release -> animate back to center
        setState(() {
          _joyOffset = Offset.zero;
          _carService.sendStop();
        });
      },
      child: SizedBox(
        width: 120,
        height: 120,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Base
            Container(
              width: 120,
              height: 120,
              // ignore: deprecated_member_use
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.03),
                border: Border.all(color: Colors.white.withOpacity(0.06)),
              ),
            ),
            // Direction markers
            Positioned(
              top: 10,
              child: Icon(Icons.arrow_drop_up, color: Colors.white24, size: 24),
            ),
            Positioned(
              bottom: 10,
              child: Icon(
                Icons.arrow_drop_down,
                color: Colors.white24,
                size: 24,
              ),
            ),
            Positioned(
              left: 10,
              child: Icon(Icons.arrow_left, color: Colors.white24, size: 24),
            ),
            Positioned(
              right: 10,
              child: Icon(Icons.arrow_right, color: Colors.white24, size: 24),
            ),
            // Thumb (animated)
            Transform.translate(
              offset: _joyOffset,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 80),
                curve: Curves.easeOut,
                width: 48,
                height: 48,
                // ignore: deprecated_member_use
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.navigation,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Force landscape orientation while on the control screen (matches horizontal_example.dart)
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void dispose() {
    // Restore portrait orientations when leaving the screen
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final stream = 'http://${_carService.getIpCar()}:81/stream';
    // slider uses state variable `_speedValue`
    print(stream);

    final background = Positioned.fill(
      child: Mjpeg(
        isLive: true,
        fit: BoxFit.cover,
        stream: stream,
        error: (context, error, stackTrace) {
          return Center(
            child: Text(
              'No hay video we',
              style: TextStyle(
                // ignore: deprecated_member_use
                color: Colors.white.withOpacity(0.8),
                fontSize: 16,
              ),
            ),
          );
        },
      ),
    );

    // Gradient overlay to improve readability of controls
    final gradient = Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withOpacity(0.7),
              Colors.black.withOpacity(0.15),
              Colors.transparent,
            ],
            stops: const [0.0, 0.35, 1.0],
          ),
        ),
      ),
    );

    // Top app bar overlay (back, timer, help)
    final topBar = Positioned(
      top: 16,
      left: 16,
      right: 16,
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _iconCircleButton(
              Icons.arrow_back,
              () => Navigator.of(context).maybePop(),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Time Left: 08:30',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            _iconCircleButton(Icons.help_outline, () {}),
          ],
        ),
      ),
    );

    // Stats overlay (battery & speed)
    final statsOverlay = Positioned(
      bottom: size.height * 0.45,
      left: 20,
      right: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [_statsCard(Icons.speed, 'Speed', '-')],
      ),
    );

    // Bottom controls layer
    final bottomControls = Positioned(
      left: 12,
      right: 12,
      bottom: 12,
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left: actions + joystick
            SizedBox(
              width: size.width * 0.38,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Game-like joystick (replaces action buttons)
                  _buildJoystick(),
                  const SizedBox(height: 6),
                ],
              ),
            ),

            // Center: End Session (smaller)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[600],
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 6,
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'End',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            // Right: pedals
            SizedBox(
              width: size.width * 0.38,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // const SizedBox(width: 12),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Brake',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        height: 64,
                        width: 56,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.12),
                          ),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.emergency,
                            color: Colors.white,
                            size: 24,
                          ),
                          onPressed: () => _carService.sendDirection(0, 0),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Go',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 6),
                      Container(
                        height: 88,
                        width: 68,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.keyboard_arrow_up,
                            color: Colors.white,
                            size: 28,
                          ),
                          onPressed: () =>_carService.sendForwarding(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  RotatedBox(
                    quarterTurns: -1,
                    child: Slider(
                      min: 0,
                      max: 100,
                      divisions: 10,
                      value: _speedValue,
                      onChanged: (double value) {
                        setState(() {
                          _speedValue = value;
                          _carService.setSpeedCar(value.toInt());
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [background, gradient, topBar, statsOverlay, bottomControls],
      ),
    );
  }
}