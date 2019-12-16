import 'dart:io';

import 'package:messaging_app/models/user.dart';

abstract class UserRepository {
  Future<User> currentUser();
  Future<bool> signOut();
  Future<User> signInWithGoogle();
  Future<User> signInWithFacebook();
  Future<User> signInWithEmailAndPassword(String email, String password);
  Future<User> createUserWithEmailAndPassword(
      String email, String password, String username);
  updateUsername(String userId, String newUsername);
  Future<String> uploadFile(String userId, String fileType, File fileToUpload);
}
