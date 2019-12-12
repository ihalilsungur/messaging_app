import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:messaging_app/admob_operations/admob_operations.dart';
import 'package:messaging_app/models/message.dart';
import 'package:messaging_app/viewmodel/chat_view_model.dart';

import 'package:provider/provider.dart';

class TalkPage extends StatefulWidget {
  @override
  _TalkPageState createState() => _TalkPageState();
}

class _TalkPageState extends State<TalkPage> {
  var _messageControllerText = TextEditingController();
  ScrollController _scrollController = new ScrollController();
  bool _isLoading = false;
  InterstitialAd _myInterstitialAd;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);

    if (AdmobOperations.howManyTimesToShow < 3) {
      _myInterstitialAd = AdmobOperations.buildInterstitialAd();
      _myInterstitialAd
        ..load()
        ..show();
      AdmobOperations.howManyTimesToShow++;
    }
  }

  @override
  void dispose() {
    if (_myInterstitialAd != null) _myInterstitialAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _chatViewModel = Provider.of<ChatViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Sohbet")),
      ),
      body: _chatViewModel.chatViewState == ChatViewState.Busy
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Column(
                children: <Widget>[
                  _messageLists(),
                  _enterNewTheMassage(),
                  // _buildMesajListesi(),
                  // _buildYeniMesajGir(),
                ],
              ),
            ),
    );
  }

  Widget _messageLists() {
    return Consumer<ChatViewModel>(
      builder: (context, chatModel, child) {
        return Expanded(
          child: ListView.builder(
            controller: _scrollController,
            reverse: true,
            itemBuilder: (BuildContext context, int index) {
              if (chatModel.hasMoreLoading == true &&
                  chatModel.allMessages.length == index) {
                return _loadingNewElementsIndicator();
              } else {
                return _creatingTalkBubble(chatModel.allMessages[index]);
              }
            },
            itemCount: chatModel.hasMoreLoading
                ? chatModel.allMessages.length + 1
                : chatModel.allMessages.length,
          ),
        );
      },
    );
  }

  Widget _enterNewTheMassage() {
    final _chatViewModel = Provider.of<ChatViewModel>(context);
    return Container(
      padding: EdgeInsets.only(bottom: 8, left: 5, right: 5),
      child: Row(
        children: <Widget>[
          Container(
            child: Icon(
              Icons.add_circle,
              size: 40,
              color: Colors.blue,
            ),
          ),
          Expanded(
            child: TextField(
              controller: _messageControllerText,
              cursorColor: Colors.blueGrey,
              style: new TextStyle(
                  height: .7,
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
              decoration: InputDecoration(
                  hintText: "Mesajınızı Yazın",
                  hintStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    // borderSide: BorderSide.none
                  )),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 1 / 18,
            margin: EdgeInsets.symmetric(
              horizontal: 4,
            ),
            child: FloatingActionButton(
              elevation: 0,
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.navigation,
                size: 30,
                color: Colors.white,
              ),
              onPressed: () async {
                if (_messageControllerText.text.trim().length > 0) {
                  Message _messageToSave = new Message(
                      fromWho: _chatViewModel.currentUser.userId,
                      toWho: _chatViewModel.chatUser.userId,
                      isFromMe: true,
                      message: _messageControllerText.text);
                  var _result = await _chatViewModel.saveMessage(
                      _messageToSave, _chatViewModel.currentUser);
                  if (_result) {
                    _messageControllerText.clear();
                    _scrollController.animateTo(0.0,
                        curve: Curves.easeOut,
                        duration: const Duration(milliseconds: 10));
                  }
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _creatingTalkBubble(Message currentMessage) {
    Color _incomingMessageColor = Colors.green;
    final _chatViewModel = Provider.of<ChatViewModel>(context);
    Color _outgoingMessageColor = Theme.of(context).primaryColor;
    var _showHourdMinutesValue = "";
    try {
      _showHourdMinutesValue =
          _showHoursMinutes(currentMessage.date ?? Timestamp.now());
    } catch (e) {
      debugPrint("Tarihi Formatlanırken Hata Oluştur");
    }
    var isMyMessage = currentMessage.isFromMe;
    if (isMyMessage) {
      return Padding(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 1 / 4,
            top: 10,
            bottom: 10,
            right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              width: currentMessage.message.length == 1 ||
                      currentMessage.message.length == 2 ||
                      currentMessage.message.length == 3
                  ? ((currentMessage.message.length + 1) * 35).toDouble()
                  : ((currentMessage.message.length + 1) * 22).toDouble(),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: _outgoingMessageColor),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(left: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          currentMessage.message,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    margin: EdgeInsets.only(top: 30, left: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _showHourdMinutesValue,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(
            right: (MediaQuery.of(context).size.width - 30) * 1 / 5,
            left: 10,
            top: 10,
            bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                CircleAvatar(
                  backgroundImage:
                      NetworkImage(_chatViewModel.chatUser.profilePhotoUrl),
                  radius: 35,
                ),
                Flexible(
                  child: Container(
                    margin: EdgeInsets.all(10),
                    width: currentMessage.message.length == 1 ||
                            currentMessage.message.length == 2 ||
                            currentMessage.message.length == 3
                        ? ((currentMessage.message.length + 1) * 40).toDouble()
                        : ((currentMessage.message.length + 1) * 30).toDouble(),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.green),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Flexible(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.only(
                                left: 5, right: 10, bottom: 5, top: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: _incomingMessageColor),
                            child: Text(
                              currentMessage.message,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomRight,
                          margin: EdgeInsets.only(
                              top: 30, left: 10, right: 10, bottom: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            _showHourdMinutesValue,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  String _showHoursMinutes(Timestamp date) {
    var _formatter = DateFormat.Hm();
    var _formattedDate = _formatter.format(date.toDate());
    return _formattedDate;
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _bringOldMessages();
      print("Listenin sonundayım");
    }
  }

  void _bringOldMessages() async {
    final _chatViewModel = Provider.of<ChatViewModel>(context);
    if (_isLoading == false) {
      _isLoading = true;

      await _chatViewModel.bringMoreMessages();
      _isLoading = false;
    }
    print("Listenin En Başındayız Eski mesajları getir");
  }

  _loadingNewElementsIndicator() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
