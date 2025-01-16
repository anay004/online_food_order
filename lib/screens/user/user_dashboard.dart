import 'package:flutter/material.dart';
import 'package:online_food_order/models/post.dart';
import 'package:online_food_order/models/user.dart';
import 'package:online_food_order/screens/admin/admin_profile.dart';
import 'package:online_food_order/screens/user/cart_page.dart';
import 'package:online_food_order/screens/user/food_items.dart';
import 'package:online_food_order/screens/user/user_profile.dart';
import 'package:online_food_order/services/post_service.dart';

class UserDashboard extends StatefulWidget {
  final UserModel loggedInUser;

  UserDashboard({super.key, required this.loggedInUser});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  final PostService postService = PostService();
  List<Post> cart = []; // Cart is managed here

  void addToCart(Post item) {
    setState(() {
      cart.add(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Prevent back navigation by returning false
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text("Welcome!", style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          )),
          iconTheme: IconThemeData(
            color: Colors.white, // Set the drawer icon color to white
          ),
        ),
        drawer: Drawer(
          backgroundColor: Colors.white,
          child: Theme(
            data: Theme.of(context).copyWith(),
            child: AdminProfile(), // Drawer content with UserProfile
          ),
        ),
        body: Card(
          color: Colors.white, // Set the main card to white
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                // Restaurant Info Section (Banner)
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    image: DecorationImage(
                      image: AssetImage("assets/images/logo.png"), // Restaurant banner image
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    alignment: Alignment.bottomLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Chillox",
                          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),

                // Grid Cards Section
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 1.2, // Adjust this value to make cards rectangular
                    padding: EdgeInsets.all(10),
                    children: [
                      _buildDashboardCard(
                        context,
                        "Foods",
                        "Explore a variety of foods from our restaurant.",
                        Icons.fastfood,
                            () {
                          Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (context) => FoodItems()));
                        },
                      ),
                      _buildDashboardCard(
                        context,
                        "My Cart (${cart.length})", // Display cart item count
                        "View your selected items and proceed to checkout.",
                        Icons.shopping_cart,
                            () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CartPage(cartItems: cart), // Pass the cart items
                            ),
                          );
                        },
                      ),
                      _buildDashboardCard(
                        context,
                        "My Profile",
                        "View your profile information.",
                        Icons.person,
                            () {
                          Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (context) => UserProfile(userEmail: widget.loggedInUser.email ?? "")));
                              //builder: (context) => UserProfile(),
                        },
                      ),
                      _buildDashboardCard(
                        context,
                        "Orders",
                        "Track your past and current orders.",
                        Icons.history,
                            () {
                          // Navigate to Orders page
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardCard(
      BuildContext context,
      String title,
      String description,
      IconData icon,
      VoidCallback onTap,
      ) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.white, // Set card color to white
        elevation: 4,
        margin: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Round the card edges
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50,
              color: Colors.black,
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 5),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}


