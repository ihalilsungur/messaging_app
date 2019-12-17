import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String fromWho; //kimden
  final String toWho; //kime
  final bool isFromMe; //benden mi
  final String message; //mesajın içeriği
  final String ownerOfTheConversation; //konuşmanın sahibi
  final Timestamp date; //tarihi

  Message({this.fromWho, this.toWho, this.isFromMe, this.message,this.ownerOfTheConversation, this.date});

  Map<String, dynamic> toMap() {
    return {
      "fromWho": fromWho,
      "toWho": toWho,
      "isFromMe": isFromMe,
      "message": message,
      "ownerOfTheConversation" :ownerOfTheConversation,
      "date": date ?? FieldValue.serverTimestamp()
    };
  }

  Message.fromMap(Map<String,dynamic> map):
  fromWho = map["fromWho"],
  toWho = map["toWho"],
  isFromMe = map["isFromMe"],
  message = map["message"],
  ownerOfTheConversation = map["ownerOfTheConversation"],
  date = map["date"] ;

 
}
