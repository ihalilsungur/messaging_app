import 'dart:io';
import 'package:messaging_app/locator%20.dart';

import 'package:messaging_app/models/user.dart';
import 'package:messaging_app/repository/user_repository/user_repository.dart';
import 'package:messaging_app/services/auth_base_user_service/auth_base_service_impl.dart';
import 'package:messaging_app/services/db_user_service_impl/db_user_service_impl.dart';
import 'package:messaging_app/services/fake_authentication_service/fake_authentication_service.dart';
import 'package:messaging_app/services/storage_base/storage_base_service_impl.dart';


enum AppMode { DEBUG, RELEASE }

class UserRepositoryImpl implements UserRepository {
  AuthBaseServiceImpl _firebaseAuthService = locator<AuthBaseServiceImpl>();
  FakeAuthhenticationService _fakeAuthhenticationService =
      locator<FakeAuthhenticationService>();
  DbUserServiceImpl _firestoreDbService = locator<DbUserServiceImpl>();
  StorageBaseServiceImpl _firebaseStorageService =
      locator<StorageBaseServiceImpl>();

  // List<User> _allUsersList = [];

  //hangi veritabana göre calisacagini ayarliyoruz.
  AppMode appMode = AppMode.RELEASE;
  @override
  Future<User> currentUser() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthhenticationService.currentUser();
    } else {
      User _user = await _firebaseAuthService.currentUser();
      if (_user != null) {
        return await _firestoreDbService.readUser(_user.userId);
      } else {
        return null;
      }
    }
  }


  @override
  Future<bool> signOut() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthhenticationService.signOut();
    } else {
      return await _firebaseAuthService.signOut();
    }
  }

  @override
  Future<User> signInWithGoogle() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthhenticationService.signInWithGoogle();
    } else {
      User _user = await _firebaseAuthService.signInWithGoogle();
      if (_user != null) {
        bool result = await _firestoreDbService.saveUser(_user);
        if (result) {
          return await _firestoreDbService.readUser(_user.userId);
        } else {
          await _fakeAuthhenticationService.signOut();
          return null;
        }
      } else {
        return null;
      }
    }
  }

  @override
  Future<User> signInWithFacebook() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthhenticationService.signInWithFacebook();
    } else {
      User _user = await _firebaseAuthService.signInWithFacebook();
      if (_user != null) {
        bool _result = await _firestoreDbService.saveUser(_user);
        if (_result) {
          return await _firestoreDbService.readUser(_user.userId);
        } else {
          await _firebaseAuthService.signOut();
          return null;
        }
      } else {
        return null;
      }
    }
  }

  @override
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthhenticationService.signInWithEmailAndPassword(
          email, password);
    } else {
      User _user = await _firebaseAuthService.signInWithEmailAndPassword(
          email, password);
      if (_user != null)
        return await _firestoreDbService.readUser(_user.userId);
      else
        return null;
    }
  }

  @override
  Future<User> createUserWithEmailAndPassword(
      String email, String password, String username) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthhenticationService.createUserWithEmailAndPassword(
          email, password, username);
    } else {
      User _user = await _firebaseAuthService.createUserWithEmailAndPassword(
          email, password, username);
      _user.username = username;
      if (_user != null) {
        bool _result = await _firestoreDbService.saveUser(_user);
        if (_result) {
          return await _firestoreDbService.readUser(_user.userId);
        } else {
          return null;
        }
      } else {
        return null;
      }
    }
  }

  updateUsername(String userId, String newUsername) async {
    if (appMode == AppMode.DEBUG) {
      return false;
    } else {
      return await _firestoreDbService.updateUsername(userId, newUsername);
    }
  }

  Future<String> uploadFile(
      String userId, String fileType, File fileToUpload) async {
    if (appMode == AppMode.DEBUG) {
      return "dosya indirma linki";
    } else {
      var _profilePhotoUrl = await _firebaseStorageService.uploadFile(
          userId, fileType, fileToUpload);
      await _firestoreDbService.updateProfilePhoto(userId, _profilePhotoUrl);
      return _profilePhotoUrl;
    }
  }

}
