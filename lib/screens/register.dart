import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../theme.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _name = TextEditingController();
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _pass2 = TextEditingController();
  bool _loading = false;
  bool _passObscure = true;
  bool _pass2Obscure = true;
  // inline validation state
  String? _nameError;
  String? _usernameError;
  String? _emailError;
  String? _passError;
  String? _pass2Error;

  Timer? _nameDebounce;
  Timer? _usernameDebounce;
  Timer? _emailDebounce;
  Timer? _passDebounce;
  Timer? _pass2Debounce;

  @override
  void dispose() {
    _name.dispose();
    _username.dispose();
    _email.dispose();
    _pass.dispose();
    _pass2.dispose();
    _nameDebounce?.cancel();
    _usernameDebounce?.cancel();
    _emailDebounce?.cancel();
    _passDebounce?.cancel();
    _pass2Debounce?.cancel();
    super.dispose();
  }

  void _validateName() {
    final v = _name.text.trim();
    setState(() => _nameError = v.isEmpty ? 'Full name is required' : null);
  }

  void _validateUsername() {
    final v = _username.text.trim();
    setState(() => _usernameError = v.isEmpty ? 'Username is required' : null);
  }

  void _validateEmail() {
    final v = _email.text.trim();
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+').hasMatch(v);
    setState(() => _emailError = v.isEmpty ? 'Email is required' : (ok ? null : 'Enter a valid email'));
  }

  void _validatePass() {
    final v = _pass.text;
    setState(() => _passError = v.length < 6 ? 'Password must be at least 6 characters' : null);
  }

  void _validatePass2() {
    final v = _pass2.text;
    setState(() => _pass2Error = v != _pass.text ? 'Passwords do not match' : null);
  }

  bool _validateAllNow() {
    _nameDebounce?.cancel();
    _usernameDebounce?.cancel();
    _emailDebounce?.cancel();
    _passDebounce?.cancel();
    _pass2Debounce?.cancel();

    final nameVal = _name.text.trim();
    final usernameVal = _username.text.trim();
    final emailVal = _email.text.trim();
    final passVal = _pass.text;
    final pass2Val = _pass2.text;

    final emailOk = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+').hasMatch(emailVal);

    final nameErr = nameVal.isEmpty ? 'Full name is required' : null;
    final usernameErr = usernameVal.isEmpty ? 'Username is required' : null;
    final emailErr = emailVal.isEmpty ? 'Email is required' : (emailOk ? null : 'Enter a valid email');
    final passErr = passVal.length < 6 ? 'Password must be at least 6 characters' : null;
    final pass2Err = pass2Val != passVal ? 'Passwords do not match' : null;

    setState(() {
      _nameError = nameErr;
      _usernameError = usernameErr;
      _emailError = emailErr;
      _passError = passErr;
      _pass2Error = pass2Err;
    });

    return nameErr == null && usernameErr == null && emailErr == null && passErr == null && pass2Err == null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: const Text('Create Account'),
        leading: IconButton(onPressed: () => Navigator.of(context).maybePop(), icon: const Icon(Icons.arrow_back)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              // Full Name
              const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text('Full Name', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
              TextField(
                controller: _name,
                decoration: InputDecoration(
                  hintText: 'Enter your full name',
                  errorText: _nameError,
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                ),
                onChanged: (s) {
                  _nameDebounce?.cancel();
                  _nameDebounce = Timer(const Duration(milliseconds: 300), _validateName);
                },
              ),
              const SizedBox(height: 12),
              // Username
              const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text('Username', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
              TextField(
                controller: _username,
                decoration: InputDecoration(
                  hintText: 'Choose a username',
                  errorText: _usernameError,
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                ),
                onChanged: (s) {
                  _usernameDebounce?.cancel();
                  _usernameDebounce = Timer(const Duration(milliseconds: 300), _validateUsername);
                },
              ),
              const SizedBox(height: 12),
              // Email Address
              const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text('Email Address', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
              TextField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Enter your email address',
                  errorText: _emailError,
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                ),
                onChanged: (s) {
                  _emailDebounce?.cancel();
                  _emailDebounce = Timer(const Duration(milliseconds: 300), _validateEmail);
                },
              ),
              const SizedBox(height: 12),
              // Password
              const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text('Password', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _pass,
                      obscureText: _passObscure,
                      decoration: InputDecoration(
                        hintText: 'Enter your password',
                        errorText: _passError,
                        filled: true,
                        fillColor: Theme.of(context).cardColor,
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                      ),
                      onChanged: (s) {
                        _passDebounce?.cancel();
                        _passDebounce = Timer(const Duration(milliseconds: 300), _validatePass);
                        // also update confirm validation
                        _pass2Debounce?.cancel();
                        _pass2Debounce = Timer(const Duration(milliseconds: 300), _validatePass2);
                      },
                    ),
                  ),
                  Container(
                    height: 52,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      color: Theme.of(context).cardColor,
                      borderRadius: const BorderRadius.only(topRight: Radius.circular(12), bottomRight: Radius.circular(12)),
                    ),
                    child: IconButton(
                      onPressed: () => setState(() => _passObscure = !_passObscure),
                      icon: Icon(_passObscure ? Icons.visibility : Icons.visibility_off, color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Confirm Password
              const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text('Confirm Password', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _pass2,
                      obscureText: _pass2Obscure,
                      decoration: InputDecoration(
                        hintText: 'Confirm your password',
                        errorText: _pass2Error,
                        filled: true,
                        fillColor: Theme.of(context).cardColor,
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                      ),
                      onChanged: (s) {
                        _pass2Debounce?.cancel();
                        _pass2Debounce = Timer(const Duration(milliseconds: 300), _validatePass2);
                      },
                    ),
                  ),
                  Container(
                    height: 52,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      color: Theme.of(context).cardColor,
                      borderRadius: const BorderRadius.only(topRight: Radius.circular(12), bottomRight: Radius.circular(12)),
                    ),
                    child: IconButton(
                      onPressed: () => setState(() => _pass2Obscure = !_pass2Obscure),
                      icon: Icon(_pass2Obscure ? Icons.visibility : Icons.visibility_off, color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                  onPressed: _loading
                      ? null
                      : () async {
                          final ok = _validateAllNow();
                          if (!ok) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fix the highlighted fields')));
                            return;
                          }

                          final name = _name.text.trim();
                          final username = _username.text.trim();
                          final email = _email.text.trim();
                          final pass = _pass.text;

                          setState(() => _loading = true);

                          final res = await AuthService().register(name, email, pass, username);

                          setState(() => _loading = false);

                          if (res['ok'] == true) {
                            Navigator.of(context).pushReplacementNamed('/home');
                          } else {
                            final msg = (res['message'] ?? 'Registration failed').toString();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
                          }
                        },
                  child: _loading ? const CircularProgressIndicator(color: Colors.white) : const Text('Register'),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: 'Already have an account? ', style: TextStyle(color: Colors.grey[600])),
                      TextSpan(
                        text: 'Log in',
                        style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()..onTap = () => Navigator.of(context).pushReplacementNamed('/login'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
