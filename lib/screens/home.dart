import 'package:flutter/material.dart';
import 'package:rentcar/auth/auth.dart';
import 'package:rentcar/classes/session_manager.dart';
import '../services/auth_service.dart';
import '../theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  final SessionManager _sessionManager = SessionManager();
  Auth? auth;

  @override
  void initState() {
    super.initState();
    _loadSession();
  }

  Future<void> _loadSession() async {
    auth = await _sessionManager.getSession();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final username = auth?.user?.username ?? 'Universitario Desconocido';
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Column(
              children: [
                // Header
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Builder(builder: (ctx) {
                              String initial = 'U';
                              final name = auth?.user?.name;
                              if (name != null && name.isNotEmpty) initial = name[0].toUpperCase();
                              return CircleAvatar(
                                radius: 24,
                                backgroundColor: AppColors.primary,
                                child: Text(initial, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              );
                            }),
                            const SizedBox(width: 12),
                            Text('Hi, ${auth?.user?.name ?? 'there'}!', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.notifications),
                        )
                      ],
                    ),
                  ),
                ),

                // Banner
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Container(
                    height: 220,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      image: const DecorationImage(
                        image: NetworkImage('http://192.168.100.35:3000/files/images/uploads/car2.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        gradient: LinearGradient(colors: [Colors.black.withOpacity(0.65), Colors.transparent], begin: Alignment.bottomCenter, end: Alignment.topCenter),
                      ),
                      padding: const EdgeInsets.all(16),
                      alignment: Alignment.bottomLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Ready for an Adventure?', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(height: 6),
                          Text('Rent and control your favorite toy cars instantly.', style: TextStyle(color: Colors.white70)),
                        ],
                      ),
                    ),
                  ),
                ),

                // Quick cards
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _quickCard(Icons.electric_car, 'Available Cars', 'Find a ride near you', () => Navigator.of(context).pushNamed('/cars')),
                      _quickCard(Icons.person, 'User Profile', 'View your rental history', () => Navigator.of(context).pushNamed('/profile')),
                      _quickCard(Icons.settings, 'Settings', 'Manage your preferences', () => Navigator.of(context).pushNamed('/settings')),
                    ],
                  ),
                ),

                // Current Rental header
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Align(alignment: Alignment.centerLeft, child: Text('Current Rental', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                ),

                // Current Rental card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6)]),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            const Text('Active Rental', style: TextStyle(color: Colors.grey)),
                            const SizedBox(height: 6),
                            const Text('RC Speedster X', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 6),
                            const Text('Time remaining: 02:30:15', style: TextStyle(color: Colors.grey)),
                            const SizedBox(height: 10),
                            ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary), onPressed: () => Navigator.of(context).pushNamed('/control'), child: const Text('Control Car'))
                          ]),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 1,
                          child: Container(height: 110, decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: const DecorationImage(image: NetworkImage('http://192.168.100.35:3000/files/images/uploads/car1.png'), fit: BoxFit.cover))),
                        )
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 80),
              ],
            ),
          ),

          // bottom nav (sticky)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.95),
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _bottomNavItem(Icons.home, 'Home', true),
                  _bottomNavItem(Icons.explore, 'Map', false, onTap: () => Navigator.of(context).pushNamed('/cars')), // map placeholder -> cars
                  _bottomNavItem(Icons.person, 'Profile', false, onTap: () => Navigator.of(context).pushNamed('/profile')),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _quickCard(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Theme.of(context).cardColor, border: Border.all(color: Colors.grey.shade200)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: AppColors.primary, size: 28),
              const SizedBox(height: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomNavItem(IconData icon, String label, bool active, {VoidCallback? onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: active ? AppColors.primary : Colors.grey),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(color: active ? AppColors.primary : Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
