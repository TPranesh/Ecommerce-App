import 'package:flutter/material.dart';
import 'home_page.dart'; // Import HomePage for navigation
import 'package:ecommerce_assignment/shop_page.dart';

class ProductPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    bool isLandscape = screenWidth > screenHeight; // Check for landscape mode

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 40,
            ),
            SizedBox(width: 10),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Colors.white60),
                  filled: true,
                  fillColor: Colors.grey[800],
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView( 
        child: Padding(
          padding: const EdgeInsets.all(16.0), 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, 
            children: [
              
              Center(
                child: Container(
                  height: screenHeight * 0.35, 
                  width: isLandscape ? screenWidth * 0.6 : double.infinity, 
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: AssetImage("assets/images/Barcelona-Away-Football-Shirt-2425 (1)-600x600.jpg"),
                      fit: isLandscape ? BoxFit.contain : BoxFit.cover, 
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              
              Text(
                "Barcelona Away Kit",
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),

              
              Text(
                "RS 5000",
                style: TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),

              
              Text(
                "The official Barcelona Away kit for the 2024/2025 season. Made with high-quality breathable fabric for maximum comfort.",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              SizedBox(height: 20),

              
              Text(
                "Select Size",
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: DropdownButton<String>(
                  value: "S",
                  onChanged: (String? newValue) {},
                  items: ["S", "M", "L"].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  underline: Container(), 
                ),
              ),
              SizedBox(height: 20),

              
              Center(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  ),
                  child: Text("Add to Cart", style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
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
            IconButton(
              icon: Icon(Icons.person, color: Colors.white, size: 30),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
