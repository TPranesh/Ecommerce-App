import 'package:flutter/material.dart';
   import 'package:http/http.dart' as http;
   import 'dart:convert';
   import 'home_page.dart';
   import 'shop_page.dart';
   import 'product_page.dart';
   import 'cartpage.dart';

   class JerseyPage extends StatelessWidget {
     const JerseyPage({super.key});

     Future<List<dynamic>> _fetchJerseyProducts() async {
       try {
         final response = await http.get(
           Uri.parse('http://127.0.0.1:8000/api/products?category=jersey'),
           headers: {'Accept': 'application/json'},
         ).timeout(const Duration(seconds: 10));

         print('Jersey API Response: ${response.statusCode} - ${response.body}');

         if (response.statusCode == 200) {
           return jsonDecode(response.body);
         } else {
           throw Exception('Failed to load jerseys: ${response.statusCode}');
         }
       } catch (e) {
         print('Jersey API Error: $e');
         throw Exception('Error fetching jerseys: $e');
       }
     }     Widget _buildProductCard(
         BuildContext context, Map<String, dynamic> product, double screenWidth, double screenHeight) {
       // Use /api/image/ and remove 'storage/' from image_url
       final imageUrl = product['image_url'] != null
           ? 'http://127.0.0.1:8000/api/image/${product['image_url'].replaceFirst('storage/', '')}'
           : 'https://via.placeholder.com/150';

       return GestureDetector(
         onTap: () {
           Navigator.push(
             context,
             MaterialPageRoute(
               builder: (context) => ProductPage(productId: product['id'].toString()),
             ),
           );
         },
         child: Container(
           padding: const EdgeInsets.all(4),
           child: Column(
             mainAxisSize: MainAxisSize.min,
             crossAxisAlignment: CrossAxisAlignment.center,
             children: [
               Flexible(
                 flex: 3,
                 child: Container(
                   width: double.infinity,
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(10),
                     image: DecorationImage(
                       image: NetworkImage(imageUrl),
                       fit: BoxFit.contain,
                       onError: (exception, stackTrace) => print('Image load error: $exception'),
                     ),
                   ),
                 ),
               ),               const SizedBox(height: 2),
               Flexible(
                 flex: 1,
                 child: Column(
                   mainAxisSize: MainAxisSize.min,
                   crossAxisAlignment: CrossAxisAlignment.center,
                   children: [
                     Flexible(
                       child: Text(
                         product['name'] ?? 'Unknown',
                         style: const TextStyle(
                           color: Colors.white, 
                           fontWeight: FontWeight.bold,
                           fontSize: 11,
                         ),
                         textAlign: TextAlign.center,
                         maxLines: 2,
                         overflow: TextOverflow.ellipsis,
                       ),
                     ),
                     Text(
                       'RS ${product['price'] ?? 0}',
                       style: const TextStyle(
                         color: Colors.green, 
                         fontWeight: FontWeight.bold,
                         fontSize: 10,
                       ),
                       overflow: TextOverflow.ellipsis,
                     ),
                   ],
                 ),
               ),
             ],
           ),
         ),
       );
     }

     @override
     Widget build(BuildContext context) {
       double screenWidth = MediaQuery.of(context).size.width;
       double screenHeight = MediaQuery.of(context).size.height;
       bool isLandscape = screenWidth > screenHeight;

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
         body: SingleChildScrollView(
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Container(
                 width: double.infinity,
                 height: screenHeight * 0.60,
                 decoration: const BoxDecoration(
                   image: DecorationImage(
                     image: AssetImage("assets/images/messi.jpeg"),
                     fit: BoxFit.cover,
                   ),
                 ),
                 child: Align(
                   alignment: Alignment.centerLeft,
                   child: Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 20),
                     child: Text(
                       "FOOTBALL JERSEYS",
                       style: TextStyle(
                         fontSize: screenWidth * 0.06,
                         fontWeight: FontWeight.bold,
                         color: Colors.white,
                       ),
                     ),
                   ),
                 ),
               ),
               const SizedBox(height: 10),
               FutureBuilder<List<dynamic>>(
                 future: _fetchJerseyProducts(),
                 builder: (context, snapshot) {
                   if (snapshot.connectionState == ConnectionState.waiting) {
                     return const Center(child: CircularProgressIndicator());
                   } else if (snapshot.hasError) {
                     return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.white)));
                   } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                     return const Center(child: Text('No jerseys found', style: TextStyle(color: Colors.white)));
                   } else {
                     final products = snapshot.data!;                     return GridView.builder(
                       shrinkWrap: true,
                       physics: const NeverScrollableScrollPhysics(),
                       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                         crossAxisCount: isLandscape ? 4 : 3,
                         crossAxisSpacing: 10,
                         mainAxisSpacing: 15,
                         childAspectRatio: isLandscape ? 0.85 : 0.8,
                       ),
                       itemCount: products.length,
                       itemBuilder: (context, index) {
                         return _buildProductCard(context, products[index], screenWidth, screenHeight);
                       },
                     );
                   }
                 },
               ),
               const SizedBox(height: 20),
             ],
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