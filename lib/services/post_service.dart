import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_food_order/models/post.dart';

class PostService {
  final CollectionReference postCollection =
  FirebaseFirestore.instance.collection('post');

  // Get all posts from Firestore
  Stream<List<Post>> getPost() {
    return postCollection.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        try {
          return Post.fromJson(doc.data() as Map<String, dynamic>);
        } catch (e) {
          print("Error parsing post: ${doc.id} -> ${doc.data()}");
          return null;
        }
      }).whereType<Post>().toList(); // Exclude null values
    });
  }

  // Add a new post to Firestore
  Future<void> addPost(Post post) async {
    try {
      await postCollection.doc(post.id!).set(post.toJson(), SetOptions(merge: false));
    } catch (e) {
      print("Error adding post: $e");
      rethrow;
    }
  }

  // Update an existing post in Firestore
  Future<void> updatePost(Post post) async {
    try {
      if (post.id != null && post.id!.isNotEmpty) {
        await postCollection.doc(post.id!).update(post.toJson());
      } else {
        throw Exception("Post ID is null or empty!");
      }
    } catch (e) {
      print("Error updating post: $e");
      rethrow;
    }
  }

  // Delete a post from Firestore
  Future<void> deletePost(String id) async {
    try {
      await postCollection.doc(id).delete();
      print("Post with ID $id deleted successfully.");
    } catch (e) {
      print("Error deleting post with ID $id -> $e");
      rethrow;
    }
  }
}
