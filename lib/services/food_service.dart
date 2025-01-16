// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:online_food_order/models/food.dart';
// import 'package:online_food_order/models/post.dart';
//
// class FoodService {
//   // Reference to the Firestore collection
//   final CollectionReference postCollection =
//   FirebaseFirestore.instance.collection('food');
//
//   // Get all post from Firestore
//   Stream<List<Food>> getFood() {
//     return postCollection.snapshots().map((querySnapshot) {
//       // Convert the Firestore snapshot to a list of Post objects
//       return querySnapshot.docs.map((doc) {
//         try {
//           return Food.fromJson(doc.data() as Map<String, dynamic>);
//         } catch (e) {
//           print("Error parsing post: ${doc.id} -> ${doc.data()}");
//           return Food(
//             price: 'price',
//             foodName: 'foodName',
//             foodImage: 'foodImage',
//
//           ); // Return empty Post on error
//         }
//       }).toList();
//     });
//   }
//
//   // Check if a post exists in Firestore by ID
//   Future<bool> doesFoodExist(String id) async {
//     final docSnapshot = await postCollection.doc(id).get();
//     return docSnapshot.exists;
//   }
//
//   // Add a new post to Firestore
//   Future<void> addFood(Food post) async {
//     if (await doesFoodExist(post.id!)) {
//       print("Error: A post with this ID already exists!");
//       return;
//     }
//
//     await postCollection.doc(post.id!).set(post.toJson());
//   }
//
//   // Update an existing post in Firestore
//   Future<void> updatePost(Food post) async {
//     if (post.id != null && post.id!.isNotEmpty) {
//       await postCollection.doc(post.id!).update(post.toJson());
//     } else {
//       print("Error: Post ID is null or empty!");
//     }
//   }
//
//   // Delete a post from Firestore
//   Future<void> deletePost(String id) async {
//     try {
//       await postCollection.doc(id).delete();
//       print("Post with ID $id deleted successfully.");
//     } catch (e) {
//       print("Error deleting post with ID $id -> $e");
//     }
//   }
// }
