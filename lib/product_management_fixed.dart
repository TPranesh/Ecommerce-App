import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

class ProductManagement extends StatefulWidget {
  const ProductManagement({super.key});

  @override
  _ProductManagementState createState() => _ProductManagementState();
}

class _ProductManagementState extends State<ProductManagement> {
  // Add form controllers
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  String? _selectedCategory;
  XFile? _imageFile;

  // Edit form controllers
  final _editNameController = TextEditingController();
  final _editDescriptionController = TextEditingController();
  final _editPriceController = TextEditingController();
  final _editStockController = TextEditingController();
  String? _editSelectedCategory;
  XFile? _editImageFile;
  int? _editProductId;

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

  Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> _fetchProducts() async {
    try {
      final token = await _getAuthToken();
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/products'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        setState(() {
          products = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load products';
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

  Future<void> _createProduct() async {
    if (!_formKey.currentState!.validate()) return;

    final token = await _getAuthToken();
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://127.0.0.1:8000/api/products'),
    );
    request.headers['Authorization'] = 'Bearer $token';
    request.fields.addAll({
      'name': _nameController.text,
      'category': _selectedCategory!,
      'description': _descriptionController.text,
      'price': _priceController.text,
      'stock': _stockController.text,
    });

    if (_imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath('image', _imageFile!.path));
    }

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

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
      setState(() {
        message = 'Error: $e';
      });
    }
  }

  Future<void> _editProduct(int id) async {
    final product = products.firstWhere((p) => p['id'] == id);
    setState(() {
      _editProductId = id;
      _editNameController.text = product['name'];
      _editSelectedCategory = product['category'];
      _editDescriptionController.text = product['description'];
      _editPriceController.text = product['price'].toString();
      _editStockController.text = product['stock'].toString();
      _editImageFile = null;
    });

    showDialog(
      context: context,
      builder: (context) => _buildEditDialog(),
    );
  }

  Future<void> _updateProduct() async {
    if (!_editFormKey.currentState!.validate()) return;

    final token = await _getAuthToken();
    var request = http.MultipartRequest(
      'PUT',
      Uri.parse('http://127.0.0.1:8000/api/products/$_editProductId'),
    );
    request.headers['Authorization'] = 'Bearer $token';
    request.fields.addAll({
      'name': _editNameController.text,
      'category': _editSelectedCategory!,
      'description': _editDescriptionController.text,
      'price': _editPriceController.text,
      'stock': _editStockController.text,
    });

    if (_editImageFile != null) {
      request.files.add(await http.MultipartFile.fromPath('image', _editImageFile!.path));
    }

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

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
      setState(() {
        message = 'Error: $e';
      });
    }
  }

  Future<void> _deleteProduct(int id) async {
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

    final token = await _getAuthToken();
    try {
      final response = await http.delete(
        Uri.parse('http://127.0.0.1:8000/api/products/$id'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
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
  }

  Future<void> _pickImage(bool isEdit) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (isEdit) {
          _editImageFile = pickedFile;
        } else {
          _imageFile = pickedFile;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          children: [
            Image.asset('assets/images/logo.png', height: 40),
            const SizedBox(width: 10),
            const Text('Product Management', style: TextStyle(color: Colors.white)),
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
                      // Message
                      if (message != null)
                        Container(
                          margin: const EdgeInsets.only(bottom: 16.0),
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: message!.startsWith('Error') ? Colors.red[900] : Colors.green[900],
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
                      // Add Product Form
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
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
                                decoration: InputDecoration(
                                  labelText: 'Product Name',
                                  labelStyle: const TextStyle(color: Colors.white70),
                                  filled: true,
                                  fillColor: Colors.grey[800],
                                  border: const OutlineInputBorder(borderSide: BorderSide.none),
                                ),
                                style: const TextStyle(color: Colors.white),
                                validator: (value) =>
                                    value!.isEmpty ? 'Name is required' : null,
                              ),
                              const SizedBox(height: 10),
                              DropdownButtonFormField<String>(
                                value: _selectedCategory,
                                decoration: InputDecoration(
                                  labelText: 'Category',
                                  labelStyle: const TextStyle(color: Colors.white70),
                                  filled: true,
                                  fillColor: Colors.grey[800],
                                  border: const OutlineInputBorder(borderSide: BorderSide.none),
                                ),
                                style: const TextStyle(color: Colors.white),
                                dropdownColor: Colors.grey[800],
                                items: ['jersey', 'equipment', 'memorabilia']
                                    .map((category) => DropdownMenuItem(
                                          value: category,
                                          child: Text(category.capitalize()),
                                        ))
                                    .toList(),
                                onChanged: (value) => setState(() => _selectedCategory = value),
                                validator: (value) =>
                                    value == null ? 'Category is required' : null,
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: _descriptionController,
                                decoration: InputDecoration(
                                  labelText: 'Description',
                                  labelStyle: const TextStyle(color: Colors.white70),
                                  filled: true,
                                  fillColor: Colors.grey[800],
                                  border: const OutlineInputBorder(borderSide: BorderSide.none),
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
                                      decoration: InputDecoration(
                                        labelText: 'Price (RS)',
                                        labelStyle: const TextStyle(color: Colors.white70),
                                        filled: true,
                                        fillColor: Colors.grey[800],
                                        border: const OutlineInputBorder(borderSide: BorderSide.none),
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
                                      decoration: InputDecoration(
                                        labelText: 'Stock',
                                        labelStyle: const TextStyle(color: Colors.white70),
                                        filled: true,
                                        fillColor: Colors.grey[800],
                                        border: const OutlineInputBorder(borderSide: BorderSide.none),
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
                      const SizedBox(height: 20),
                      // Products List
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
                              'All Products',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
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
                                        color: Colors.grey[800],
                                        margin: const EdgeInsets.only(bottom: 10),
                                        child: ListTile(
                                          leading: product['image_url'] != null
                                              ? Image.network(
                                                  'http://127.0.0.1:8000/api/image/${product['image_url'].replaceFirst('products/', '')}',
                                                  width: 50,
                                                  height: 50,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, color: Colors.grey),
                                                )
                                              : const Icon(Icons.image_not_supported, color: Colors.grey),
                                          title: Text(
                                            product['name'],
                                            style: const TextStyle(color: Colors.white),
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Category: ${product['category'].capitalize()}',
                                                style: const TextStyle(color: Colors.white70),
                                              ),
                                              Text(
                                                'Price: RS ${product['price']}',
                                                style: const TextStyle(color: Colors.white70),
                                              ),
                                              Text(
                                                'Stock: ${product['stock']}',
                                                style: const TextStyle(color: Colors.white70),
                                              ),
                                              Text(
                                                'Created: ${DateTime.parse(product['created_at']).toLocal().toString().split(' ')[0]}',
                                                style: const TextStyle(color: Colors.white70),
                                              ),
                                            ],
                                          ),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.edit, color: Colors.green),
                                                onPressed: () => _editProduct(product['id']),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.delete, color: Colors.red),
                                                onPressed: () => _deleteProduct(product['id']),
                                              ),
                                            ],
                                          ),
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
      backgroundColor: Colors.grey[900],
      title: const Text('Edit Product', style: TextStyle(color: Colors.white)),
      content: SingleChildScrollView(
        child: Form(
          key: _editFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _editNameController,
                decoration: InputDecoration(
                  labelText: 'Product Name',
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: const OutlineInputBorder(borderSide: BorderSide.none),
                ),
                style: const TextStyle(color: Colors.white),
                validator: (value) => value!.isEmpty ? 'Name is required' : null,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _editSelectedCategory,
                decoration: InputDecoration(
                  labelText: 'Category',
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: const OutlineInputBorder(borderSide: BorderSide.none),
                ),
                style: const TextStyle(color: Colors.white),
                dropdownColor: Colors.grey[800],
                items: ['jersey', 'equipment', 'memorabilia']
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category.capitalize()),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _editSelectedCategory = value),
                validator: (value) => value == null ? 'Category is required' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _editDescriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: const OutlineInputBorder(borderSide: BorderSide.none),
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
                      decoration: InputDecoration(
                        labelText: 'Price (RS)',
                        labelStyle: const TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: Colors.grey[800],
                        border: const OutlineInputBorder(borderSide: BorderSide.none),
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
                      decoration: InputDecoration(
                        labelText: 'Stock',
                        labelStyle: const TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: Colors.grey[800],
                        border: const OutlineInputBorder(borderSide: BorderSide.none),
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
