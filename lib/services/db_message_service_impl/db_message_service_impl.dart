import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messaging_app/models/message.dart';
import 'package:messaging_app/services/db_message_service/db_base_message_service.dart';

class DbMessageServiceImpl implements DbMessageService {
  final Firestore _firestoreDbMessage = Firestore.instance;

  @override
  Stream<List<Message>> getMessages(String currentUserId, String chatUserId) {
    var _shapshots = _firestoreDbMessage
        .collection("talks")
        .document(currentUserId + "--" + chatUserId)
        .collection("messages")
        .orderBy("date", descending: true)
        .limit(1)
        .snapshots();
    return _shapshots.map((messageList) => messageList.documents
        .map((message) => Message.fromMap(message.data))
        .toList());
  }

  @override
  Future<bool> saveMessage(Message messageToSave) async {
    var _messageId =
        _firestoreDbMessage.collection("talk").document().documentID;
    var _myDocumentId = messageToSave.fromWho + "--" + messageToSave.toWho;
    var _receiverDocumentId =
        messageToSave.toWho + "--" + messageToSave.fromWho;
    var _messageToSaveMapStructure = messageToSave.toMap();
    await _firestoreDbMessage
        .collection("talks")
        .document(_myDocumentId)
        .collection("messages")
        .document(_messageId)
        .setData(_messageToSaveMapStructure);

    await _firestoreDbMessage
        .collection("talks")
        .document(_myDocumentId)
        .setData({
      "talker": messageToSave.fromWho,
      "listen": messageToSave.toWho,
      "sendLastMessage": messageToSave.message,
      "isMessageSeen": false,
      "dateMessageToSent": FieldValue.serverTimestamp()
    });

    _messageToSaveMapStructure.update("isFromMe", (value) => false);

    await _firestoreDbMessage
        .collection("talks")
        .document(_receiverDocumentId)
        .collection("messages")
        .document(_messageId)
        .setData(_messageToSaveMapStructure);

    await _firestoreDbMessage
        .collection("talks")
        .document(_receiverDocumentId)
        .setData({
      "talker": messageToSave.toWho,
      "listen": messageToSave.fromWho,
      "sendLastMessage": messageToSave.message,
      "isMessageSeen": false,
      "dateMessageToSent": FieldValue.serverTimestamp()
    });

    return true;
  }

  @override
  Future<DateTime> showTheClock(String userId) async {
    await _firestoreDbMessage
        .collection("server")
        .document(userId)
        .setData({"clock": FieldValue.serverTimestamp()});

    var _mapTheRead =
        await _firestoreDbMessage.collection("server").document(userId).get();
    if (_mapTheRead != null) {
      Timestamp _dateTheRead = _mapTheRead.data["clock"];
      if (_dateTheRead != null)
        return _dateTheRead.toDate();
      else
        return null;
    }else return null;
  }
}
