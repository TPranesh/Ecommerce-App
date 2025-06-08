import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CartItem {
  final String id;
  final String productId;
  final String name;
  final String? imageUrl;
  final double price;
  final String? size;
  int quantity;
  final String category;

  CartItem({
    required this.id,
    required this.productId,
    required this.name,
    this.imageUrl,
    required this.price,
    this.size,
    required this.quantity,
    required this.category,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'size': size,
      'quantity': quantity,
      'category': category,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      productId: json['productId'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      price: double.parse(json['price'].toString()),
      size: json['size'],
      quantity: int.parse(json['quantity'].toString()),
      category: json['category'],
    );
  }
}

class CartProvider with ChangeNotifier {
  List<CartItem> _items = [];
  static const String _cartKey = 'cart_items';

  List<CartItem> get items => _items;

  int get itemCount => _items.fold(0, (total, item) => total + item.quantity);

  double get totalAmount {
    return _items.fold(0.0, (total, item) => total + (item.price * item.quantity));
  }

  double get shippingCost => 150.0;

  double get grandTotal => totalAmount + shippingCost;

  Future<void> loadCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartData = prefs.getString(_cartKey);
      if (cartData != null) {
        final List<dynamic> decodedData = jsonDecode(cartData);
        _items = decodedData.map((item) => CartItem.fromJson(item)).toList();
        notifyListeners();
      }
    } catch (e) {
      print('Error loading cart: $e');
    }
  }

  Future<void> _saveCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartData = jsonEncode(_items.map((item) => item.toJson()).toList());
      await prefs.setString(_cartKey, cartData);
    } catch (e) {
      print('Error saving cart: $e');
    }
  }

  Future<void> addItem({
    required String productId,
    required String name,
    String? imageUrl,
    required double price,
    String? size,
    required int quantity,
    required String category,
  }) async {
    final existingIndex = _items.indexWhere(
      (item) => item.productId == productId && item.size == size,
    );

    if (existingIndex >= 0) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(CartItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        productId: productId,
        name: name,
        imageUrl: imageUrl,
        price: price,
        size: size,
        quantity: quantity,
        category: category,
      ));
    }

    await _saveCart();
    notifyListeners();
  }

  Future<void> removeItem(String id) async {
    _items.removeWhere((item) => item.id == id);
    await _saveCart();
    notifyListeners();
  }

  Future<void> updateQuantity(String id, int quantity) async {
    final index = _items.indexWhere((item) => item.id == id);
    if (index >= 0) {
      if (quantity <= 0) {
        await removeItem(id);
      } else {
        _items[index].quantity = quantity;
        await _saveCart();
        notifyListeners();
      }
    }
  }

  Future<void> clearCart() async {
    _items.clear();
    await _saveCart();
    notifyListeners();
  }

  bool isInCart(String productId, String? size) {
    return _items.any((item) => item.productId == productId && item.size == size);
  }

  CartItem? getCartItem(String productId, String? size) {
    try {
      return _items.firstWhere((item) => item.productId == productId && item.size == size);
    } catch (e) {
      return null;
    }
  }
}
