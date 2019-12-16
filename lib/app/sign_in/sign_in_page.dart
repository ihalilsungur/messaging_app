import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:messaging_app/app/error_exception.dart';
import 'package:messaging_app/app/sign_in/login_with_email_and_password.dart';
import 'package:messaging_app/common_widget/platform_responsive_alert_dialog.dart';
import 'package:messaging_app/common_widget/social_login_button.dart';
import 'package:messaging_app/models/user.dart';
import 'package:messaging_app/viewmodel/user_view_model.dart';
import 'package:provider/provider.dart';

PlatformException _myError;

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {



  void _loginWithGoogle(BuildContext context) async {
    final _userViewModel = Provider.of<UserViewModel>(context);
    User _user = await _userViewModel.signInWithGoogle();
    if (_user != null)
      debugPrint("Google ile oturumu açan  Kullanıcı Id: " + _user.userId);
  }
  @override
  void initState() {
  
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_){
      if(_myError != null)
       PlatformResponsiveAlertDialog(
        title: "Kullanıcı Oluşturma Hatası",
        content: ErrorException.showError(_myError.code),
        mainButtonText: "Tamam",
      ).show(context);
    });
  }

  void _loginWithFacebook(BuildContext context) async {
    final _userViewModel = Provider.of<UserViewModel>(context);
    try {
      User _user = await _userViewModel.signInWithFacebook();
      if (_user != null)
        debugPrint("Facebook ile oturumu açan  Kullanıcı Id: " + _user.userId);
    } on PlatformException catch (e) {
     _myError =e;
    }
  }

  void _loginWithEmailAndPassword(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => LoginWithEmailAndPassword(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Mesajlaşma Programı")),
      ),
      body: Container(
        color: Colors.green.withOpacity(.2),
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height * 1 / 2 + 30,
            margin: EdgeInsets.all(10),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              margin: EdgeInsets.all(10),
              elevation: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    alignment: Alignment.center,
                    child: Text(
                      "Oturum Aç",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.teal),
                    ),
                  ),

                  //google ile giriş yap buttonu
                  Container(
                    margin: EdgeInsets.only(left: 10, top: 5, right: 10),
                    child: SocialLoginButton(
                      buttonColor: Colors.white,
                      buttonTextColor: Colors.black87,
                      buttonRadius: 16,
                      buttonFontSize: 17,
                      buttonFontWeight: FontWeight.bold,
                      buttonIcon: Image.asset("assets/images/google-logo.png"),
                      buttonPaddingsize: 10,
                      buttonText: "Gmail ile giriş yap",
                      onPressed: () => _loginWithGoogle(context),
                      buttonHeight: 60,
                    ),
                  ),
                  //Facebook ile giriş yap butonu
                  Container(
                    margin: EdgeInsets.only(left: 10, top: 10, right: 10),
                    child: SocialLoginButton(
                      buttonColor: Color(0xFF334D92),
                      buttonTextColor: Colors.white,
                      buttonRadius: 16,
                      buttonFontSize: 17,
                      buttonPaddingsize: 10,
                      buttonText: "Facebook ile giriş yap",
                      buttonIcon:
                          Image.asset("assets/images/facebook-logo.png"),
                      buttonHeight: 60,
                      onPressed: () => _loginWithFacebook(context),
                    ),
                  ),
                  //E-mail ile giriş yap butonu
                  Container(
                    margin: EdgeInsets.only(left: 10, top: 10, right: 10),
                    child: SocialLoginButton(
                      buttonColor: Colors.green,
                      buttonTextColor: Colors.white,
                      buttonRadius: 16,
                      buttonFontSize: 17,
                      buttonIcon: Icon(
                        Icons.email,
                        size: 35,
                        color: Colors.white,
                      ),
                      buttonPaddingsize: 10,
                      buttonText: "E-mail ile giriş yap",
                      buttonHeight: 60,
                      onPressed: () => _loginWithEmailAndPassword(context),
                    ),
                  ),

                  /*
                  //Misafir ile giriş yap butonu
                  Container(
                    margin: EdgeInsets.only(left: 10, top: 10, right: 10),
                    child: SocialLoginButton(
                      buttonColor: Colors.purple,
                      buttonTextColor: Colors.white,
                      buttonRadius: 16,
                      buttonFontSize: 17,
                      buttonIcon: Icon(
                        Icons.supervised_user_circle,
                        color: Colors.white,
                        size: 35,
                      ),
                      buttonPaddingsize: 10,
                      buttonText: "Misafir olarak giriş yap",
                      buttonHeight: 60,
                      onPressed: () => _loginGuest(context),
                    ),
                  ),
                  */
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
