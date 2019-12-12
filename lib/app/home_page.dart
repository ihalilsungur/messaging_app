
import 'package:flutter/material.dart';
import 'package:messaging_app/app/myConversations_page.dart';
import 'package:messaging_app/app/my_custom_bottom_navigation.dart';
import 'package:messaging_app/app/profile_page.dart';
import 'package:messaging_app/app/tab_items.dart';
import 'package:messaging_app/app/users_page.dart';
import 'package:messaging_app/models/user.dart';
import 'package:messaging_app/notification_handler.dart';
import 'package:messaging_app/viewmodel/all_users_view_model.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final User user;
  HomePage({Key key, @required this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.users;

  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.users: GlobalKey<NavigatorState>(),
    TabItem.myConversations: GlobalKey<NavigatorState>(),
    TabItem.profile: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, Widget> allPages() {
    return {
      TabItem.users: ChangeNotifierProvider(
        builder: (context) => AllUsersViewModel(),
        child: UsersPage(),
      ),
      TabItem.myConversations: MyConversationsPage(),
      TabItem.profile: ProfilePage()
    };
  }

  @override
  void initState() {
    super.initState();
   NotificationHandler().initializeFCMNotification(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !await navigatorKeys[_currentTab].currentState.maybePop(),
      child: MyCustomBottomNavigation(
        pageBuilder: allPages(),
        currentTab: _currentTab,
        onSelectedTab: (selectedTab) {
          if (selectedTab == _currentTab) {
            navigatorKeys[selectedTab]
                .currentState
                .popUntil((route) => route.isFirst);
          } else {
            setState(() {
              _currentTab = selectedTab;
            });
          }
        },
        navigatorKeys: navigatorKeys,
      ),
    );
  }
}
