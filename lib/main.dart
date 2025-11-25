import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'models/car.dart';
import 'services/auth_service.dart';
import 'screens/login.dart';
import 'screens/home.dart';
import 'screens/profile.dart';
import 'screens/cars.dart';
import 'screens/control.dart';
import 'screens/register.dart';
import 'screens/forgot_password.dart';
import 'screens/payment_methods.dart';
import 'screens/qr_payment_confirmation.dart';
import 'screens/rental_history.dart';
import 'screens/settings.dart';
import 'theme.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: AuthService().user,
      builder: (context, value, _) {
        final initial = AuthService().user.value == null ? '/login' : '/home';
        return MaterialApp(
          title: 'RentCar (toy)',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: ThemeMode.system,
          initialRoute: initial,
          routes: {
            '/login': (c) => const LoginScreen(),
            '/home': (c) => HomeScreen(),
            '/profile': (c) =>ProfileScreen(),
            '/cars': (c) => CarsScreen(),
            '/register': (c) => const RegisterScreen(),
            '/forgot': (c) => const ForgotPasswordScreen(),
            '/payment': (c) => const PaymentMethodsScreen(),
            '/qrconfirm': (c) => const QrPaymentConfirmationScreen(),
            '/history': (c) => const RentalHistoryScreen(),
            '/settings': (c) => const SettingsScreen(),
          },
          onGenerateRoute: (settings) {
            if (settings.name == '/control') {
              final car = settings.arguments as Car?;
              return MaterialPageRoute(builder: (_) => ControlScreen(car: car));
            }
            return null;
          },
        );
      },
    );
  }
}
