

import 'package:messaging_app/models/user.dart';
import 'package:messaging_app/services/auth_base_user_service/auth_base_user_service.dart';


class FakeAuthhenticationService implements AuthBaseUserService {
  String userId = "1231231231234234234";
  String email ="sungur@gmail.com";
  @override
  Future<User> currentUser() async {
    return await Future.value(User(userId: userId,email: email));
  }

  @override
  Future<bool> signOut() {
    return Future.value(true);
  }

  @override
  Future<User> signInWithGoogle()async {
  
    return await Future.delayed(
        Duration(seconds: 2), () => User(userId: "google_singIn:1233444",email: email));
  }

  @override
  Future<User> signInWithFacebook() async{
   
     return await Future.delayed(
        Duration(seconds: 2), () => User(userId: "facebook_signIn:12345",email: email));
  }

  @override
  Future<User> signInWithEmailAndPassword(String email ,String password) async{
    return await Future.delayed(
        Duration(seconds: 2), () => User(userId: "email_signIn:12345",email: email));
  }

  @override
  Future<User> createUserWithEmailAndPassword(String email, String password,String username) async{
    return await Future.delayed(
        Duration(seconds: 2), () => User(userId: "email_createdUser:12345",email: email));
  }
}
