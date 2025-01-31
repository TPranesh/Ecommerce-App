import 'package:flutter/material.dart';
import 'home_page.dart';  // ✅ Navigate to HomePage on success
import 'register.dart';  // ✅ Import RegisterPage

class LoginPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Login"),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85, // ✅ Responsive width
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white, // ✅ Box background
            borderRadius: BorderRadius.circular(10),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // ✅ Wrap content
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ Heading
              Text("Login", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 15),

              // ✅ Username
              Text("Username", style: TextStyle(fontSize: 16)),
              SizedBox(height: 5),
              TextField(
                controller: usernameController, // ✅ Captures username input
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter your username",
                ),
              ),
              SizedBox(height: 15),

              // ✅ Password
              Text("Password", style: TextStyle(fontSize: 16)),
              SizedBox(height: 5),
              TextField(
                controller: passwordController, // ✅ Captures password input
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter your password",
                ),
              ),
              SizedBox(height: 20),

              // ✅ Login & Register Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 🔴 Login Button
                  ElevatedButton(
                    onPressed: () {
                      String username = usernameController.text;
                      String password = passwordController.text;

                      if (username == "user123" && password == "password123") {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()), // ✅ Goes to HomePage
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Incorrect Credentials", style: TextStyle(color: Colors.white)),
                          backgroundColor: Colors.red),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    ),
                    child: Text("Login", style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(width: 10), // Space between buttons

                  // 🔵 Register Button (Smaller & Side)
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blue, // Blue text color
                    ),
                    child: Text("Register"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.black, // ✅ Background color to highlight the box
    );
  }
}
