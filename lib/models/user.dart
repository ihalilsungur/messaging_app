import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class User {
  final String userId;
  String email;
  String username;
  String profilePhotoUrl;
  DateTime createdAt;
  DateTime updatedAt;
  int level;

  User({@required this.userId, @required this.email, this.username});
  User.withIdAndProfileUrl(
      {@required this.userId, @required this.profilePhotoUrl});

  String getUsername() {
    return this.username;
  }

  void setUsername(String username) {
    this.username = username;
  }

  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "email": email,
      "username": username ?? email.substring(0, email.indexOf("@")),
      "profilePhotoUrl": profilePhotoUrl ?? "https://images.hdqwalls.com/wallpapers/bthumb/lion-roaring-on-top-of-mountain-5k-k7.jpg",
      "createdAt": createdAt ?? FieldValue.serverTimestamp(),
      "updatedAt": updatedAt ?? FieldValue.serverTimestamp(),
      "level": level ?? 1
    };
  }

  User.fromMap(Map<String, dynamic> map)
      : userId = map["userId"],
        email = map["email"],
        username = map["username"],
        profilePhotoUrl = map["profilePhotoUrl"],
        createdAt = (map["createdAt"] as Timestamp).toDate(),
        updatedAt = (map["updatedAt"] as Timestamp).toDate(),
        level = map["level"];

  @override
  String toString() {
    return 'User userId: $userId, email: $email, username: $username, profilePhotoUrl: $profilePhotoUrl, createdAt: $createdAt, updatedAt: $updatedAt, level: $level';
  }
}
