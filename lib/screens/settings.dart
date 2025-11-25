import 'package:flutter/material.dart';
import '../theme.dart';
import 'package:rentcar/services/auth_service.dart';
import 'package:rentcar/models/user.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _push = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: const Text('Settings'),
        leading: IconButton(onPressed: () => Navigator.of(context).maybePop(), icon: const Icon(Icons.arrow_back)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile row (uses session user if available) — tappable
            InkWell(
              onTap: () => Navigator.of(context).pushNamed('/profile'),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(12)),
                child: ValueListenableBuilder<User?>(
                  valueListenable: AuthService().user,
                  builder: (context, u, _) {
                    final name = u?.name ?? 'Alex Morgan';
                    final email = u?.email ?? 'alex.morgan@email.com';
                    return Row(
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: const Color(0xFFEFEFEF),
                          child: Text(
                            name.isNotEmpty ? name[0].toUpperCase() : '?',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.primary),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                              const SizedBox(height: 4),
                              Text(email, style: const TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: Colors.grey),
                      ],
                    );
                  },
                ),
              ),
            ),

            // Account section removed per request

            // Make profile row tappable and then App Preferences
            const SizedBox(height: 16),
            // Make the profile header tappable to open Profile screen
            SizedBox(height: 0),
            const SizedBox(height: 16),
            const Text('App Preferences', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(color: Theme.of(context).canvasColor == Colors.white ? const Color(0xFFF8F9FA) : Theme.of(context).cardColor, borderRadius: BorderRadius.circular(12)),
              clipBehavior: Clip.hardEdge,
              child: Column(
                children: [
                  // Push notifications with switch
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    height: 56,
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                          child: const Icon(Icons.notifications, color: AppColors.primary),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(child: Text('Push Notifications', style: TextStyle(fontSize: 16))),
                        Switch(value: _push, onChanged: (v) => setState(() => _push = v)),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  // (Language row removed per request)
                ],
              ),
            ),

            // Logout button
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: TextButton(
                style: TextButton.styleFrom(backgroundColor: Theme.of(context).brightness == Brightness.light ? const Color(0xFFF1F3F5) : Colors.grey[800], shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                onPressed: () async {
                  await AuthService().logout();
                  Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
                },
                child: Text('Log Out', style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color, fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _settingsRow(BuildContext context, {required IconData icon, required String title, VoidCallback? onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 56,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                  child: Icon(icon, color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(title, style: const TextStyle(fontSize: 16))),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
