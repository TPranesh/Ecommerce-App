// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'home_page.dart';
import 'shop_page.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Map<String, dynamic>> cartItems = [
    {
      "name": "Messi Jersey",
      "price": 4500,
      "image": "assets/images/Barcelona-Away-Football-Shirt-2425 (1)-600x600.jpg",
      "quantity": 1
    },

  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Shopping Cart"),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20), // ✅ Space before heading
            Text(
              "CART PAGE",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),

            // ✅ Cart Items List
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                var item = cartItems[index];

                return Container(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Row(
                    children: [
                      // ✅ Image with Error Handling
                      Image.asset(
                        item["image"],
                        width: screenWidth * 0.3,
                        height: screenHeight * 0.15,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: screenWidth * 0.3,
                            height: screenHeight * 0.15,
                            color: Colors.grey[800],
                            child: Icon(Icons.image_not_supported, color: Colors.white60, size: 50),
                          );
                        },
                      ),
                      SizedBox(width: 10),

                      // ✅ Product Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item["name"], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            SizedBox(height: 5),
                            Text("RS ${item["price"]}", style: TextStyle(color: Colors.green)),
                          ],
                        ),
                      ),

                      // ✅ Quantity Controls & Delete Button
                      Column(
                        children: [
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove, color: Colors.white),
                                onPressed: () {
                                  setState(() {
                                    if (item["quantity"] > 1) {
                                      item["quantity"]--;
                                    }
                                  });
                                },
                              ),
                              Text(item["quantity"].toString(), style: TextStyle(color: Colors.white)),
                              IconButton(
                                icon: Icon(Icons.add, color: Colors.white),
                                onPressed: () {
                                  setState(() {
                                    item["quantity"]++;
                                  });
                                },
                              ),
                            ],
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                cartItems.removeAt(index);
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),

            SizedBox(height: 10),

            // ✅ Total Price Section
            Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white24),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("TOTAL:", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      Text("RS 9000", style: TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Implement Checkout
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: Text("Checkout", style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      backgroundColor: Colors.black,

      // ✅ Bottom Navigation Bar (No Back Button Needed)
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.home, color: Colors.red, size: 30),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.shopping_bag, color: Colors.white, size: 30),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ShopPage()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.shopping_cart, color: Colors.white, size: 30),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
