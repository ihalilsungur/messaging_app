import 'package:flutter/material.dart';
import 'package:messaging_app/locator%20.dart';
import 'package:messaging_app/viewmodel/user_view_model.dart';
import 'package:provider/provider.dart';

import 'app/landing_page.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => UserViewModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Mesajlaşma Programı',
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        home: LandingPage(),
      ),
    );
  }
}
