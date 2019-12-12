
import 'package:messaging_app/models/message.dart';
import 'package:messaging_app/models/user.dart';

abstract class NotificationSendservice{
  Future<bool> sendNotification(Message notificationToSend,User sender,String token);
}