import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../services/auth_service.dart';
import '../theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  final AuthService _authService = AuthService();
  
  bool _loading = false;
  String? _error;
  bool _obscure = true;

  @override
  void dispose() {
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }

  Future<void> _doLogin() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final ok = await _authService.login(
      _userController.text,
      _passController.text,
    );
    if (!mounted) return;
    setState(() => _loading = false);
    if (ok) {
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      setState(() => _error = 'Login failed — check credentials');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Container(
              decoration: BoxDecoration(
                color: theme.cardColor.withOpacity(0.85),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 12,
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo circle
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Icon(
                      Icons.directions_car,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Welcome Back!',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Log in to continue your adventure.',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 18),

                  // Email or Username
                  TextField(
                    controller: _userController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: 'Enter your email or username',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Password
                  TextField(
                    controller: _passController,
                    obscureText: _obscure,
                    decoration: InputDecoration(
                      hintText: 'Enter your password',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      suffixIcon: IconButton(
                        onPressed: () => setState(() => _obscure = !_obscure),
                        icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                        onPressed: () => Navigator.of(context).pushNamed('/forgot'),
                      style: TextButton.styleFrom(foregroundColor: AppColors.primary),
                      child: const Text('Forgot Password?'),
                    ),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 8),
                    Text(_error!, style: const TextStyle(color: Colors.red)),
                  ],
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _doLogin,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        backgroundColor: AppColors.primary,
                        textStyle: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      child: _loading
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Log In'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const SizedBox(height: 12),
                  Center(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: "Don't have an account? ", style: TextStyle(color: Colors.grey[600])),
                          TextSpan(
                            text: 'Sign Up',
                            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                            recognizer: TapGestureRecognizer()..onTap = () => Navigator.of(context).pushNamed('/register'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
