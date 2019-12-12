import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:messaging_app/locator%20.dart';
import 'package:messaging_app/models/user.dart';
import 'package:messaging_app/repository/user_repository_impl/user_repository_impl.dart';
import 'package:messaging_app/services/auth_base_user_service/auth_base_service_impl.dart';

enum ViewState { Idle, Busy }

class UserViewModel with ChangeNotifier implements AuthBaseServiceImpl {
  ViewState _viewState = ViewState.Idle;
  UserRepositoryImpl _userRepositoryImpl = locator<UserRepositoryImpl>();

  User _user;
  UserViewModel() {
    currentUser();
  }
  ViewState get viewState => _viewState;

  set viewState(ViewState value) {
    _viewState = value;
    notifyListeners();
  }

  User get user => _user;

 
  @override
  Future<User> currentUser() async {
    try {
      viewState = ViewState.Busy;
      _user = await _userRepositoryImpl.currentUser();
      if(_user != null)
      return _user;
      else return null;
    } catch (e) {
      print(
          "viewmodel'in  User_View_modelde içindeki currentUser() metodta oluşan Hata : " +
              e.toString());
      return null;
    } finally {
      viewState = ViewState.Idle;
    }
  }

  @override
  Future<User> signInAnonymously() async {
    try {
      viewState = ViewState.Busy;
      _user = await _userRepositoryImpl.signInAnonymously();
      return _user;
    } catch (e) {
      print(
          "viewmodel'in içindeki User_View_modelde signInAnonymously() metodunda oluşan hata : " +
              e.toString());
      return null;
    } finally {
      viewState = ViewState.Idle;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      viewState = ViewState.Busy;
      bool result = await _userRepositoryImpl.signOut();
      _user = null;
      return result;
    } catch (e) {
      print(
          "viewmodel'in içindeki User_View_modelde içindeki  signOut() metodunda oluşan hata : " +
              e.toString());
      return false;
    } finally {
      viewState = ViewState.Idle;
    }
  }

  @override
  Future<User> signInWithGoogle() async {
    try {
      viewState = ViewState.Busy;
      _user = await _userRepositoryImpl.signInWithGoogle();
      if(_user  != null)
      return _user;
      else return null;
    } catch (e) {
      print(
          "viewmodel'in içindeki User_View_modelde signInWithGoogle() metodunda oluşan hata : " +
              e.toString());
      return null;
    } finally {
      viewState = ViewState.Idle;
    }
  }

  @override
  Future<User> signInWithFacebook() async {
    try {
      viewState = ViewState.Busy;
      _user = await _userRepositoryImpl.signInWithFacebook();
      if(_user != null)
      return _user;
      else return null;
    } finally {
      viewState = ViewState.Idle;
    }
  }

  @override
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    try {
      viewState = ViewState.Busy;
      _user =
          await _userRepositoryImpl.signInWithEmailAndPassword(email, password);
      if (_user != null) {
        return _user;
      } else {
        return null;
      }
    } finally {
      viewState = ViewState.Idle;
    }
  }

  @override
  Future<User> createUserWithEmailAndPassword(
      String email, String password, username) async {
    try {
      viewState = ViewState.Busy;
      _user = await _userRepositoryImpl.createUserWithEmailAndPassword(
          email, password, username);
      return _user;
    } finally {
      viewState = ViewState.Idle;
    }
  }

  String emailControl(String email) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(email)) {
      return "Lütfen Geçerli Bir Email Giriniz";
    } else {
      return null;
    }
  }

  String passwordControl(String password) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[.!@#\$&*~]).{8,}$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(password)) {
      return "Lütfen Geçerli Bir Şifre Giriniz \nŞifrenizde En Az 8 Karater Olmalıdır. \nŞifrenizde En Az Bir Harf \nŞifrenizde En Az Bir Rakam \nŞifrenizde En Az Bir Karakterden Oluşmalıdır.!";
    } else {
      return null;
    }
  }

  String nameControl(String name) {
    Pattern pattern = '^[a-zA-Z]+\$';
    RegExp regex = new RegExp(pattern);

    if (name.length < 2) {
      return "Lütfen Geçerli Bir Ad Giriniz";
    } else {
      if (!regex.hasMatch(name)) {
        return "Lütfen Geçerli Bir Ad Giriniz";
      } else {
        return null;
      }
    }
  }

  Future<bool> updateUsername(String userId, String newUsername) async {
    var _result = await _userRepositoryImpl.updateUsername(userId, newUsername);
    if (_result) {
      _user.username = newUsername;
    }
    return _result;
  }

  Future<String> uploadFile(
      String userId, String fileType, File profilePhotoFile) async {
    var _downloadLink = await _userRepositoryImpl.uploadFile(
        userId, fileType, profilePhotoFile);
    return _downloadLink;
  }

}
