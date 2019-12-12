import 'package:messaging_app/models/talk.dart';
import 'package:messaging_app/models/user.dart';

abstract class DbTalkService {
  Future<List<User>> getAllUsersWithPagination(
      User bringedTheLastUser, int numberOfUsersToBring);
  Future<List<Talk>> getAllConversations(String currentUserId);
}
