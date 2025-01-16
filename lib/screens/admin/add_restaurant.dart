import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:online_food_order/models/post.dart';
import 'package:online_food_order/screens/admin/admin_dashboard.dart';
import 'package:online_food_order/services/post_service.dart';

import '../../services/cloudinary_service.dart';

class AddRestaurant extends StatefulWidget {
  final Function(Post) onPostAdded;
  const AddRestaurant({super.key, required this.onPostAdded});

  @override
  State<AddRestaurant> createState() => _AddRestaurantState();
}

class _AddRestaurantState extends State<AddRestaurant> {
  var idController = TextEditingController();
  var priceController = TextEditingController();
  var foodNameController = TextEditingController();
  var categoryController = TextEditingController();
  var ratingController = TextEditingController();
  dynamic foodImage;
  final GlobalKey<FormState> infoFormKey = GlobalKey();

  @override
  void initState() {
  }

  // Open file picker and handle the selected file
  Future<void> _openFilePicker() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        allowedExtensions: ["jpg", "jpeg", "png", "mp4"],
        type: FileType.custom,
      );

      if (result != null && result.files.single.path != null) {
        String filePath = result.files.single.path!; // Get the file path

        // Upload to Cloudinary
        dynamic uploadResult = await uploadToCloudinary(result); // Pass result directly here
        if (uploadResult != null) {
          setState(() {
            foodImage = uploadResult['url']; // Get the URL from the returned map
          });
          print("Uploaded to Cloudinary: ${uploadResult['url']}");
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
  // Submit the post
  void _submitPost() {
    if (idController.text.isEmpty ||
        priceController.text.isEmpty ||
        ratingController.text.isEmpty ||
        foodNameController.text.isEmpty ||
        foodImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields and add an image!")),
      );
      return;
    }

    // Create a new PostModel with post data
    final newPost = Post(
      id: idController.text,
      foodName: foodNameController.text,
      price: double.tryParse(priceController.text) ?? 0.0,
      foodImage: foodImage, // Use foodImage directly
      category: categoryController.text,
      rating: ratingController.text,
    );

    // Call the onPostAdded callback to add the new post
    widget.onPostAdded(newPost);

    // Clear fields
    idController.clear();
    priceController.clear();
    foodNameController.clear();
    categoryController.clear();
    ratingController.clear();
    setState(() {
      foodImage = null;
    });

    Fluttertoast.showToast(msg: "Restaurant Added");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
      ),
      body:
      SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: infoFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ID Input Field
              Text(
                "ID:",
                style: GoogleFonts.lato(
                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                style: GoogleFonts.lato(
                  textStyle: TextStyle(fontSize: 16, color: Colors.black),
                ),
                controller: idController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: "Enter ID",
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
                    return "Please enter ID";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Food Name Input Field
              Text(
                "Food Name:",
                style: GoogleFonts.lato(
                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                style: GoogleFonts.lato(
                  textStyle: TextStyle(fontSize: 16, color: Colors.black),
                ),
                controller: foodNameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: "Enter Food Name",
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
                    return "Please enter Food Name";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Food Category Input Field
              Text(
                "Food Category:",
                style: GoogleFonts.lato(
                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                style: GoogleFonts.lato(
                  textStyle: TextStyle(fontSize: 16, color: Colors.black),
                ),
                controller: categoryController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: "Enter Category",
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
                    return "Please enter Food Category";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Price Input Field
              Text(
                "Price:",
                style: GoogleFonts.lato(
                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                style: GoogleFonts.lato(
                  textStyle: TextStyle(fontSize: 16, color: Colors.black),
                ),
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: "Enter Price",
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
                    return "Please enter Price";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Rating Input Field
              // Text(
              //   "Rating:",
              //   style: GoogleFonts.lato(
              //     textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              //   ),
              // ),
              // SizedBox(height: 8),
              // TextFormField(
              //   style: GoogleFonts.lato(
              //     textStyle: TextStyle(fontSize: 16, color: Colors.black),
              //   ),
              //   controller: ratingController,
              //   keyboardType: TextInputType.number,
              //   decoration: InputDecoration(
              //     filled: true,
              //     fillColor: Colors.white,
              //     labelText: "Enter Rating",
              //     labelStyle: GoogleFonts.lato(
              //       color: Colors.black.withOpacity(0.7),
              //       fontWeight: FontWeight.w500,
              //     ),
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(12),
              //       borderSide: BorderSide(
              //         color: Colors.grey.shade300,
              //         width: 2,
              //       ),
              //     ),
              //     enabledBorder: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(12),
              //       borderSide: BorderSide(
              //         color: Colors.grey.shade300,
              //         width: 2,
              //       ),
              //     ),
              //     focusedBorder: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(12),
              //       borderSide: BorderSide(
              //         color: Colors.black,
              //         width: 2,
              //       ),
              //     ),
              //     contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 12),
              //   ),
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return "Please enter Rating";
              //     }
              //     return null;
              //   },
              // ),
              // SizedBox(height: 20),

              // Food Image Picker
              foodImage != null
                  ? Container(
                height: 200, // Set a fixed height for the image box
                child: SingleChildScrollView(
                  child: Image.network(
                    foodImage,
                    width: double.infinity,
                    fit: BoxFit.contain, // Ensures the image maintains its aspect ratio
                  ),
                ),
              )
                  : ElevatedButton.icon(
                onPressed: _openFilePicker,
                icon: Icon(Icons.photo),
                label: Text("Add Image"),
              ),
              SizedBox(height: 30,),

              // Save Button
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.black,
                  ),
                  onPressed: _submitPost,
                  child: Text(
                    "ADD Post",
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
