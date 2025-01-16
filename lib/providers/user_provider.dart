import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserModel? _user;

  UserModel? get user => _user;

  UserProvider(this._user);

  void updateUser(UserModel updatedUser) {
    _user = updatedUser;
    notifyListeners();
  }

  Future<UserModel?> getUserByEmail(String email) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final userData = querySnapshot.docs.first.data();
        _user = UserModel.fromJson(userData);
        notifyListeners();
        return _user;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Failed to fetch user by email: $e');
    }
  }

  Future<void> updateUserImage(String email, String newImagePath) async {
    try {
      await _firestore.collection('users').doc(email).update({
        'userImage': newImagePath,
      });
      if (_user != null) {
        _user!.userImage = newImagePath;
        notifyListeners();
      }
    } catch (e) {
      throw Exception('Failed to update user image: $e');
    }
  }

  Future<void> registerUser({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      final user = UserModel(
        name: name,
        email: email,
        password: password,
        phone: phone,
        userImage: "",
      );
      await _firestore.collection('users').doc(email).set(user.toJson());
      _user = user;
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to register user: $e');
    }
  }

  Future<void> setUserData({
    required String name,
    required String email,
    required String phone,
    required String userImage,
  }) async {
    try {
      final updatedUser = UserModel(
        name: name,
        email: email,
        phone: phone,
        password: "",
        userImage: userImage,
      );
      await _firestore.collection('users').doc(email).update(updatedUser.toJson());
      _user = updatedUser;
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to set user data: $e');
    }
  }
}
