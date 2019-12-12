import 'package:messaging_app/models/message.dart';
import 'package:messaging_app/models/user.dart';
import 'package:messaging_app/repository/message_repository/message_repository.dart';
import 'package:messaging_app/services/db_message_service_impl/db_message_service_impl.dart';
import 'package:messaging_app/services/notification_bring_token_service_impl/notification_bring_token_service_impl.dart';
import 'package:messaging_app/services/notification_send_service_impl/notification_send_service_impl.dart';

import '../../locator .dart';

enum AppMode { DEBUG, RELEASE }

class MessageRepositoryImpl implements MessageRepository {
  DbMessageServiceImpl _dbMessageServiceImpl = locator<DbMessageServiceImpl>();
  NotificationSendServiceImpl _notificationSendServiceImpl =
      locator<NotificationSendServiceImpl>();
  Map<String, String> _userToken = Map<String, String>();
  NotificationBringTokenServiceImpl _bringTokenServiceImpl =
      locator<NotificationBringTokenServiceImpl>();
  //hangi veritabana göre calisacagini ayarliyoruz.
  AppMode appMode = AppMode.RELEASE;
  @override
  Stream<List<Message>> getMessages(String currentUserId, String chatUserId) {
    if (appMode == AppMode.DEBUG) {
      return Stream.empty();
    } else {
      return _dbMessageServiceImpl.getMessages(currentUserId, chatUserId);
    }
  }

  @override
  Future<bool> saveMessage(Message messageToSave, User currentUser) async {
    if (appMode == AppMode.DEBUG) {
      return true;
    } else {
      var _dbWriteProces = _dbMessageServiceImpl.saveMessage(messageToSave);
      if (_dbWriteProces != null) {
        var _token = "";
        if (_userToken.containsKey(messageToSave.toWho)) {
          _token = _userToken[messageToSave.toWho];

          print("Lokalden Geldi 2: " + _token.toString());
        } else {
          if (_token != null) {
            _token =
                await _bringTokenServiceImpl.bringToken(messageToSave.toWho);
            print("Veritabanından  Geldi : " + _token);
            _userToken[messageToSave.toWho] = _token;
          }
        }
        if(_token != null)
        await _notificationSendServiceImpl.sendNotification(
            messageToSave, currentUser,_token);

        return true;
      } else
        return false;
    }
  }
}
