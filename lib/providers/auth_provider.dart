import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthProvider with ChangeNotifier {
  String? _token;
  String? _userName;
  String? _userEmail;
  String? _userRole;
  bool get isAuthenticated => _token != null;
  String? get token => _token;
  String? get userName => _userName;
  String? get userEmail => _userEmail;
  String? get userRole => _userRole ?? 'user'; // Default to 'user'

  Future<bool> login(String email, String password) async {
    try {
      final url = Uri.parse('http://127.0.0.1:8000/api/auth/login'); // Web
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      ).timeout(const Duration(seconds: 10));

      print('Login Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['token'];
        _userName = data['user']['name'];
        _userEmail = data['user']['email'];
        _userRole = data['user']['role'] ?? 'user';
        await saveToken(data['token'], data['user']);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Login Error: $e');
      return false;
    }
  }

  Future<void> saveToken(String token, Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('user_name', user['name'] ?? '');
    await prefs.setString('user_email', user['email'] ?? '');
    await prefs.setString('user_role', user['role'] ?? 'user');
  }

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    _userName = prefs.getString('user_name');
    _userEmail = prefs.getString('user_email');
    _userRole = prefs.getString('user_role') ?? 'user';
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user_name');
    await prefs.remove('user_email');
    await prefs.remove('user_role');
    _token = null;
    _userName = null;
    _userEmail = null;
    _userRole = null;
    notifyListeners();
  }
}