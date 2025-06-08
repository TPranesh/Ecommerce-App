import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'login.dart';
import 'providers/auth_provider.dart';
import 'providers/battery_provider.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html if (dart.library.io) 'dart:io';

class ProductManagement extends StatefulWidget {
  const ProductManagement({super.key});

  @override
  _ProductManagementState createState() => _ProductManagementState();
}

class _ProductManagementState extends State<ProductManagement> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  String? _selectedCategory;
  XFile? _imageFile;
  Uint8List? _webImageBytes;

  final _editNameController = TextEditingController();
  final _editDescriptionController = TextEditingController();
  final _editPriceController = TextEditingController();
  final _editStockController = TextEditingController();
  String? _editSelectedCategory;
  XFile? _editImageFile;
  Uint8List? _editWebImageBytes;
  String? _editProductId;

  List<dynamic> products = [];
  bool isLoading = true;
  String? errorMessage;
  String? message;

  final _formKey = GlobalKey<FormState>();
  final _editFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _editNameController.dispose();
    _editDescriptionController.dispose();
    _editPriceController.dispose();
    _editStockController.dispose();
    super.dispose();
  }

  Future<void> _fetchProducts() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (!authProvider.isAuthenticated || authProvider.userRole != 'admin') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
      return;
    }

    try {
      final token = authProvider.token;
      print('Fetching products with token: $token');
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/products'),
        headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      );
      print('Products response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        setState(() {
          products = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load products: ${response.body}';
          isLoading = false;
        });
      }
    } catch (e) {
      print('Fetch products error: $e');
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _createProduct() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://127.0.0.1:8000/api/products'),
    );
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';
    request.fields.addAll({
      'name': _nameController.text,
      'category': _selectedCategory!,
      'description': _descriptionController.text,
      'price': _priceController.text,
      'stock': _stockController.text,
    });

    if (_imageFile != null) {
      if (kIsWeb && _webImageBytes != null) {
        request.files.add(http.MultipartFile.fromBytes(
          'image',
          _webImageBytes!,
          filename: _imageFile!.name,
        ));
      } else {
        request.files.add(await http.MultipartFile.fromPath('image', _imageFile!.path));
      }
    }

    try {
      print('Sending create product request: ${request.fields}');
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      print('Create product response: ${response.statusCode} - $responseBody');

      if (response.statusCode == 201) {
        setState(() {
          message = 'Product added successfully!';
          _resetAddForm();
          _fetchProducts();
        });
      } else {
        setState(() {
          message = 'Error: $responseBody';
        });
      }
    } catch (e) {
      print('Create product error: $e');
      setState(() {
        message = 'Error: $e';
      });
    }
  }

  Future<void> _editProduct(String id) async {
    print('Edit product tapped for ID: $id');
    final product = products.firstWhere((p) => p['id'] == id, orElse: () => null);
    if (product == null) {
      print('Product not found for ID: $id');
      setState(() {
        message = 'Product not found';
      });
      return;
    }
    setState(() {
      _editProductId = id;
      _editNameController.text = product['name'] ?? '';
      _editSelectedCategory = product['category'];
      _editDescriptionController.text = product['description'] ?? '';
      _editPriceController.text = product['price']?.toString() ?? '0';
      _editStockController.text = product['stock']?.toString() ?? '0';
      _editImageFile = null;
      _editWebImageBytes = null;
    });
    print('Showing edit dialog for product: ${product['name']}');
    showDialog(
      context: context,
      builder: (context) => _buildEditDialog(),
    );
  }

  Future<void> _updateProduct() async {
    if (!_editFormKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;
    var request = http.MultipartRequest(
      'PUT',
      Uri.parse('http://127.0.0.1:8000/api/products/$_editProductId'),
    );
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';
    request.fields.addAll({
      'name': _editNameController.text,
      'category': _editSelectedCategory!,
      'description': _editDescriptionController.text,
      'price': _editPriceController.text,
      'stock': _editStockController.text,
    });

    if (_editImageFile != null) {
      if (kIsWeb && _webImageBytes != null) {
        request.files.add(http.MultipartFile.fromBytes(
          'image',
          _editWebImageBytes!,
          filename: _editImageFile!.name,
        ));
      } else {
        request.files.add(await http.MultipartFile.fromPath('image', _editImageFile!.path));
      }
    }

    try {
      print('Sending update product request: ${request.fields}');
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      print('Update product response: ${response.statusCode} - $responseBody');

      if (response.statusCode == 200) {
        setState(() {
          message = 'Product updated successfully!';
          _fetchProducts();
        });
        Navigator.pop(context);
      } else {
        setState(() {
          message = 'Error: $responseBody';
        });
      }
    } catch (e) {
      print('Update product error: $e');
      setState(() {
        message = 'Error: $e';
      });
    }
  }

  Future<void> _deleteProduct(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;
    try {
      print('Deleting product ID: $id');
      final response = await http.delete(
        Uri.parse('http://127.0.0.1:8000/api/products/$id'),
        headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      );
      print('Delete product response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 204) {
        setState(() {
          message = 'Product deleted successfully!';
          _fetchProducts();
        });
      } else {
        setState(() {
          message = 'Error: ${response.body}';
        });
      }
    } catch (e) {
      print('Delete product error: $e');
      setState(() {
        message = 'Error: $e';
      });
    }
  }

  void _resetAddForm() {
    _nameController.clear();
    _descriptionController.clear();
    _priceController.clear();
    _stockController.clear();
    _selectedCategory = null;
    _imageFile = null;
    _webImageBytes = null;
  }

  Future<void> _pickImage(bool isEdit) async {
    final picker = ImagePicker();
    // Show dialog to choose source
    final ImageSource? source = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: const Text('Select Image Source', style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
            child: const Text('Gallery', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.camera),
            child: const Text('Camera', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (source == null) return; // User cancelled

    try {
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        if (kIsWeb) {
          final bytes = await pickedFile.readAsBytes();
          setState(() {
            if (isEdit) {
              _editImageFile = pickedFile;
              _editWebImageBytes = bytes;
            } else {
              _imageFile = pickedFile;
              _webImageBytes = bytes;
            }
          });
        } else {
          setState(() {
            if (isEdit) {
              _editImageFile = pickedFile;
              _editWebImageBytes = null;
            } else {
              _imageFile = pickedFile;
              _webImageBytes = null;
            }
          });
        }
      }
    } catch (e) {
      print('Image picker error: $e');
      setState(() {
        message = 'Failed to pick image: $e';
      });
    }
  }

  String _capitalize(String s) => s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1)}' : s;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          children: [
            Image.asset('assets/images/logo.png', height: 40),
            const SizedBox(width: 10),
            const Text('Product Management', style: TextStyle(color: Colors.white)),
            const Spacer(),
            // Battery Status with low battery warning
            Consumer<BatteryProvider>(
              builder: (context, battery, _) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: battery.isCriticalBattery 
                        ? Colors.red.shade800
                        : battery.isLowBattery 
                            ? Colors.orange.shade700 
                            : Colors.green.shade700,
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
                      if (battery.isLowBattery) ...[
                        const SizedBox(width: 4),
                        const Icon(Icons.warning, color: Colors.white, size: 14),
                      ],
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
                      if (authProvider.userRole == 'admin')
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade900,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Add New Product',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _nameController,
                                  decoration: const InputDecoration(
                                    labelText: 'Product Name',
                                    labelStyle: TextStyle(color: Colors.white70),
                                    filled: true,
                                    fillColor: Color(0xFF424242),
                                    border: OutlineInputBorder(borderSide: BorderSide.none),
                                  ),
                                  style: const TextStyle(color: Colors.white),
                                  validator: (value) =>
                                      value!.isEmpty ? 'Name is required' : null,
                                ),
                                const SizedBox(height: 10),
                                DropdownButtonFormField<String>(
                                  value: _selectedCategory,
                                  decoration: const InputDecoration(
                                    labelText: 'Category',
                                    labelStyle: TextStyle(color: Colors.white70),
                                    filled: true,
                                    fillColor: Color(0xFF424242),
                                    border: OutlineInputBorder(borderSide: BorderSide.none),
                                  ),
                                  style: const TextStyle(color: Colors.white),
                                  dropdownColor: Color(0xFF424242),
                                  items: ['jersey', 'equipment', 'memorabilia']
                                      .map((category) => DropdownMenuItem(
                                            value: category,
                                            child: Text(_capitalize(category)),
                                          ))
                                      .toList(),
                                  onChanged: (value) => setState(() => _selectedCategory = value),
                                  validator: (value) =>
                                      value == null ? 'Category is required' : null,
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  controller: _descriptionController,
                                  decoration: const InputDecoration(
                                    labelText: 'Description',
                                    labelStyle: TextStyle(color: Colors.white70),
                                    filled: true,
                                    fillColor: Color(0xFF424242),
                                    border: OutlineInputBorder(borderSide: BorderSide.none),
                                  ),
                                  style: const TextStyle(color: Colors.white),
                                  maxLines: 3,
                                  validator: (value) =>
                                      value!.isEmpty ? 'Description is required' : null,
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: _priceController,
                                        decoration: const InputDecoration(
                                          labelText: 'Price (RS)',
                                          labelStyle: TextStyle(color: Colors.white70),
                                          filled: true,
                                          fillColor: Color(0xFF424242),
                                          border: OutlineInputBorder(borderSide: BorderSide.none),
                                        ),
                                        style: const TextStyle(color: Colors.white),
                                        keyboardType: TextInputType.number,
                                        validator: (value) => value!.isEmpty
                                            ? 'Price is required'
                                            : double.tryParse(value) == null
                                                ? 'Invalid price'
                                                : null,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: TextFormField(
                                        controller: _stockController,
                                        decoration: const InputDecoration(
                                          labelText: 'Stock',
                                          labelStyle: TextStyle(color: Colors.white70),
                                          filled: true,
                                          fillColor: Color(0xFF424242),
                                          border: OutlineInputBorder(borderSide: BorderSide.none),
                                        ),
                                        style: const TextStyle(color: Colors.white),
                                        keyboardType: TextInputType.number,
                                        validator: (value) => value!.isEmpty
                                            ? 'Stock is required'
                                            : int.tryParse(value) == null
                                                ? 'Invalid stock'
                                                : null,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () => _pickImage(false),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.black,
                                  ),
                                  child: Text(_imageFile == null ? 'Select Image' : 'Image Selected'),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _createProduct,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.black,
                                      padding: const EdgeInsets.symmetric(vertical: 15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Text(
                                      'Add Product',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (authProvider.userRole == 'admin') const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade900,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'All Products',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            products.isEmpty
                                ? const Center(
                                    child: Text(
                                      'No products found',
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: products.length,
                                    itemBuilder: (context, index) {
                                      final product = products[index];
                                      return Card(
                                        color: Color(0xFF424242),
                                        margin: const EdgeInsets.only(bottom: 10),
                                        child: ListTile(
                                          leading: product['image_url'] != null
                                              ? Image.network(
                                                  'http://127.0.0.1:8000/storage/${product['image_url']}',
                                                  width: 50,
                                                  height: 50,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, color: Colors.grey),
                                                )
                                              : const Icon(Icons.image_not_supported, color: Colors.grey),
                                          title: Text(
                                            product['name'] ?? 'No Name',
                                            style: const TextStyle(color: Colors.white),
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Category: ${_capitalize(product['category'] ?? 'Unknown')}',
                                                style: const TextStyle(color: Colors.white70),
                                              ),
                                              Text(
                                                'Price: RS ${product['price'] ?? '0'}',
                                                style: const TextStyle(color: Colors.white70),
                                              ),
                                              Text(
                                                'Stock: ${product['stock'] ?? '0'}',
                                                style: const TextStyle(color: Colors.white70),
                                              ),
                                              Text(
                                                'Created: ${product['created_at'] != null ? DateTime.parse(product['created_at']).toLocal().toString().split(' ')[0] : 'Unknown'}',
                                                style: const TextStyle(color: Colors.white70),
                                              ),
                                            ],
                                          ),
                                          trailing: authProvider.userRole == 'admin'
                                              ? Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        print('Edit icon tapped for product ID: ${product['id']}');
                                                        _editProduct(product['id'].toString());
                                                      },
                                                      child: Container(
                                                        width: 48,
                                                        height: 48,
                                                        padding: const EdgeInsets.all(12),
                                                        decoration: BoxDecoration(
                                                          color: Colors.blue.withOpacity(0.2),
                                                          shape: BoxShape.circle,
                                                        ),
                                                        child: const Icon(Icons.edit, color: Colors.green, size: 24),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    GestureDetector(
                                                      onTap: () {
                                                        print('Delete icon tapped for product ID: ${product['id']}');
                                                        _deleteProduct(product['id'].toString());
                                                      },
                                                      child: Container(
                                                        width: 48,
                                                        height: 48,
                                                        padding: const EdgeInsets.all(12),
                                                        decoration: BoxDecoration(
                                                          color: Colors.red.withOpacity(0.2),
                                                          shape: BoxShape.circle,
                                                        ),
                                                        child: const Icon(Icons.delete, color: Colors.red, size: 24),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : null,
                                        ),
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

  Widget _buildEditDialog() {
    return AlertDialog(
      backgroundColor: Colors.grey.shade900,
      title: const Text('Edit Product', style: TextStyle(color: Colors.white)),
      content: SingleChildScrollView(
        child: Form(
          key: _editFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _editNameController,
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                  labelStyle: TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Color(0xFF424242),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
                style: const TextStyle(color: Colors.white),
                validator: (value) => value!.isEmpty ? 'Name is required' : null,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _editSelectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  labelStyle: TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Color(0xFF424242),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
                style: const TextStyle(color: Colors.white),
                dropdownColor: Color(0xFF424242),
                items: ['jersey', 'equipment', 'memorabilia']
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(_capitalize(category)),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _editSelectedCategory = value),
                validator: (value) => value == null ? 'Category is required' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _editDescriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Color(0xFF424242),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
                style: const TextStyle(color: Colors.white),
                maxLines: 3,
                validator: (value) => value!.isEmpty ? 'Description is required' : null,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _editPriceController,
                      decoration: const InputDecoration(
                        labelText: 'Price (RS)',
                        labelStyle: TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: Color(0xFF424242),
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                      ),
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.number,
                      validator: (value) => value!.isEmpty
                          ? 'Price is required'
                          : double.tryParse(value) == null
                              ? 'Invalid price'
                              : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _editStockController,
                      decoration: const InputDecoration(
                        labelText: 'Stock',
                        labelStyle: TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: Color(0xFF424242),
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                      ),
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.number,
                      validator: (value) => value!.isEmpty
                          ? 'Stock is required'
                          : int.tryParse(value) == null
                              ? 'Invalid stock'
                              : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _pickImage(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.black,
                ),
                child: Text(_editImageFile == null ? 'Select New Image' : 'Image Selected'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: Colors.white)),
        ),
        ElevatedButton(
          onPressed: _updateProduct,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.black,
          ),
          child: const Text('Update'),
        ),
      ],
    );
  }
}