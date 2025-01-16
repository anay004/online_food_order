import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:online_food_order/screens/user/user_login.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:online_food_order/services/cloudinary_service.dart'; // Assuming Cloudinary service is in this path

import '../../providers/user_provider.dart';

class UserProfile extends StatefulWidget {
  final String? userEmail;
  const UserProfile({super.key, required this.userEmail});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String? name;
  String? email;
  String? phone;
  String? userImage;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final userData = await userProvider.getUserByEmail(widget.userEmail!);

      if (userData != null) {
        setState(() {
          name = userData.name;
          email = userData.email;
          phone = userData.phone;
          userImage = userData.userImage; // Fetch user image from Firestore
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User not found")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to fetch user data")),
      );
    }
  }

  // Open File Picker to pick image and upload to Cloudinary
  Future<void> _openFilePicker() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        allowedExtensions: ["jpg", "jpeg", "png"],
        type: FileType.custom,
      );

      if (result != null && result.files.single.path != null) {
        String filePath = result.files.single.path!;

        print("Selected file: $filePath");

        // Upload to Cloudinary
        dynamic uploadResult = await uploadToCloudinary(result);
        if (uploadResult != null) {
          setState(() {
            userImage = uploadResult['url'];
          });

          final userProvider = Provider.of<UserProvider>(context, listen: false);
          await userProvider.updateUserImage(widget.userEmail!, userImage!);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Profile picture updated successfully")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to upload image to Cloudinary")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No file selected")),
        );
      }
    } catch (e) {
      print("Error picking file: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to pick file")),
      );
    }
  }


  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const UserLogin()),
          (route) => false,
    );
  }

  Widget _buildInfoCard(String title, String content) {
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                "$title: $content",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "My Profile",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: name == null || email == null || phone == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Profile Picture in Card
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _openFilePicker, // Change to _openFilePicker to allow file picking
                    child: CircleAvatar(
                      backgroundColor: Colors.blueGrey.withOpacity(0.5),
                      radius: 90,
                      backgroundImage: userImage != null
                          ? NetworkImage(userImage!) // Display the picked image
                          : const AssetImage('assets/images/icon.png') as ImageProvider,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: CircleAvatar(
                          backgroundColor: Colors.grey,
                          radius: 18,
                          child: const Icon(
                            Icons.camera_alt,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),

            // User Details in List View Cards
            _buildInfoCard("Name", name ?? "No Name"),
            _buildInfoCard("Email", email ?? "No Email"),
            _buildInfoCard("Phone", phone ?? "No Phone"),

            const SizedBox(height: 20),

            // Logout Button
            ElevatedButton(
              onPressed: _logout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Logout",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
