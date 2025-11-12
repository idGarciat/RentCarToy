import 'package:flutter/material.dart';
import '../services/auth.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final username = AuthService.user.value?.username ?? 'Guest';
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, title: const Text('Find a Car')),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(username),
              accountEmail: Text(AuthService.user.value?.email ?? ''),
            ),
            ListTile(
              leading: const Icon(Icons.directions_car),
              title: const Text('Available Cars'),
              onTap: () => Navigator.of(context).pushNamed('/cars'),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile / Settings'),
              onTap: () => Navigator.of(context).pushNamed('/profile'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                AuthService.logout();
                Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
              },
            )
          ],
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [
            // top map placeholder
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.grey.shade300,
                  image: const DecorationImage(image: NetworkImage('https://placeholder.pics/svg/600'), fit: BoxFit.cover),
                ),
              ),
            ),
            // Search
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                decoration: InputDecoration(prefixIcon: const Icon(Icons.search), hintText: 'Search for a specific car model'),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                children: [
                  // sample cards - keep similar content as before
                  for (var c in [
                    {'name': 'CyberRacer X1', 'battery': '92%', 'distance': '50m away', 'price': '\$0.30/min'},
                    {'name': 'Nitro Buggy', 'battery': '75%', 'distance': '120m away', 'price': '\$0.25/min'},
                    {'name': 'Street Phantom', 'battery': '25%', 'distance': '250m away', 'price': '\$0.20/min'},
                  ])
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Container(
                        decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)]),
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Row(children: [const Icon(Icons.battery_full, color: Colors.green), const SizedBox(width: 6), Text('Battery: ${c['battery']}', style: const TextStyle(color: Colors.grey))]),
                                const SizedBox(height: 8),
                                Text(c['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text('${c['distance']} · ${c['price']}', style: const TextStyle(color: Colors.grey)),
                                const SizedBox(height: 8),
                                ElevatedButton(onPressed: () => Navigator.of(context).pushNamed('/control', arguments: null), child: const Text('Rent Now'))
                              ]),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 1,
                              child: Container(
                                height: 90,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.grey.shade200),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
