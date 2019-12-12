import 'package:messaging_app/models/message.dart';
import 'package:messaging_app/models/user.dart';

abstract class MessageRepository{
   Stream<List<Message>> getMessages(String currentUserId, String chatUserId);
  Future<bool> saveMessage(Message messageToSave,User currentUser);

}