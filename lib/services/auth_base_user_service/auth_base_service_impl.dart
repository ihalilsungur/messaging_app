import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:messaging_app/models/user.dart';
import 'package:messaging_app/services/auth_base_user_service/auth_base_user_service.dart';



class AuthBaseServiceImpl implements AuthBaseUserService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<User> currentUser() async {
    try {
      FirebaseUser _user = await _firebaseAuth.currentUser();
      if(_user != null)
      return _userFromFirebase(_user);
      else return null;
    } catch (e) {
      print("currentUser metodunda oluşan hata : " + e.toString());
      return null;
    }
  }

  User _userFromFirebase(FirebaseUser user) {
    if (user == null) return null;
    return User(userId: user.uid, email: user.email);
  }


  @override
  Future<bool> signOut() async {
    try {
      final _googleAuth = GoogleSignIn();
      await _googleAuth.signOut();
      final _facabookLogin = FacebookLogin();
      await _facabookLogin.logOut();
      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      print("signOut metodunda oluşan hata : " + e.toString());
      return false;
    }
  }

  @override
  Future<User> signInWithGoogle() async {
    try {
      GoogleSignIn _googleSingIn = GoogleSignIn();
      GoogleSignInAccount _googleUser = await _googleSingIn.signIn();
      if (_googleUser != null) {
        GoogleSignInAuthentication _googleAuth =
            await _googleUser.authentication;
        if (_googleAuth.idToken != null && _googleAuth.accessToken != null) {
          AuthResult result = await _firebaseAuth.signInWithCredential(
              GoogleAuthProvider.getCredential(
                  idToken: _googleAuth.idToken,
                  accessToken: _googleAuth.accessToken));
          FirebaseUser _user = result.user;
          return _userFromFirebase(_user);
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      print(
          "services'in içindeki  FirebaseAuthService içindeki   signInWithGoogle() metodunda oluşan hata : " +
              e.toString());
      return null;
    }
  }

  @override
  Future<User> signInWithFacebook() async {
  
      final _facebookLogin = FacebookLogin();
      FacebookLoginResult _facebookLoginResult =
          await _facebookLogin.logIn(["public_profile", "email"]);

      switch (_facebookLoginResult.status) {
        case FacebookLoginStatus.loggedIn:
          if (_facebookLoginResult.accessToken != null) {
            AuthResult result = await _firebaseAuth.signInWithCredential(
                FacebookAuthProvider.getCredential(
                    accessToken: _facebookLoginResult.accessToken.token));
            FirebaseUser _user = result.user;
            return _userFromFirebase(_user);
          } else {
            return null;
          }
          break;
        case FacebookLoginStatus.cancelledByUser:
          print("Facebook ile giriş kullanıcı tarafından iptal edildi.");
          break;
        case FacebookLoginStatus.error:
          print(
              "FirebaseAuthService sinifinda bulunan signInWithFacebook() metodta oluşan hata : " +
                  _facebookLoginResult.errorMessage);
          break;
      }
      return null;
    
  }

  @override
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(result.user);
  }

  @override
  Future<User> createUserWithEmailAndPassword(
      String email, String password, String username) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);

    return _userFromFirebase(result.user);
  }

}
