import 'package:cloud_firestore/cloud_firestore.dart';

class Talk {
  final String talker;
  final String listen;
  final bool isMessageSeen;
  final String sendLastMessage;
  final Timestamp dateMessageToSent;
  final Timestamp dateSeenTheMessage;
  String spokenUsername;
  String spokenUsernameProfileUrl;
  DateTime lastReadTime;
  String timeDifference;

  Talk({
    this.talker,
    this.listen,
    this.isMessageSeen,
    this.sendLastMessage,
    this.dateMessageToSent,
    this.dateSeenTheMessage,
  });

  Map<String, dynamic> toMap() {
    return {
      'talker': talker,
      'listen': listen,
      'isMessageSeen': isMessageSeen,
      'sendLastMessage': sendLastMessage,
      'dateMeesageToSent': dateMessageToSent,
      'dateSeenTheMessage': dateSeenTheMessage,
    };
  }

  Talk.fromMap(Map<String, dynamic> map)
      : talker = map['talker'],
        listen = map['listen'],
        isMessageSeen = map['isMessageSeen'],
        sendLastMessage = map['sendLastMessage'],
        dateMessageToSent = map['dateMessageToSent'],
        dateSeenTheMessage = map['dateSeenTheMessage'];

/*
   static Talk fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return Talk(
      talker: map['talker'],
      listen: map['listen'],
      isMessageSeen: map['isMessageSeen'],
      sendLastMessage: map['sendLastMessage'],
      dateMeesageToSent: map['dateMeesageToSent'],
      dateSeenTheMessage:map['dateSeenTheMessage'],
    );
  }
  */

  @override
  String toString() {
    return 'Talk talker: $talker, listen: $listen, isMessageSeen: $isMessageSeen, sendLastMessage: $sendLastMessage, dateMessageToSent: $dateMessageToSent, dateSeenTheMessage: $dateSeenTheMessage';
  }
}
