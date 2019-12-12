import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum TabItem {
  users,
  myConversations, //konusmalarım
  profile,
}

class TabItemData {
  final String title;
  final IconData icon;

  TabItemData(this.title, this.icon);

  static Map<TabItem, TabItemData> allTabs = {
    TabItem.users: TabItemData("Kullanıcılar", Icons.supervised_user_circle),
    TabItem.myConversations: TabItemData("Konuşmalarım", Icons.chat),
    TabItem.profile: TabItemData("profil", Icons.person)
  };
}
