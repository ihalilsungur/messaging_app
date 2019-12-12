
import 'package:messaging_app/models/user.dart';

abstract class AuthBaseUserService {
  
  Future<User> currentUser();
  Future<User> signInAnonymously();
  Future<bool> signOut();
  Future<User> signInWithGoogle();
  Future<User> signInWithFacebook();
  Future<User> signInWithEmailAndPassword(String email,String password);
  Future<User> createUserWithEmailAndPassword(String email,String password,String username);
 
  
}