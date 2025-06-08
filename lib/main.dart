import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login.dart';
import 'register.dart';
import 'home_page.dart';
import 'shop_page.dart';
import 'equipment.dart';

import 'admin_dashboard_page.dart';
import 'providers/auth_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Football Ecommerce App',
      theme: ThemeData(
        primarySwatch: Colors.red,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.red,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          // Load token once when app starts
          WidgetsBinding.instance.addPostFrameCallback((_) {
            auth.loadToken();
          });
          return auth.isAuthenticated ? const HomePage() : const LoginPage();
        },
      ),
      routes: {
        '/shop': (context) => const ShopPage(),
        '/equipment': (context) => const EquipmentPage(),
        '/memerobilia': (context) => const HomePage(),
        
        '/register': (context) => const RegisterPage(),
        '/admin_dashboard': (context) => const AdminDashboardPage(),
      },
    );
  }
}