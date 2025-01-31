import 'package:flutter/material.dart';
import 'package:ecommerce_assignment/shop_page.dart';
import 'login.dart';
import 'cartpage.dart';

class HomePage extends StatelessWidget {
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

            SizedBox(width: 10),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
              child: Text(
                "Login",
                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: screenHeight * 0.25,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/topbanner.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  left: 20,
                  top: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "BE BOLD",
                        style: TextStyle(
                          fontSize: screenWidth * 0.06,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 5),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        child: Text("Shop Now"),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "FAMOUS PRODUCTS",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: _buildImage("assets/images/1.jpg", screenHeight)),
                      SizedBox(width: 10),
                      Expanded(child: _buildImage("assets/images/1.2.jpg", screenHeight)),
                    ],
                  ),
                  SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSmallImage("assets/images/R.jpg", screenHeight),
                      _buildSmallImage("assets/images/barca 3rd kit.jpg", screenHeight),
                      _buildSmallImage("assets/images/jabulani.jpg", screenHeight),
                      _buildSmallImage("assets/images/ronaldo black.jpg", screenHeight),
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),

            Container(
              width: double.infinity,
              height: screenHeight * 0.2,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      "assets/images/banner1.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "LET'S FOOTBALL",
                            style: TextStyle(
                              fontSize: screenWidth * 0.045,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "THE BEST VERSION OF ANY PRODUCT YOU ASK. WE DELIVER HIGH-QUALITY PRODUCTS AT THE BEST PRICES.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: screenWidth * 0.035,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CartPage()), 
          );
        },
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

  
  Widget _buildImage(String imagePath, double height) {
    return Container(
      height: height * 0.2, // Adjusts dynamically
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  
  Widget _buildSmallImage(String imagePath, double height) {
    return Expanded(
      child: Container(
        height: height * 0.15, // Adjusted for better scaling
        margin: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
