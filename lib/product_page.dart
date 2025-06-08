import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';
import 'shop_page.dart';
import 'cartpage.dart';
import 'login.dart';
import 'providers/cart_provider.dart';

class ProductPage extends StatefulWidget {
  final String productId;

  const ProductPage({super.key, required this.productId});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  Map<String, dynamic>? product;
  bool isLoading = true;
  String? errorMessage;
  String? selectedSize;
  int quantity = 1;
  String? cartMessage;

  @override
  void initState() {
    super.initState();
    _fetchProduct();
  }

  Future<void> _fetchProduct() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/products/${widget.productId}'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      print('Product API Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        setState(() {
          product = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load product: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching product: $e';
        isLoading = false;
      });
    }
  }

  Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<bool> _isLoggedIn() async {
    final token = await _getAuthToken();
    if (token == null) return false;

    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/user'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
  Future<void> _addToCart() async {
    if (selectedSize == null) {
      setState(() {
        cartMessage = 'Please select a size';
      });
      return;
    }

    if (product == null) {
      setState(() {
        cartMessage = 'Product data not available';
      });
      return;
    }

    try {
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      
      await cartProvider.addItem(
        productId: widget.productId,
        name: product!['name'] ?? 'Unknown Product',
        imageUrl: product!['image_url'],
        price: double.tryParse(product!['price'].toString()) ?? 0.0,
        size: selectedSize,
        quantity: quantity,
        category: product!['category'] ?? 'general',
      );

      setState(() {
        cartMessage = 'Product added to cart successfully!';
        selectedSize = null;
        quantity = 1;
      });

      // Clear message after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            cartMessage = null;
          });
        }
      });
    } catch (e) {
      setState(() {
        cartMessage = 'Error adding product to cart: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 40,
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
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Product Image
                        Container(
                          height: screenHeight * 0.3,
                          width: screenWidth * 0.8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage(
                                product!['image_url'] != null
                                    ? 'http://127.0.0.1:8000/api/image/${product!['image_url'].replaceFirst('storage/', '')}'
                                    : 'https://via.placeholder.com/150',
                              ),
                              fit: BoxFit.contain,
                              onError: (exception, stackTrace) => print('Image load error: $exception'),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Product Name
                        Text(
                          product!['name'] ?? 'Unknown',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        // Price
                        Text(
                          'RS ${product!['price'] ?? 0}',
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Description in Box
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey[700]!),
                          ),
                          child: Text(
                            product!['description'] ?? 'No description available',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Size Dropdown and Quantity Counter Side by Side
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Size Dropdown
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.grey[800],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: DropdownButton<String>(
                                hint: const Text('Select Size', style: TextStyle(color: Colors.white70)),
                                value: selectedSize,
                                dropdownColor: Colors.grey[800],
                                style: const TextStyle(color: Colors.white),
                                underline: const SizedBox(),
                                items: ['Small', 'Medium', 'Large'].map((String size) {
                                  return DropdownMenuItem<String>(
                                    value: size,
                                    child: Text(size),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedSize = newValue;
                                    cartMessage = null;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 20),
                            // Quantity Counter
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.grey[800],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove, color: Colors.white, size: 20),
                                    onPressed: quantity > 1
                                        ? () {
                                            setState(() {
                                              quantity--;
                                              cartMessage = null;
                                            });
                                          }
                                        : null,
                                  ),
                                  Text(
                                    '$quantity',
                                    style: const TextStyle(color: Colors.white, fontSize: 16),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add, color: Colors.white, size: 20),
                                    onPressed: () {
                                      setState(() {
                                        quantity++;
                                        cartMessage = null;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Add to Cart Button
                        ElevatedButton(
                          onPressed: _addToCart,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Add to Cart',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Cart Message
                        if (cartMessage != null)
                          Text(
                            cartMessage!,
                            style: TextStyle(
                              color: cartMessage!.startsWith('Error') || cartMessage!.startsWith('Please')
                                  ? Colors.red
                                  : Colors.green,
                            ),
                          ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
      backgroundColor: Colors.black,
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home, color: Colors.white, size: 30),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.shopping_bag, color: Colors.red, size: 30),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ShopPage()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.shopping_cart, color: Colors.white, size: 30),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const CartPage()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.person, color: Colors.white, size: 30),
              onPressed: () {
                // Placeholder for ProfilePage navigation
              },
            ),
          ],
        ),
      ),
    );
  }
}