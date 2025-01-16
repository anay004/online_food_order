import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_food_order/models/auth.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';
import '../../providers/user_provider.dart';
import '../admin/admin_login.dart';
import 'user_dashboard.dart';
import 'user_register.dart';

class UserLogin extends StatefulWidget {
  const UserLogin({super.key});

  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final Auth _auth = Auth(); // Initialize Auth class
  bool _isObscured = true;

  Future<void> checkCredentials() async {
    String email = emailController.text;
    String password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in both fields")),
      );
      return;
    }

    try {
      UserCredential? userCredential = await _auth.loginUser(email: email, password: password);
      print("from login $userCredential");
      if (userCredential == null || userCredential.user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid email or password")),
        );
        return;
      }

      UserModel loggedInUser = UserModel(
        name: userCredential.user?.displayName ?? "No Name",
        email: userCredential.user?.email ?? email,
        password: password,
        phone: userCredential.user?.phoneNumber ?? "No Phone",
      );

      context.read<UserProvider>().updateUser(loggedInUser);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => UserDashboard(loggedInUser: loggedInUser),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login Successful!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Padding around the card
            child:
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 8, // Elevation for shadow effect
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0), // Padding inside the card
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),
                          const Text(
                            "Login to continue",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Email Field
                          TextFormField(
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(fontSize: 16, color: Colors.black),
                            ),
                            controller: emailController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.email),
                              filled: true,
                              fillColor: Colors.white,
                              labelText: "Enter Email",
                              labelStyle: GoogleFonts.lato(
                                color: Colors.black.withOpacity(0.7),
                                fontWeight: FontWeight.w500,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                  width: 2,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                  width: 2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 2,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter Email";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          // Password Field
                          TextFormField(
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(fontSize: 16, color: Colors.black),
                            ),
                            controller: passwordController,
                            keyboardType: TextInputType.text,
                            obscureText: _isObscured,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isObscured ? Icons.visibility_off : Icons.visibility,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isObscured = !_isObscured; // Toggle password visibility
                                  });
                                },
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              labelText: "Enter Password",
                              labelStyle: GoogleFonts.lato(
                                color: Colors.black.withOpacity(0.7),
                                fontWeight: FontWeight.w500,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                  width: 2,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                  width: 2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 2,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter Password";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          // Login Button
                          ElevatedButton(
                            onPressed: checkCredentials,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text("Login", style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),),
                          ),
                          const SizedBox(height: 20),

                          // Register Option
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "New User?",
                                style: TextStyle(fontSize: 14),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const UserRegister()),
                                  );
                                },
                                child: const Text(
                                  "Register here",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),

                  // Admin Icon Button
                  Positioned(
                    top: 10,
                    left: 10,
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AdminLogin()),
                        );
                      },
                      icon: const Icon(Icons.admin_panel_settings),
                      tooltip: 'Admin Login',
                    ),
                  ),
                ],
              ),
            ),

          ),
        ),
      ),
    );
  }
}
