import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messaging_app/services/notification_bring_token_service/notification_bring_token.dart';

class NotificationBringTokenServiceImpl
    implements NotificationBringTokenService {
  final Firestore _firestore = Firestore.instance;
  @override
  Future<String> bringToken(String toWho) async {
    DocumentSnapshot _token =
        await _firestore.document("tokens/" + toWho).get();
      
    if (_token != null) {
        print("Notification Bring Token Service Impl den Değer: "+_token.data["token"]);
      return _token.data["token"];
    }else
    return null;
  }
}
