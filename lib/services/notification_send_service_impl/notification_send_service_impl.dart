import 'package:messaging_app/models/message.dart';
import 'package:messaging_app/models/user.dart';
import 'package:messaging_app/services/notification_send_service/notification_send_service.dart';
import 'package:http/http.dart' as http;

class NotificationSendServiceImpl implements NotificationSendservice {
  @override
  Future<bool> sendNotification(
      Message notificationToSend, User sender, String token) async {
    String _endUrl = "https://fcm.googleapis.com/fcm/send";
    String firebaseKey =
        "AAAAAUnH_Mo:APA91bEaffLOI4rC0WEbFm5UbnK5rNlTg2waV5HSz3m0kGhxWq0hyS695Jj1u_znICHq09HZXH0QNo7PIy9go-d8ZMG98VqU2sbRsdUmyC5-BJpqYEDVGbMrkXdIPcapAFQUp8ACq_1W";
    Map<String, String> _headers = {
      "Content-Type": "application/json",
      "Authorization": "key=$firebaseKey"
    };
    String _json =
        '{"to":"$token","data":{"title":"${sender.username} Yeni Mesaj ","message":"${notificationToSend.message}","profilePhotoUrl":"${sender.profilePhotoUrl}","senderUserId":"${sender.userId}"}}';

    http.Response _response =
        await http.post(_endUrl, headers: _headers, body: _json);
    if (_response.statusCode == 200) {
      print("İşlem başarılıdır."+_json);
      return true;
    } else {
      print("İşlem başarısızdır : " + _response.statusCode.toString());
      print("Jsonımız : " + _json);
      return false;
    }
  }
}
