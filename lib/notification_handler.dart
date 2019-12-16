import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:messaging_app/app/talk_page.dart';
import 'package:messaging_app/models/user.dart';
import 'package:messaging_app/viewmodel/chat_view_model.dart';
import 'package:messaging_app/viewmodel/user_view_model.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> myBackgroundMessageHandler(Map<String, dynamic> message) {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
    print("Arka planda gelen data : " + message["data"].toString());
    NotificationHandler._showNotification(message);
  }
/*
  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
  }
  */

 
  return Future<void>.value();
}

class NotificationHandler {
  FirebaseMessaging _fcm = FirebaseMessaging();
  static final NotificationHandler _singleton = NotificationHandler._internal();
  factory NotificationHandler() {
    return _singleton;
  }
  NotificationHandler._internal();
  BuildContext myContext;

  initializeFCMNotification(BuildContext context) async {
    myContext = context;
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    // _fcm.subscribeToTopic("spor");

    _fcm.onTokenRefresh.listen((newToken) async {
      FirebaseUser _currentUser = await FirebaseAuth.instance.currentUser();
      await Firestore.instance
          .document("tokens/" + _currentUser.uid)
          .setData({"token": newToken});
    });

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage Tetiklendi: $message");
        _showNotification(message);
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
      //  print("onLaunch Tetiklendi : $message");
        // _navigateToItemDetail(message);
       _showNotification(message);
      },
      onResume: (Map<String, dynamic> message) async {
        //print("onResume Tetiklendi : $message");
        //  _navigateToItemDetail(message);
         _showNotification(message);
      },
    );
  }

  static void _showNotification(Map<String, dynamic> message) async {
   // var userURLPath =
      await _downloadAndSaveImage(
        message["data"]["profilePhotoUrl"], 'largeIcon');

    var mesaj = Person(
        name: message["data"]["title"],
        key: '1',
       // icon: userURLPath,
        iconSource: IconSource.FilePath);
    var mesajStyle = MessagingStyleInformation(mesaj,
        messages: [Message(message["data"]["message"], DateTime.now(), mesaj)]);

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        '12345', 'Yeni Mesaj', 'your channel description',
        style: AndroidNotificationStyle.Messaging,
        styleInformation: mesajStyle,
        importance: Importance.Max,
        priority: Priority.High,
        ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, message["data"]["title"],
        message["data"]["message"], platformChannelSpecifics,
        payload: jsonEncode(message));
  }

  Future<void> onSelectNotification(String payload) async {
    final _userViewModel = Provider.of<UserViewModel>(myContext);

    if (payload != null) {
      debugPrint("Notification Payload : " + payload);
      Map<String, dynamic> gelenBildirim = await jsonDecode(payload);
      Navigator.of(myContext, rootNavigator: true).push(
        MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            builder: (context) => ChatViewModel(
              currentUser: _userViewModel.user,
              chatUser: User.withIdAndProfileUrl(
                  userId: gelenBildirim["data"]["senderUserId"],
                  profilePhotoUrl: gelenBildirim["data"]["profilePhotoUrl"]),
            ),
            child: TalkPage(),
          ),
        ),
      );
    }
  
  }

  static _downloadAndSaveImage(String url, String name) async {
    var directory = await getApplicationDocumentsDirectory();
    var filePath = '${directory.path}/$name';
    var response = await http.get(url);
    var file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  Future<void> onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    await showDialog(
      context: null, //buraya context gelecek
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: title != null ? Text(title) : null,
        content: body != null ? Text(body) : null,
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SecondScreen(payload),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

class SecondScreen extends StatefulWidget {
  SecondScreen(this.payload);

  final String payload;

  @override
  State<StatefulWidget> createState() => SecondScreenState();
}

class SecondScreenState extends State<SecondScreen> {
  String _payload;
  @override
  void initState() {
    super.initState();
    _payload = widget.payload;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Screen with payload: ${(_payload ?? '')}'),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}
