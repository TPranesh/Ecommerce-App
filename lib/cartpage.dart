
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';
import 'home_page.dart';
import 'shop_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  String? message;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    await cartProvider.loadCart();
  }

  Future<void> _removeFromCart(String id) async {
    try {
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      await cartProvider.removeItem(id);
      
      setState(() {
        message = 'Item removed from cart';
      });

      // Clear message after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            message = null;
          });
        }
      });
    } catch (e) {
      setState(() {
        message = 'Error removing item: $e';
      });
    }
  }

  Future<void> _updateQuantity(String id, int newQuantity) async {
    try {
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      await cartProvider.updateQuantity(id, newQuantity);
    } catch (e) {
      setState(() {
        message = 'Error updating quantity: $e';
      });
    }
  }
  @override
  Widget build(BuildContext context) {    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart', style: TextStyle(color: Colors.white)),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          return SingleChildScrollView(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Your Cart',
                      style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${cartProvider.itemCount} items',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                cartProvider.items.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 50),
                            Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[600]),
                            const SizedBox(height: 16),
                            const Text(
                              'Your cart is empty!',
                              style: TextStyle(color: Colors.white70, fontSize: 18),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => const ShopPage()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                              ),
                              child: const Text('Start Shopping'),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          ...cartProvider.items.map((item) {
                            return Card(
                              color: const Color(0xFF424242),
                              margin: const EdgeInsets.only(bottom: 10),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    // Product Image
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.grey[800],
                                      ),
                                      child: item.imageUrl != null
                                          ? ClipRRect(
                                              borderRadius: BorderRadius.circular(8),
                                              child: Image.network(
                                                'http://127.0.0.1:8000/storage/${item.imageUrl}',
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) => 
                                                    const Icon(Icons.image_not_supported, color: Colors.grey),
                                              ),
                                            )
                                          : const Icon(Icons.image_not_supported, color: Colors.grey),
                                    ),
                                    const SizedBox(width: 12),
                                    // Product Details
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.name,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Size: ${item.size ?? 'N/A'}',
                                            style: const TextStyle(color: Colors.white70, fontSize: 14),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'RS ${item.price.toStringAsFixed(2)}',
                                            style: const TextStyle(
                                              color: Colors.green,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Quantity Controls
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              onPressed: item.quantity > 1
                                                  ? () => _updateQuantity(item.id, item.quantity - 1)
                                                  : null,
                                              icon: const Icon(Icons.remove, color: Colors.white),
                                              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[800],
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                '${item.quantity}',
                                                style: const TextStyle(color: Colors.white, fontSize: 16),
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () => _updateQuantity(item.id, item.quantity + 1),
                                              icon: const Icon(Icons.add, color: Colors.white),
                                              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                            ),
                                          ],
                                        ),
                                        IconButton(
                                          onPressed: () => _removeFromCart(item.id),
                                          icon: const Icon(Icons.delete, color: Colors.red),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                          const SizedBox(height: 20),
                          // Order Summary
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
                                    Text(
                                      'RS ${cartProvider.totalAmount.toStringAsFixed(2)}',
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Shipping', style: TextStyle(color: Colors.white70)),
                                    Text(
                                      'RS ${cartProvider.shippingCost.toStringAsFixed(2)}',
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                                const Divider(color: Colors.grey, height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Total',
                                      style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 18),
                                    ),
                                    Text(
                                      'RS ${cartProvider.grandTotal.toStringAsFixed(2)}',
                                      style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 18),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          await cartProvider.clearCart();
                                          setState(() {
                                            message = 'Cart cleared successfully';
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.grey[700],
                                          foregroundColor: Colors.white,
                                          minimumSize: const Size(0, 50),
                                        ),
                                        child: const Text('Clear Cart'),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      flex: 2,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Order placed! Total: RS ${cartProvider.grandTotal.toStringAsFixed(2)}'),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          foregroundColor: Colors.black,
                                          minimumSize: const Size(0, 50),
                                        ),
                                        child: const Text(
                                          'Proceed to Checkout',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          );        },
      ),      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).bottomAppBarTheme.color,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.home, 
                color: Theme.of(context).brightness == Brightness.dark 
                  ? Colors.white 
                  : Colors.black, 
                size: 30),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.shopping_bag, 
                color: Theme.of(context).brightness == Brightness.dark 
                  ? Colors.white 
                  : Colors.black, 
                size: 30),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ShopPage()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.shopping_cart, color: Colors.red, size: 30),
              onPressed: () {
                // Already on cart page
              },
            ),
            IconButton(
              icon: Icon(Icons.person, 
                color: Theme.of(context).brightness == Brightness.dark 
                  ? Colors.white 
                  : Colors.black, 
                size: 30),
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
