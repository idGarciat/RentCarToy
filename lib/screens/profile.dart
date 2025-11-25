// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:rentcar/auth/auth.dart';
import 'package:rentcar/classes/session_manager.dart';
import '../services/auth_service.dart';
import '../theme.dart';
import 'rental_history.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  final SessionManager _sessionManager = SessionManager();
  Auth? auth;
  bool _editing = false;
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _usernameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  String? _nameError;
  String? _usernameError;
  String? _emailError;

  @override
  void initState() {
    super.initState();
    _loadSession();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map && args['edit'] == true) {
      // open in edit mode
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() => _editing = true);
      });
    }
  }

  Future<void> _loadSession() async {
    auth = await _sessionManager.getSession();
    _nameCtrl.text = auth?.user?.name ?? '';
    _usernameCtrl.text = auth?.user?.username ?? '';
    _emailCtrl.text = auth?.user?.email ?? '';
    setState(() {});
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = auth?.user;
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile header / editor
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).cardColor,
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: Colors.grey.shade300,
                      child: Text(
                        (user?.name.isNotEmpty == true ? user!.name[0].toUpperCase() : '?'),
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () => setState(() => _editing = !_editing),
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: AppColors.primary,
                          child: Icon(_editing ? Icons.close : Icons.edit, size: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (!_editing) ...[
                  Text(
                    user?.name ?? '',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.charcoal,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    user?.email ?? '',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit Profile'),
                      onPressed: () => setState(() => _editing = true),
                    ),
                  ),
                ] else ...[
                  // editable fields
                  TextField(
                    controller: _nameCtrl,
                    decoration: InputDecoration(labelText: 'Full name', errorText: _nameError, filled: true, fillColor: Theme.of(context).cardColor, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _usernameCtrl,
                    decoration: InputDecoration(labelText: 'Username', errorText: _usernameError, filled: true, fillColor: Theme.of(context).cardColor, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _emailCtrl,
                    decoration: InputDecoration(labelText: 'Email', errorText: _emailError, filled: true, fillColor: Theme.of(context).cardColor, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _passwordCtrl,
                    decoration: InputDecoration(labelText: 'New password (leave blank to keep)', filled: true, fillColor: Theme.of(context).cardColor, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                    obscureText: true,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                          onPressed: _saveProfile,
                          child: const Text('Save Changes'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // revert fields
                            _nameCtrl.text = auth?.user?.name ?? '';
                            _usernameCtrl.text = auth?.user?.username ?? '';
                            _emailCtrl.text = auth?.user?.email ?? '';
                            _passwordCtrl.clear();
                            setState(() => _editing = false);
                          },
                          child: const Text('Cancel'),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: const [
                        Text(
                          '12',
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Total Rentals',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: const [
                        Text(
                          '48',
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Hours Driven',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary.withOpacity(0.15),
                    child: const Icon(Icons.credit_card, color: AppColors.primary),
                  ),
                  title: const Text('Payment Methods'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context).pushNamed('/payment'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary.withOpacity(0.15),
                    child: const Icon(Icons.history, color: AppColors.primary),
                  ),
                  title: const Text('Rental History'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RentalHistoryScreen())),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary.withOpacity(0.15),
                    child: const Icon(Icons.help_outline, color: AppColors.primary),
                  ),
                  title: const Text('Help & Support'),
                  trailing: const Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              onPressed: () {
                _authService.logout();
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/login', (_) => false);
              },
              child: const Text('Log Out'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveProfile() async {
    final name = _nameCtrl.text.trim();
    final username = _usernameCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text;

    // basic validation
    if (name.isEmpty || username.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Name, username and email are required')));
      return;
    }
    final emailOk = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+').hasMatch(email);
    if (!emailOk) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter a valid email')));
      return;
    }

    // Call backend to persist changes (update profile fields)
    final current = await _sessionManager.getSession();
    if (current == null || current.user == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No active session')));
      return;
    }

    setState(() {
      _nameError = null;
      _usernameError = null;
      _emailError = null;
    });

    final id = current.user!.id;
    final res = await _authService.updateProfile(id, name: name, username: username, email: email, password: null);

    if (res['ok'] == true) {
      final updated = await _sessionManager.getSession();
      setState(() {
        auth = updated;
        _editing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated')));
      // if user wants to change password, prompt for current password and call changePassword
      if (password.isNotEmpty) {
        await _askCurrentAndChange(password);
      }
    } else {
      final msg = (res['message'] ?? 'Could not update profile').toString();
      // Try to map common messages to field errors
      final lower = msg.toLowerCase();
      setState(() {
        if (lower.contains('email')) _emailError = msg;
        if (lower.contains('username')) _usernameError = msg;
        if (lower.contains('name')) _nameError = msg;
      });
      if (_emailError == null && _usernameError == null && _nameError == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      }
    }
  }

  Future<void> _askCurrentAndChange(String newPassword) async {
    final TextEditingController currentCtrl = TextEditingController();
    final res = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Change Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Current password'),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                if (currentCtrl.text.isEmpty) return;
                Navigator.of(ctx).pop(true);
              },
              child: const Text('Change'),
            ),
          ],
        );
      },
    );

    if (res == true) {
      final currentPass = currentCtrl.text;
      final resp = await _authService.changePassword(currentPass, newPassword);
      if (resp['ok'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password changed successfully')));
      } else {
        final msg = (resp['message'] ?? 'Could not change password').toString();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      }
      _passwordCtrl.clear();
      currentCtrl.dispose();
    }
  }
}
