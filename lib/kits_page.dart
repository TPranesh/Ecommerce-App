import 'package:flutter/material.dart';
import 'home_page.dart';
import 'package:ecommerce_assignment/shop_page.dart';
import 'product_page.dart';

class KitsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isLandscape = screenWidth > screenHeight; // Detect landscape mode

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Container(
              width: double.infinity,
              height: screenHeight * 0.60,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/messi.jpeg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "FOOTBALL KITS",
                    style: TextStyle(
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 10),

            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProductPage()), 
                        );
                      },
                      child: Container(
                        height: screenHeight * 0.18,
                        width: isLandscape ? screenWidth * 0.25 : screenWidth * 0.28,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: AssetImage("assets/images/Barcelona-Away-Football-Shirt-2425 (1)-600x600.jpg"),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text("Barca Away Kit", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    Text("RS 5000", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                  ],
                ),

                Column(
                  children: [
                    Container(
                      height: screenHeight * 0.18,
                      width: isLandscape ? screenWidth * 0.25 : screenWidth * 0.28,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: AssetImage("assets/images/R.jpg"),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text("Euro Portugal Kit", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    Text("RS 5200", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                  ],
                ),

                Column(
                  children: [
                    Container(
                      height: screenHeight * 0.18,
                      width: isLandscape ? screenWidth * 0.25 : screenWidth * 0.28,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: AssetImage("assets/images/s-l1200.jpg"),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text("AC Milan Kit", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    Text("RS 6000", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),

            SizedBox(height: 10),

            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Container(
                      height: screenHeight * 0.18,
                      width: isLandscape ? screenWidth * 0.25 : screenWidth * 0.28,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: AssetImage("assets/images/2024-Argentina-Home-Long-Sleeve-Jersey.jpg"),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text("Argentina Kit", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    Text("RS 4800", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                  ],
                ),

                Column(
                  children: [
                    Container(
                      height: screenHeight * 0.18,
                      width: isLandscape ? screenWidth * 0.25 : screenWidth * 0.28,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: AssetImage("assets/images/p-13322490_u-kg7087e2u0ra66umc9sb_v-1f7cfd43fa6c48f394d7b7bcef6427b3.jpg"),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text("Man United Kit", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    Text("RS 5500", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                  ],
                ),

                Column(
                  children: [
                    Container(
                      height: screenHeight * 0.18,
                      width: isLandscape ? screenWidth * 0.25 : screenWidth * 0.28,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: AssetImage("assets/images/psg.jpg"),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text("PSG Kit", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    Text("RS 4700", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),

            SizedBox(height: 10),

            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Container(
                      height: screenHeight * 0.18,
                      width: isLandscape ? screenWidth * 0.25 : screenWidth * 0.28,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: AssetImage("assets/images/barca 3rd kit.jpg"),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text("Barca 3rd Kit", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    Text("RS 4500", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                  ],
                ),
                                Column(
                  children: [
                    Container(
                      height: screenHeight * 0.18,
                      width: isLandscape ? screenWidth * 0.25 : screenWidth * 0.28,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: AssetImage("assets/images/mancity.jpg"),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text("MAN CITY Kit", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    Text("RS 4500", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                  ],
                ),
                                Column(
                  children: [
                    Container(
                      height: screenHeight * 0.18,
                      width: isLandscape ? screenWidth * 0.25 : screenWidth * 0.28,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: AssetImage("assets/images/inter.jpg"),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text("INTER MILLAN Kit", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    Text("RS 4500", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),

            SizedBox(height: 20),
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
