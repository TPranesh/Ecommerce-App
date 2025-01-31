import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 31, 10, 10),
        title: Text("Register"),
        leading: IconButton( // 
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // 
          },
        ),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85, // 
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white, // 
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(color: Colors.black26, blurRadius: 5),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // 
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //
              Text(
                "Register",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),

              
              Text("Username", style: TextStyle(fontSize: 16)),
              SizedBox(height: 5),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter your username",
                ),
              ),
              SizedBox(height: 15),

              // 
              Text("Password", style: TextStyle(fontSize: 16)),
              SizedBox(height: 5),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter your password",
                ),
              ),
              SizedBox(height: 20),

              // 
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Handle Register
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  ),
                  child: Text("REGISTER", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 0, 0, 0), // 
    );
  }
}
