import 'package:flutter/material.dart';
import 'package:messaging_app/locator%20.dart';
import 'package:messaging_app/models/message.dart';
import 'package:messaging_app/models/talk.dart';
import 'package:messaging_app/models/user.dart';
import 'package:messaging_app/repository/message_repository_impl/message_repository_impl.dart';
import 'dart:async';

import 'package:messaging_app/services/db_pagination_service_impl/db_pagination_service_impl.dart';

enum ChatViewState { Idle, Loaded, Busy }

class ChatViewModel with ChangeNotifier {
  final User currentUser;
  final User chatUser;
  ChatViewState _chatViewState = ChatViewState.Loaded;
  final int _messageCountPerPage = 10;
  Message _bringedTheLastMessage;
  Message _firstMessageAddedToList;
  bool _hasMore = true;
  List<Message> _allMessages;
  bool _instantMessageListener = false;
  MessageRepositoryImpl _messageRepositoryImpl =
      locator<MessageRepositoryImpl>();
  DbPaginationServiceImpl _paginationRepositoryImpl =
      locator<DbPaginationServiceImpl>();
  StreamSubscription _streamSubscription;

  ChatViewModel({this.currentUser, this.chatUser}) {
    _allMessages = [];
    getMessagesWithPagination(false);
  }

  List<Message> get allMessages => _allMessages;
  bool get hasMoreLoading => _hasMore;
  ChatViewState get chatViewState => _chatViewState;
  set chatViewState(ChatViewState value) {
    _chatViewState = value;
    notifyListeners();
  }

  @override
  void dispose() {
    print("ChatViewModel dispose edildi.");
    _streamSubscription.cancel();
    super.dispose();
  }

  Future<bool> saveMessage(Message messageToSave,User currentUser) async {
    return await _messageRepositoryImpl.saveMessage(messageToSave,currentUser);
  }

  void getMessagesWithPagination(bool theComingNewMessages) async {
    if (_allMessages.length > 0) {
      _bringedTheLastMessage = _allMessages.last;
    }
    if (!theComingNewMessages) {
      chatViewState = ChatViewState.Busy;
    }
    //getirilen mesajlar
    var _theBringedMessages =
        await _paginationRepositoryImpl.getMessagesWithPagination(
            currentUser.userId,
            chatUser.userId,
            _bringedTheLastMessage,
            _messageCountPerPage);

    if (_theBringedMessages.length < _messageCountPerPage) {
      _hasMore = false;
    }
    /*
    _theBringedMessages
        .forEach((msg) => print("Getirilen Mesajlar : " + msg.message));
*/
    _allMessages.addAll(_theBringedMessages);

    if (_allMessages.length > 0) {
      _firstMessageAddedToList = _allMessages.first;
      //  print("Listeye Eklenen Ilk Mesaj : " + _firstMessageAddedToList.message);
    }
    chatViewState = ChatViewState.Idle;

    if (_instantMessageListener == false) {
      _instantMessageListener = true;
      //  print("Listener yok o yuzden atanacak");
      _assignNewMessage();
    }
  }

  Future<void> bringMoreMessages() async {
    // print("Daha fazla Mesaj getir  bringMoreMessages içindeyim");
    if (_hasMore) {
      getMessagesWithPagination(true);
    } else {
      //   print("Daha fazla eleman yok lutfen rahatsız etmeyin");
    }
    Future.delayed(Duration(seconds: 1));
  }

  void _assignNewMessage() {
    // print("Yeni mesajlar için listener atandı.");
    _streamSubscription = _messageRepositoryImpl
        .getMessages(currentUser.userId, chatUser.userId)
        .listen((instantData) {
      /*
      print("Listener tetiklendi ve en son getirilen mesaj :" +
          instantData[0].message);
          */
      if (instantData.isNotEmpty) {
        if (instantData[0].date != null) {
          if (_firstMessageAddedToList == null) {
            _allMessages.insert(0, instantData[0]);
          } else if (_firstMessageAddedToList.date.millisecondsSinceEpoch !=
              instantData[0].date.millisecondsSinceEpoch) {
            _allMessages.insert(0, instantData[0]);
          }
        }
        chatViewState = ChatViewState.Loaded;
      }
    });
  }

  Future<List<Talk>> getAllConversations(String currentUserId) async {
    var _allConversations =
        await _paginationRepositoryImpl.getAllConversations(currentUserId);

    return _allConversations;
  }

  Future<List<User>> getAllUsersWithPagination(
      bringedTheLastUser, numberOfUsersToBring) async {
    return await _paginationRepositoryImpl.getAllUsersWithPagination(
        bringedTheLastUser, numberOfUsersToBring);
  }
}
