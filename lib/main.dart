import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/admin_dashboard_screen.dart';
import 'screens/driver_dashboard_screen.dart';
import 'screens/ai_chat_screen.dart';
import 'screens/buyer_home_screen.dart';
import 'screens/map_screen.dart';
import 'screens/profile_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      routes: {
        '/admin': (_) => const AdminDashboardScreen(),
        '/driver': (_) => const DriverDashboardScreen(),
        '/ai-chat': (_) => const AiChatScreen(),
        '/buyer-home': (_) => const BuyerHomeScreen(),
        '/map': (_) => const MapScreen(),
        '/profile': (_) => const ProfileScreen(),
      },
    );
  }
}
