
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<dynamic> cartItems = [];
  double subtotal = 0.0;
  double shippingCost = 150.0;
  double total = 0.0;
  bool isLoading = true;
  String? errorMessage;
  String? message;

  @override
  void initState() {
    super.initState();
    _fetchCart();
  }

  Future<void> _fetchCart() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (!authProvider.isAuthenticated) {
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final token = authProvider.token;
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/cart'),
        headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      );
      print('Cart response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          cartItems = data['cart_items'] ?? [];
          subtotal = double.tryParse(data['subtotal'].toString()) ?? 0.0;
          shippingCost = double.tryParse(data['shipping_cost'].toString()) ?? 150.0;
          total = double.tryParse(data['total'].toString()) ?? 0.0;
          isLoading = false;
        });
      } else {
        final errorData = jsonDecode(response.body);
        setState(() {
          errorMessage = errorData['message'] ?? 'Failed to load cart: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      print('Fetch cart error: $e');
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _removeFromCart(String id) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      final token = authProvider.token;
      final response = await http.delete(
        Uri.parse('http://127.0.0.1:8000/api/cart/$id'),
        headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      );
      print('Remove cart item response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 204) {
        setState(() {
          message = 'Item removed from cart';
          _fetchCart();
        });
      } else {
        setState(() {
          message = 'Error: ${response.body}';
        });
      }
    } catch (e) {
      print('Remove cart error: $e');
      setState(() {
        message = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Shopping Cart', style: TextStyle(color: Colors.white)),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        errorMessage!,
                        style: const TextStyle(color: Colors.white, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchCart,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.black,
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (message != null)
                        Container(
                          margin: const EdgeInsets.only(bottom: 16.0),
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: message!.startsWith('Error') ? Colors.red.shade900 : Colors.green.shade900,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  message!,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close, color: Colors.white),
                                onPressed: () => setState(() => message = null),
                              ),
                            ],
                          ),
                        ),
                      const Text(
                        'Your Cart',
                        style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      cartItems.isEmpty
                          ? const Center(
                              child: Text(
                                'Your cart is empty!',
                                style: TextStyle(color: Colors.white70, fontSize: 18),
                              ),
                            )
                          : Column(
                              children: cartItems.map((item) {
                                return Card(
                                  color: const Color(0xFF424242),
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: ListTile(
                                    leading: item['product']['image_url'] != null
                                        ? Image.network(
                                            'http://127.0.0.1:8000/storage/${item['product']['image_url']}',
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, color: Colors.grey),
                                          )
                                        : const Icon(Icons.image_not_supported, color: Colors.grey),
                                    title: Text(
                                      item['product']['name'] ?? 'No Name',
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Price: RS ${item['product']['price']}',
                                          style: const TextStyle(color: Colors.white70),
                                        ),
                                        Text(
                                          'Quantity: ${item['quantity']}',
                                          style: const TextStyle(color: Colors.white70),
                                        ),
                                        Text(
                                          'Size: ${item['size'] ?? 'N/A'}',
                                          style: const TextStyle(color: Colors.white70),
                                        ),
                                      ],
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => _removeFromCart(item['_id']),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                      const SizedBox(height: 20),
                      const Text(
                        'Order Summary',
                        style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade900,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Subtotal', style: TextStyle(color: Colors.white70)),
                                Text('RS ${subtotal.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Shipping', style: TextStyle(color: Colors.white70)),
                                Text('RS ${shippingCost.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white)),
                              ],
                            ),
                            const Divider(color: Colors.grey, height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Total', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                                Text('RS ${total.toStringAsFixed(2)}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: 16),
                            if (cartItems.isNotEmpty)
                              ElevatedButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Proceeding to shipping...')),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.black,
                                  minimumSize: const Size(double.infinity, 50),
                                ),
                                child: const Text('Proceed to Checkout'),
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
}
