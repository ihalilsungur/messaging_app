import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messaging_app/models/message.dart';
import 'package:messaging_app/models/talk.dart';
import 'package:messaging_app/models/user.dart';
import 'package:messaging_app/services/db_pagination_service/db_pagination_service.dart';

class DbPaginationServiceImpl implements DbPaginationService {
    final Firestore _firestore = Firestore.instance;
  @override
  Future<List<Talk>> getAllConversations(String currentUserId) async {
    QuerySnapshot _querySnapshot = await Firestore.instance
        .collection("talks")
        .where("talker", isEqualTo: currentUserId)
       // .orderBy("dateMessageToSent", descending: true)
        .orderBy("dateMessageToSent", descending: true)
        .getDocuments();

    List<Talk> _allConversations = [];
    for (DocumentSnapshot singleTalk in _querySnapshot.documents) {
      Talk _talk = Talk.fromMap(singleTalk.data);
      _allConversations.add(_talk);
    }
    return _allConversations;
  }

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

  Future<List<Message>> getMessagesWithPagination(
      String currentUserId,
      String chatUserId,
      Message bringedTheLastMessage,
      messageCountPerPage) async {
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
}
