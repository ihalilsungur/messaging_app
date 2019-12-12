import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:messaging_app/app/error_exception.dart';
import 'package:messaging_app/common_widget/platform_responsive_alert_dialog.dart';
import 'package:messaging_app/common_widget/social_login_button.dart';
import 'package:messaging_app/models/user.dart';
import 'package:messaging_app/viewmodel/user_view_model.dart';
import 'package:provider/provider.dart';

enum FormType { Login, Register }

class LoginWithEmailAndPassword extends StatefulWidget {
  @override
  _LoginWithEmailAndPasswordState createState() =>
      _LoginWithEmailAndPasswordState();
}

class _LoginWithEmailAndPasswordState extends State<LoginWithEmailAndPassword> {
  String _username;
  String _email;
  String _password;
  String _buttonText = "Giriş Yap";
  String _linkText = "Hesabınız Yok Mu ? Kayıt Olun";
  String _titleText = "Email ve Şifre ile Giriş";
  var _formType = FormType.Login;
  var _formKey = GlobalKey<FormState>();
  bool _automaticControl = false;

  void _formSubmit(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      final _userViewModel = Provider.of<UserViewModel>(context);
      _formKey.currentState.save();
      debugPrint("Kullanıcı : $_username Email : $_email  Şifre : $_password ");

      if (_formType == FormType.Login) {
        try {
          User _loggedInUser = await _userViewModel.signInWithEmailAndPassword(
              _email, _password);
          if (_loggedInUser != null) {
            print("Giriş Yapan Kullanıcının User Id : ${_loggedInUser.userId}");
          }
        } on PlatformException catch (e) {
          debugPrint("Widget Oturum Hatasi : " + e.toString());
          PlatformResponsiveAlertDialog(
            title: "Oturum Açma Hatası",
            content: ErrorException.showError(e.code.toString()),
            mainButtonText: "Tamam",
          ).show(context);
        }
      } else {
        try {
          User _createdUser = await _userViewModel
              .createUserWithEmailAndPassword(_email, _password, _username);

          if (_createdUser != null) {
            print("Kayıt Olan Kullanıcının User Id : ${_createdUser.userId}");
            print(
                "Kayıt Olan Kullanıcının Username : ${_createdUser.username}");
          }
        } on PlatformException catch (e) {
          debugPrint("Widget Kullanıcı oluşturma  Hatasi  :" +
              ErrorException.showError(e.code.toString()));

          PlatformResponsiveAlertDialog(
            title: "Kullanıcı Oluşturma Hatası",
            content: ErrorException.showError(e.code.toString()),
            mainButtonText: "Tamam",
          ).show(context);
        }
      }
    }
  }

  void _changeFormType() {
    setState(() {
      if (_formType == FormType.Login) {
        _formType = FormType.Register;
      } else {
        _formType = FormType.Login;
      }
    });
  }

  void _confirmLogin() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
    } else {
      setState(() {
        _automaticControl = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
      final _userViewModel = Provider.of<UserViewModel>(context);
    _buttonText = _formType == FormType.Login ? "Giriş Yap" : "Kayıt Ol";
    _linkText = _formType == FormType.Login
        ? "Hesabınız Yok Mu ? Kayıt Olun"
        : "Hesabınız Var Mı ? Giriş Yap";
    _titleText = _formType == FormType.Login
        ? "Email ve Şifre ile Giriş "
        : "Email ve Şifre ile Kayıt";
  
    if (_userViewModel.user != null) {
      Future.delayed(Duration(milliseconds: 1), () {
        Navigator.of(context).popUntil(ModalRoute.withName("/"));
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(),
          child: Text("Giriş / Kayıt"),
        ),
      ),
      body: _userViewModel.viewState == ViewState.Idle
          ? Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.tealAccent.shade100,
              child: Center(
                child: Container(
                  height: _formType == FormType.Login
                      ? MediaQuery.of(context).size.height * 2 / 3
                      : MediaQuery.of(context).size.height * .8,
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    margin: EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      autovalidate: _automaticControl,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding:
                              EdgeInsets.only(top: 20, left: 10, right: 10),
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: Text(
                                  _titleText,
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal),
                                ),
                              ),

                              //username alanı
                              _formType == FormType.Register
                                  ? Container(
                                      margin: EdgeInsets.only(top: 30),
                                      child: TextFormField(
                                        initialValue: "sungur",
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            prefixIcon: Icon(
                                                Icons.supervised_user_circle),
                                            labelText: "Kullanıcı",
                                            labelStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue),
                                            hintText:
                                                "Lütfen Kullanıcı Giriniz",
                                            hintStyle: TextStyle(
                                                fontWeight: FontWeight.bold),
                                            errorStyle: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                        onSaved: (String usernameEntered) {
                                          _username = usernameEntered;
                                          debugPrint(
                                              "Username Entered : $usernameEntered");
                                        },
                                        validator: _userViewModel.nameControl,
                                      ),
                                    )
                                  : Center(
                                      child: Text(""),
                                    ),

                              //email alanı
                              Container(
                                margin: EdgeInsets.only(top: 20),
                                child: TextFormField(
                                  initialValue: "sungur@gmail.com",
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      prefixIcon: Icon(Icons.email),
                                      labelText: "Email",
                                      labelStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue),
                                      hintText: "Lütfen Emailinizi Giriniz",
                                      hintStyle: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      errorStyle: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                  onSaved: (String mailEntered) {
                                    _email = mailEntered;
                                  },
                                  validator: _userViewModel.emailControl,
                                ),
                              ),

                              //password alanı
                              Container(
                                margin: EdgeInsets.only(top: 20),
                                child: TextFormField(
                                  initialValue: "iHs.0534",
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    prefixIcon: Icon(Icons.lock),
                                    labelText: "Şifre",
                                    labelStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue),
                                    hintText: "Lütfen Şifrenizi Giriniz",
                                    hintStyle:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                  onSaved: (passwordEntered) {
                                    _password = passwordEntered;
                                  },
                                  validator: _userViewModel.passwordControl,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 20),
                                child: SocialLoginButton(
                                  buttonText: _buttonText,
                                  buttonFontWeight: FontWeight.bold,
                                  buttonIcon: Icon(
                                    Icons.save,
                                    color: Colors.white,
                                  ),
                                  buttonColor: Colors.green,
                                  buttonFontSize: 20,
                                  buttonHeight: 60,
                                  onPressed: () {
                                    _confirmLogin();
                                    _formSubmit(context);
                                  },
                                ),
                              ),

                              Container(
                                margin: EdgeInsets.only(top: 20, bottom: 20),
                                child: FlatButton(
                                  child: Text(
                                    _linkText,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue),
                                  ),
                                  onPressed: () => _changeFormType(),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
