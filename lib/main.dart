import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login.dart';
import 'register.dart';
import 'home_page.dart';
import 'shop_page.dart';
import 'equipment.dart';
import 'cartpage.dart';

import 'admin_dashboard_page.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/connectivity_provider.dart';
import 'providers/battery_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
        ChangeNotifierProvider(create: (_) => BatteryProvider()),
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
      builder: (context, child) {
        return ConnectivityWrapper(child: child ?? Container());
      },
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
        '/login': (context) => const LoginPage(),
        '/cart': (context) => const CartPage(),
        '/shop': (context) => const ShopPage(),
        '/equipment': (context) => const EquipmentPage(),
        '/memerobilia': (context) => const HomePage(),
        '/register': (context) => const RegisterPage(),
        '/admin_dashboard': (context) => const AdminDashboardPage(),
      },
    );
  }
}

class ConnectivityWrapper extends StatelessWidget {
  final Widget child;

  const ConnectivityWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityProvider>(
      builder: (context, connectivity, _) {
        return Scaffold(
          body: Column(
            children: [
              // Network status banner
              if (!connectivity.isOnline)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.red,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.wifi_off, color: Colors.white, size: 16),
                      const SizedBox(width: 8),
                      const Text(
                        'No internet connection',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              // Connection status indicator (always visible)
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                color: connectivity.isOnline
                    ? Colors.green.shade700
                    : Colors.red.shade700,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      connectivity.isOnline ? Icons.wifi : Icons.wifi_off,
                      color: Colors.white,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      connectivity.connectionType,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
              // Main content
              Expanded(child: child),
            ],
          ),
        );
      },
    );
  }
}