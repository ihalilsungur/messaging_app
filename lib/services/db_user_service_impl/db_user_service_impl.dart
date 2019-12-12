import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:messaging_app/models/user.dart';
import 'package:messaging_app/services/db_user_service/db_user_service.dart';


class DbUserServiceImpl implements DbUserService {
  final Firestore _firestore = Firestore.instance;

  @override
  Future<bool> saveUser(User user) async {
    await _firestore
        .collection("users")
        .document(user.userId)
        .setData(user.toMap());
    return true;
  }

  @override
  Future<User> readUser(String userId) async {
    DocumentSnapshot _readUser =
        await _firestore.collection("users").document(userId).get();
    Map<String, dynamic> _readUserMap = _readUser.data;
    User _readUserObject = User.fromMap(_readUserMap);
    debugPrint("Okunan User Nesnesi : " + _readUserObject.toString());

    return _readUserObject;
  }

  @override
  Future<bool> updateUsername(String userId, String newUsername) async {
    var users = await _firestore
        .collection("users")
        .where("username", isEqualTo: newUsername)
        .getDocuments();
    //ilk önce veritabanında bu yeni kullanıcı isminin olup olamadigin kontrol etmek gerekir

    if (users.documents.length >= 1) {
      return false;
    } else {
      await _firestore
          .collection("users")
          .document(userId)
          .updateData({"username": newUsername});
      return true;
    }
  }

  @override
  Future<bool> updateProfilePhoto(String userId, String profilePhotoUrl) async {
    await _firestore
        .collection("users")
        .document(userId)
        .updateData({"profilePhotoUrl": profilePhotoUrl});
    return true;
  }

/*
  @override
  Future<List<Talk>> getAllConversations(String currentUserId) async {
    QuerySnapshot _querySnapshot = await Firestore.instance
        .collection("talks")
        .where("talker", isEqualTo: currentUserId)
        .orderBy("dateMessageToSent", descending: true)
        .getDocuments();

    List<Talk> _allConversations = [];
    for (DocumentSnapshot singleTalk in _querySnapshot.documents) {
      Talk _talk = Talk.fromMap(singleTalk.data);
      _allConversations.add(_talk);
    }

    return _allConversations;
  }
  */
/*
  Stream <Message> getMessage(String currentUserId, String chatUserId) {
   var _shapshots=  _firestore
        .collection("talks")
        .document(currentUserId + "--" + chatUserId)
        .collection("messgaes")
        .document(currentUserId)
        .snapshots();
    return _shapshots.map((shapshot)=>Message.fromMap(shapshot.data));
  }
  */

/*

  @override
  Stream<List<Message>> getMessages(String currentUserId, String chatUserId) {
    var _shapshots = _firestore
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
    var _messageId = _firestore.collection("talk").document().documentID;
    var _myDocumentId = messageToSave.fromWho + "--" + messageToSave.toWho;
    var _receiverDocumentId =
        messageToSave.toWho + "--" + messageToSave.fromWho;
    var _messageToSaveMapStructure = messageToSave.toMap();
    await _firestore
        .collection("talks")
        .document(_myDocumentId)
        .collection("messages")
        .document(_messageId)
        .setData(_messageToSaveMapStructure);

    await _firestore.collection("talks").document(_myDocumentId).setData({
      "talker": messageToSave.fromWho,
      "listen": messageToSave.toWho,
      "sendLastMessage": messageToSave.message,
      "isMessageSeen": false,
      "dateMessageToSent": FieldValue.serverTimestamp()
    });

    _messageToSaveMapStructure.update("isFromMe", (value) => false);

    await _firestore
        .collection("talks")
        .document(_receiverDocumentId)
        .collection("messages")
        .document(_messageId)
        .setData(_messageToSaveMapStructure);

    await _firestore.collection("talks").document(_receiverDocumentId).setData({
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
    await _firestore
        .collection("server")
        .document(userId)
        .setData({"clock": FieldValue.serverTimestamp()});

    var _mapTheRead =
        await _firestore.collection("server").document(userId).get();
    Timestamp _dateTheRead = _mapTheRead.data["clock"];
    return _dateTheRead.toDate();
  }
*/
/*
  @override
  Future<List<User>> getAllUsersWithPagination(
      User bringedTheLastUser, int numberOfUsersToBring) async {
    QuerySnapshot _querySnapshot;
    List<User> _allUsers = [];

    if (bringedTheLastUser == null) {
      print("ilk getirilen kullanıcılar");
      _querySnapshot = await Firestore.instance
          .collection("users")
          .orderBy("username")
          .limit(numberOfUsersToBring)
          .getDocuments();
    } else {
      print("Sonra getirilen kullanıcılar");
      _querySnapshot = await Firestore.instance
          .collection("users")
          .orderBy("username")
          .startAfter([bringedTheLastUser.username])
          .limit(numberOfUsersToBring)
          .getDocuments();
      await Future.delayed(Duration(seconds: 1));
    }
    for (DocumentSnapshot snapshot in _querySnapshot.documents) {
      User _singleUser = User.fromMap(snapshot.data);
      _allUsers.add(_singleUser);
      // print("Getirilen Username : " + _singleUser.username);
    }
    return _allUsers;
  }
*/
/*
  Future<List<Message>> getMessagesWithPagination(
      String currentUserId, String chatUserId,Message bringedTheLastMessage, messageCountPerPage) async {
        QuerySnapshot _querySnapshot;
    List<Message> _allMessages = [];

    if (bringedTheLastMessage == null) {
      print("ilk Messajlar kullanıcılar");
      _querySnapshot = await Firestore.instance
          .collection("talks")
        .document(currentUserId + "--" + chatUserId)
        .collection("messages")
        .orderBy("date", descending: true)
          .limit(messageCountPerPage)
          .getDocuments();
    } else {
      print("Sonra getirilen Messajlar");
      _querySnapshot = await Firestore.instance
          .collection("talks")
        .document(currentUserId + "--" + chatUserId)
        .collection("messages")
        .orderBy("date", descending: true)
          .startAfter([bringedTheLastMessage.date])
          .limit(messageCountPerPage)
          .getDocuments();
      await Future.delayed(Duration(seconds: 1));
    }
    for (DocumentSnapshot snapshot in _querySnapshot.documents) {
      Message _singleMessage = Message.fromMap(snapshot.data);
      _allMessages.add(_singleMessage);
      // print("Getirilen Username : " + _singleUser.username);
    }
    return _allMessages;
      }
      */
}
