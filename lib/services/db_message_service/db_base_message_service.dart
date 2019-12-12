import 'package:messaging_app/models/message.dart';

abstract class DbMessageService {
  Stream<List<Message>> getMessages(String currentUserId, String chatUserId);
  Future<bool> saveMessage(Message messageToSave);
  Future<DateTime> showTheClock(String userId);
}