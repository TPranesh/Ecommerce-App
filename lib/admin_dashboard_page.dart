import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'login.dart';
import 'product_management.dart';
import 'providers/auth_provider.dart';
import 'providers/battery_provider.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  _AdminDashboardPageState createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  int productsCount = 0;
  int usersCount = 0;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchStats();
  }

  Future<void> _fetchStats() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (!authProvider.isAuthenticated || authProvider.userRole != 'admin') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
      return;
    }

    try {
      final token = authProvider.token; // Assume AuthProvider exposes token
      // Fetch products count
      final productsResponse = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/products'),
        headers: {'Authorization': 'Bearer $token'},
      );

      // Fetch users count (fallback to 0 if endpoint is unavailable)
      http.Response usersResponse;
      try {
        usersResponse = await http.get(
          Uri.parse('http://127.0.0.1:8000/api/users/count'),
          headers: {'Authorization': 'Bearer $token'},
        );
      } catch (_) {
        usersResponse = http.Response('{"count": 0}', 200);
      }

      if (productsResponse.statusCode == 200) {
        setState(() {
          productsCount = jsonDecode(productsResponse.body).length;
          usersCount = usersResponse.statusCode == 200
              ? jsonDecode(usersResponse.body)['count'] ?? 0
              : 0;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load stats';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          children: [
            Image.asset('assets/images/logo.png', height: 40),
            const SizedBox(width: 10),
            const Expanded(
              child: Text('Admin Dashboard', style: TextStyle(color: Colors.white)),
            ),
            // Battery Status
            Consumer<BatteryProvider>(
              builder: (context, battery, _) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: battery.isLowBattery ? Colors.red.shade700 : Colors.green.shade700,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        battery.batteryIcon,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        battery.batteryText,
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!, style: const TextStyle(color: Colors.white)))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Stats Cards
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatCard(
                            icon: Icons.store,
                            title: 'Total Products',
                            value: productsCount.toString(),
                            color: Colors.green,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const ProductManagement()),
                              );
                            },
                          ),
                          _buildStatCard(
                            icon: Icons.people,
                            title: 'Total Users',
                            value: usersCount.toString(),
                            color: Colors.purple,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Quick Actions
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Quick Actions',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ListTile(
                              leading: const Icon(Icons.store, color: Colors.green),
                              title: const Text('Manage Products', style: TextStyle(color: Colors.white)),
                              subtitle: const Text(
                                'Add, edit, and organize your football products',
                                style: TextStyle(color: Colors.white70),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const ProductManagement()),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
      backgroundColor: Colors.black,
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.45,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}