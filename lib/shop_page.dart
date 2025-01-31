import 'package:flutter/material.dart';
import 'home_page.dart'; // Import HomePage for navigation
import 'kits_page.dart';  // ✅ Import KitsPage for navigation



class ShopPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Column(
      children: [
GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => KitsPage()), // ✅ Navigates to KitsPage
    );
  },
  child: Container(
    height: 100, 
    width: 100, 
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15), 
      image: DecorationImage(
        image: AssetImage("assets/images/messi.jpeg"),
        fit: BoxFit.contain, 
      ),
    ),
  ),
),

        SizedBox(height: 5), // Space between image & text
        Text(
          "KITS",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ],
    ),
    Column(
      children: [
        Container(
          height: 80, 
          width: 100, 
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), 
            image: DecorationImage(
              image: AssetImage("assets/images/1.2.jpg"),
              fit: BoxFit.contain, 
            ),
          ),
        ),
        SizedBox(height: 5),
        Text(
          "EQUIPMENT",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ],
    ),
    Column(
      children: [
        Container(
          height: 100, 
          width: 100, 
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), 
            image: DecorationImage(
              image: AssetImage("assets/images/1.jpg"),
              fit: BoxFit.contain, 
            ),
          ),
        ),
        SizedBox(height: 5),
        Text(
          "MEMORABILIA",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  ],
),


SizedBox(height: 10), // Space before the banners

SizedBox(height: 10), // Space before the banners

              // ✅ Top Section: Vertical Banner + Two Horizontal Banners
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Vertical Banner
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/04d22d58b2444733ab0de6777cb41183~tplv-aphluv4xwc-resize-jpeg_800_800.jpeg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10), // Space between banners
                  
                  // Right Two Horizontal Banners
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.19,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/TRENDY.jpg"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: 10), // Space between banners
                        Container(
                          height: MediaQuery.of(context).size.height * 0.19,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/puma-future-ultimate-football-boots.jpeg"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20), // Space before products

              // ✅ Product Grid (2 Rows of 4 Products Each)
Column(
  children: [
    // ✅ First Row Heading - TIMELESS
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "TIMELESS",
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text(
            "Check out the iconic items in football history",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          SizedBox(height: 10), // Space before product row
        ],
      ),
    ),

    // ✅ First Row (Timeless Products)
    SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.18,
                width: MediaQuery.of(context).size.width * 0.24,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage("assets/images/images.jpeg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 5),
              Text("Vintage Jersey", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
              Text("RS 4000", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(width: 10),
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.18,
                width: MediaQuery.of(context).size.width * 0.24,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage("assets/images/ronaldo black.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 5),
              Text("Ronaldo Kit", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
              Text("RS 5000", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(width: 10),
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.18,
                width: MediaQuery.of(context).size.width * 0.24,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage("assets/images/kloop.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 5),
              Text("Klopp Signed", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
              Text("RS 8000", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(width: 10),
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.18,
                width: MediaQuery.of(context).size.width * 0.24,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage("assets/images/gullit.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 5),
              Text("Gullit Retro", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
              Text("RS 4500", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    ),

    SizedBox(height: 20), // Space before next section

    // ✅ Second Row Heading - KEEP EVOLVING
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "KEEP EVOLVING",
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text(
            "The game never stops same with the products",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          SizedBox(height: 10), // Space before product row
        ],
      ),
    ),

    // ✅ Second Row (Evolving Products)
    SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.18,
                width: MediaQuery.of(context).size.width * 0.24,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage("assets/images/2024-Argentina-Home-Long-Sleeve-Jersey.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 5),
              Text("Argentina Jersey", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
              Text("RS 5200", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(width: 10),
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.18,
                width: MediaQuery.of(context).size.width * 0.24,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage("assets/images/image_9c32ddac-37b9-4304-9d6b-e8137d8f2955.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 5),
              Text("Limited Edition", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
              Text("RS 6000", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(width: 10),
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.18,
                width: MediaQuery.of(context).size.width * 0.24,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage("assets/images/NEYMAR.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 5),
              Text("Neymar Jersey", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
              Text("RS 4800", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(width: 10),
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.18,
                width: MediaQuery.of(context).size.width * 0.24,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage("assets/images/18-1.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 5),
              Text("Special Edition", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
              Text("RS 5500", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    ),
  ],
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

  // ✅ Function to Build Product Cards
  Widget _buildProductCard(BuildContext context, String imagePath) {
    return Card(
      color: Colors.black,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                imagePath,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[900],
                    child: Center(child: Icon(Icons.image_not_supported, color: Colors.red, size: 40)),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 5),
          Text(
            "PRODUCT NAME",
            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          Text(
            "RS 4500",
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
        ],
      ),
    );
  }
}
