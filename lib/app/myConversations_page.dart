import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messaging_app/app/talk_page.dart';
import 'package:messaging_app/locator%20.dart';
import 'package:messaging_app/models/talk.dart';
import 'package:messaging_app/models/user.dart';
import 'package:messaging_app/repository/pagination_repository_impl/pagination_repository_impl.dart';
import 'package:messaging_app/viewmodel/chat_view_model.dart';
import 'package:messaging_app/viewmodel/user_view_model.dart';
import 'package:provider/provider.dart';

class MyConversationsPage extends StatefulWidget {
  @override
  _MyConversationsPageState createState() => _MyConversationsPageState();
}

class _MyConversationsPageState extends State<MyConversationsPage> {
    /*
  @override
  void initState() {
    super.initState();
  
    RewardedVideoAd.instance.load(
        adUnitId: AdmobOperations.odulluReklamTest,
        targetingInfo: AdmobOperations.mobileAdTargetingInfo);

    RewardedVideoAd.instance.listener =
        (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      if (event == RewardedVideoAdEvent.rewarded) {
        print("*********ÖDÜLLÜ REKLAM *********** ÖDÜLLÜ VER");
        _awardWinningAdUpload();
      } else if (event == RewardedVideoAdEvent.loaded) {
        RewardedVideoAd.instance.show();
           print("*********ÖDÜLLÜ REKLAM *********** REKLAM TUKLENDİ");
      } else if (event == RewardedVideoAdEvent.closed) {
        print("*********ÖDÜLLÜ REKLAM *********** RAKLAMI KAPATTI");
        _awardWinningAdUpload();
      } else if (event == RewardedVideoAdEvent.failedToLoad) {
        print("*********ÖDÜLLÜ REKLAM *********** RAKLAMI BULUNAMADI");
      } else if (event == RewardedVideoAdEvent.completed) {
        print("*********ÖDÜLLÜ REKLAM *********** COMPLETED");
      }
    };
  }

  void _awardWinningAdUpload() {
    RewardedVideoAd.instance.load(
        adUnitId: AdmobOperations.odulluReklamTest,
        targetingInfo: AdmobOperations.mobileAdTargetingInfo);
  }

*/
  @override
  Widget build(BuildContext context) {
    UserViewModel _userViewModel = Provider.of<UserViewModel>(context);
    PaginationRepositoryImpl _paginationRepositoryImpl =
        locator<PaginationRepositoryImpl>();
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text("Konuşmalarım")),
        ),
        body: FutureBuilder<List<Talk>>(
          future: _paginationRepositoryImpl
              .getAllConversations(_userViewModel.user.userId),
          builder: (BuildContext context, result) {
            if (result.hasData) {
              var _allConversations = result.data;
              if (_allConversations.length > 0) {
                return RefreshIndicator(
                  onRefresh: _refreshListTheTalks,
                  child: ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      var _currentTalk = _allConversations[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (context) => ChangeNotifierProvider(
                                builder: (context) => ChatViewModel(
                                  chatUser: _userViewModel.user,
                                  currentUser: User.withIdAndProfileUrl(
                                      userId: _currentTalk.listen,
                                      profilePhotoUrl: _currentTalk
                                          .spokenUsernameProfileUrl),
                                ),
                                child: TalkPage(),
                              ),
                            ),
                          );
                        },
                        child: ListTile(
                          title: Text(
                            _currentTalk.sendLastMessage,
                            style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                          subtitle: Text(
                            _currentTalk.spokenUsername +
                                "     " +
                                _currentTalk.timeDifference,
                            style: TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.bold),
                          ),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                _currentTalk.spokenUsernameProfileUrl),
                          ),
                        ),
                      );
                    },
                    itemCount: _allConversations.length,
                  ),
                );
              } else {
                return RefreshIndicator(
                  onRefresh: _refreshListTheTalks,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Container(
                      height: MediaQuery.of(context).size.height - 100,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.chat,
                              size: 40,
                              color: Theme.of(context).primaryColor,
                            ),
                            Text(
                              "Hiç Bir Mesajınız Bulunmamaktadır.",
                              style: TextStyle(
                                  color: Colors.teal,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }

  void bringToTalks() async {
    final _userViewModel = Provider.of<UserViewModel>(context);
    var myTalks = await Firestore.instance
        .collection("talks")
        .where("talker", isEqualTo: _userViewModel.user.userId)
        .orderBy("dateMessageToSent", descending: true)
        .getDocuments();
    debugPrint("Konuşlarımın içindeyim : " + _userViewModel.user.userId);
    for (var talk in myTalks.documents) {
      print("Konuşmalarım : " + talk.data.toString());
    }
  }

  Future<Null> _refreshListTheTalks() async {
    setState(() {});

    await Future.delayed(
      Duration(seconds: 1),
    );

    return null;
  }
}
