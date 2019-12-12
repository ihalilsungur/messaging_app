import 'package:messaging_app/models/user.dart';

abstract class DbUserService {
  Future<bool> saveUser(User user);
  Future<User> readUser(String userId);
  Future<bool> updateUsername(String userId, String newUsername);
  Future<bool> updateProfilePhoto(String userId, String profilePhotoUrl);
}
