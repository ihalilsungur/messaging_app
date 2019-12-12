
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messaging_app/admob_operations/admob_operations.dart';
import 'package:messaging_app/app/tab_items.dart';

//bu sinif homepage sayfasindaki menunun nasıl gorunecegini ayarlar
class MyCustomBottomNavigation extends StatefulWidget {
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectedTab;
  final Map<TabItem, Widget> pageBuilder;
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys;

  const MyCustomBottomNavigation(
      {Key key,
      @required this.currentTab,
      @required this.onSelectedTab,
      @required this.pageBuilder,
      @required this.navigatorKeys})
      : super(key: key);

  @override
  _MyCustomBottomNavigationState createState() =>
      _MyCustomBottomNavigationState();
}

class _MyCustomBottomNavigationState extends State<MyCustomBottomNavigation> {
  BannerAd _bannerAd;
  
  @override
  void initState() {
    super.initState();
    AdmobOperations.admodInitialize();
    _bannerAd = AdmobOperations.buildBannerAd();
    //_bannerAd.load();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //alt tarafa reklam ekleme
    //_bannerAd.show(anchorOffset: 0);
    return Column(
      children: <Widget>[
        Expanded(
          child: CupertinoTabScaffold(
            tabBar: CupertinoTabBar(
              items: <BottomNavigationBarItem>[
                _createdNavItem(TabItem.users),
                _createdNavItem(TabItem.myConversations),
                _createdNavItem(TabItem.profile)
              ],
              onTap: (index) => widget.onSelectedTab(TabItem.values[index]),
            ),
            tabBuilder: (BuildContext context, int index) {
              final displayItem = TabItem.values[index];
              return CupertinoTabView(
                navigatorKey: widget.navigatorKeys[displayItem],
                builder: (context) {
                  return widget.pageBuilder[displayItem];
                },
              );
            },
          ),
        ),
       
      ],
    );
  }

  BottomNavigationBarItem _createdNavItem(TabItem tabItem) {
    final tabToBeCreated = TabItemData.allTabs[tabItem];
    return BottomNavigationBarItem(
      icon: Icon(tabToBeCreated.icon),
      title: Text(
        tabToBeCreated.title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
    );
  }
}
