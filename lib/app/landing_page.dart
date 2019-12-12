import 'package:flutter/material.dart';
import 'package:messaging_app/app/sign_in/sign_in_page.dart';
import 'package:messaging_app/viewmodel/user_view_model.dart';
import 'package:provider/provider.dart';

import 'home_page.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _userViewModel = Provider.of<UserViewModel>(context);

    if (_userViewModel.viewState == ViewState.Idle) {
      if (_userViewModel.user == null) {
        return SignInPage();
      } else {
        return HomePage(
          user: _userViewModel.user,
        );
      }
    } else {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
