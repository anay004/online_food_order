import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_food_order/models/post.dart';

import 'cart_page.dart';


class FoodItems extends StatefulWidget {
  const FoodItems({super.key});

  @override
  State<FoodItems> createState() => _FoodItemsState();
}

class _FoodItemsState extends State<FoodItems> {
  String searchQuery = ''; // Variable for search query
  TextEditingController searchController = TextEditingController(); // Controller for search text field
  List<Post> cartItems = []; // List to hold cart items

  void addToCart(Post post) {
    // Check if the item is already in the cart
    if (cartItems.any((item) => item.id == post.id)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${post.foodName} is already in the cart!'),
        ),
      );
    } else {
      // Add the item to the cart
      setState(() {
        cartItems.add(post);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${post.foodName} added to the cart!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: true, // Shows back arrow
        backgroundColor: Colors.black,
        title: const Text(
          "Food Items",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            color: Colors.white,
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // Navigate to the CartPage with cart items
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(cartItems: cartItems),
                ),
              );
            },
          ),
        ],
      ),
      body: Card(
        color: Colors.white,
        elevation: 5,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: const InputDecoration(
                  hintText: "Search by food category",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('post')
                    .where('category', isGreaterThanOrEqualTo: searchQuery)
                    .where('category', isLessThan: searchQuery + 'z')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        "No posts yet! Start adding some.",
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  }

                  // Access documents and map them to Post models
                  final posts = snapshot.data!.docs.map((doc) {
                    return Post.fromJson(doc.data() as Map<String, dynamic>);
                  }).toList();

                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Card(
                          elevation: 5,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: InkWell(
                            onTap: () {
                              // Navigate to RestaurantDetails page (optional)
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  // Food Image
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                    ),
                                    child: post.foodImage != null
                                        ? Image.network(
                                      post.foodImage!,
                                      fit: BoxFit.cover,
                                      height: 120,
                                      width: double.infinity,
                                    )
                                        : const Icon(
                                      Icons.image,
                                      size: 50,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  // Food Details
                                  Text(
                                    post.foodName ?? "No Name",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    "Category: ${post.category ?? "Will be announced"}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    "Price: ${post.price ?? "Will be announced"} BDT",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.teal,
                                    ),
                                  ),

                                  // Text(
                                  //   "${post.rating ?? "No"} Rating",
                                  //   style: const TextStyle(
                                  //     fontWeight: FontWeight.bold,
                                  //     fontSize: 14,
                                  //     color: Colors.teal,
                                  //   ),
                                  // ),

                                  // Add to Cart Button
                                  ElevatedButton(
                                    onPressed: () {
                                      addToCart(post);
                                    },
                                    child: const Text(
                                      "Add to Cart",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

