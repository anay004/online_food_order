import 'dart:io';

import 'package:flutter/material.dart';
import 'package:online_food_order/models/post.dart';

class RestaurantDetails extends StatelessWidget {
  final Post post;

  // Constructor to receive Post data
  const RestaurantDetails({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
        Text(post.foodName ?? "Restaurant Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
        Column(
          children: [
            SizedBox(height: 20),
            Text(
              post.foodName ?? "No Name",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "ID: ${post.id ?? 'No ID'}",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),



            post.foodImage != null && post.foodImage!.isNotEmpty
                ? ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(
                File(post.foodImage!),
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            )
                : Icon(
              Icons.account_circle_outlined,
              size: 100,
            ),
            SizedBox(height: 20),
            Text(
                (post.price ?? "No Price") as String,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            // Display other details here (e.g., description, price, etc.)
          ],
        ),
      ),
    );
  }
}
