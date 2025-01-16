import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:online_food_order/screens/admin/add_restaurant.dart';
import 'package:online_food_order/screens/admin/admin_profile.dart';
import 'package:online_food_order/screens/admin/restaurant_details.dart';
import 'package:online_food_order/services/post_service.dart';

import '../../models/post.dart';
import '../user/user_login.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final PostService postService = PostService();
  List<Post> post = [];

  @override
  void initState() {
    super.initState();
    loadAllData();
  }

  Future<void> loadAllData() async {
    postService.getPost().listen((studentList) {
      setState(() {
        post = studentList;
      });
    }, onError: (error) {
      Fluttertoast.showToast(
        msg: "Error fetching data: $error",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
    });
  }

  Future<void> deleteData(String id) async {
    await postService.deletePost(id).then((_) {
      Fluttertoast.showToast(msg: "Post deleted successfully");
      loadAllData();
    }).catchError((error) {
      Fluttertoast.showToast(msg: "Failed to delete Post: $error");
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false, // Disables back arrow
          backgroundColor: Colors.black,
          title: Text(
            "Admin Panel",
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              color: Colors.white,
              icon: const Icon(Icons.person),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminProfile()),
                );
              },
            ),
          ],
        ),
        body:
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('post').snapshots(),
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
                return Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: InkWell(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => RestaurantDetails(post: post),
                      //   ),
                      // );
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
                              height: 120, // Adjust height as needed
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
                            "ID: ${post.id ?? " "}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.teal,
                            ),
                          ),
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
                            "Price: ${post.price ?? "Will be announced"}BDT",
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

                          // Delete Icon
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Delete Confirmation"),
                                    content: const Text(
                                        "Are you sure you want to delete this item?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("No"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          deleteData(post.id ?? "");
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("Yes"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: const Icon(
                              Icons.delete,
                              size: 30,
                              color: Colors.redAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
        bottomNavigationBar: ConvexAppBar(
          backgroundColor: Colors.black,
          activeColor: Colors.grey,
          curveSize: 0,
          items: const [
            TabItem(
              icon: Icons.add_circle_outline,
              title: "Add Post",
            ),
          ],
          onTap: (int index) {
            if (index == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddRestaurant(onPostAdded: (newPost) async {
                await postService.addPost(newPost as Post); // Add post to Firestore
                setState(() {});
              },),),
              );
            }
          },
        ),
      ),
    );
  }

}