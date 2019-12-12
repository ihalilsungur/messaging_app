import 'package:messaging_app/models/message.dart';
import 'package:messaging_app/models/talk.dart';
import 'package:messaging_app/models/user.dart';

abstract class DbPaginationService {
  Future<List<User>> getAllUsersWithPagination(
      User bringedTheLastUser, int numberOfUsersToBring);
  Future<List<Talk>> getAllConversations(String currentUserId);
  Future<List<Message>> getMessagesWithPagination(String currentUserId,
      String chatUserId, Message bringedTheLastMessage, messageCountPerPage);

}
