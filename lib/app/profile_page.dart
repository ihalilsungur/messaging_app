import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messaging_app/common_widget/platform_responsive_alert_dialog.dart';
import 'package:messaging_app/common_widget/social_login_button.dart';
import 'package:messaging_app/viewmodel/user_view_model.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File _profilePhotoFile;
  TextEditingController _controllerUsername;

  @override
  void initState() {
    super.initState();
    _controllerUsername = TextEditingController();
  }

  @override
  void dispose() {
    _controllerUsername.dispose();
    super.dispose();
  }

  void _takePhotoFromCamera() async {
    var _newPhoto = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _profilePhotoFile = _newPhoto;
      Navigator.of(context).pop();
    });
  }

  void _selectImageFromGallery() async {
    var _newPhoto = _profilePhotoFile =
        await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _profilePhotoFile = _newPhoto;
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    UserViewModel _userViewModel = Provider.of<UserViewModel>(context);
    _controllerUsername.text = _userViewModel.user.username;

    debugPrint(
        "Gelen Kullanıcı _userViewModel : " + _userViewModel.user.username);
    debugPrint(
        "User View Modeldeki User Verisi : " + _userViewModel.user.toString());
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Profile",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () => _askForConfirmation(context),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.exit_to_app,
                    size: 21,
                    color: Colors.white,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(
                      "Çıkış",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GestureDetector(
                      onTap: () {
                        debugPrint("tıklandı");
                        showModalBottomSheet(
                            context: context,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            builder: (BuildContext context) {
                              return Container(
                                height:
                                    MediaQuery.of(context).size.height * 1 / 4,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    ListTile(
                                      leading: Icon(
                                        Icons.camera,
                                        color: Colors.orange,
                                        size: 30,
                                      ),
                                      title: Text(
                                        "Kameradan Çek",
                                        style: TextStyle(
                                            color: Colors.orange,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22),
                                      ),
                                      onTap: () {
                                        _takePhotoFromCamera();
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(
                                        Icons.image,
                                        color: Colors.orange,
                                        size: 30,
                                      ),
                                      title: Text(
                                        "Galeriden Seç",
                                        style: TextStyle(
                                            color: Colors.orange,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22),
                                      ),
                                      onTap: () {
                                        _selectImageFromGallery();
                                      },
                                    ),
                                  ],
                                ),
                              );
                            });
                      },
                      child: CircleAvatar(
                        radius: 70,
                        backgroundImage: _profilePhotoFile == null
                            ? NetworkImage(_userViewModel.user.profilePhotoUrl)
                            : FileImage(_profilePhotoFile),
                      ),
                    ),
                  ),
                  TextFormField(
                    onSaved: (comingValue) {
                      _userViewModel.user.username = comingValue;
                    },
                    controller: _controllerUsername,
                    decoration: InputDecoration(
                      labelText: "Kullanıcı Adı",
                      labelStyle: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                      prefixIcon: Icon(
                        Icons.supervised_user_circle,
                        color: Colors.blue,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    style: TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                        fontSize: 22),
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  //email alani
                  TextFormField(
                    readOnly: true,
                    initialValue: _userViewModel.user.email,
                    decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 22),
                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.blue,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                    style: TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                        fontSize: 22),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    readOnly: true,
                    initialValue: _userViewModel.user.createdAt.toString(),
                    decoration: InputDecoration(
                        labelText: "Hesap Oluşturulma Tarihi",
                        labelStyle: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 22),
                        prefixIcon: Icon(
                          Icons.date_range,
                          color: Colors.blue,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                    style: TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                        fontSize: 22),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SocialLoginButton(
                    buttonText: "Güncelleme",
                    buttonTextColor: Colors.white,
                    buttonFontSize: 20,
                    buttonHeight: 60,
                    buttonColor: Colors.green,
                    onPressed: () {
                      _updateUsernameControl(context);
                      _updateProfilePhoto(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Future<bool> _logOut(context) async {
    final _userViewModel = Provider.of<UserViewModel>(context);
    bool result = await _userViewModel.signOut();
    return result;
  }

  Future _askForConfirmation(BuildContext context) async {
    final result = await PlatformResponsiveAlertDialog(
      title: "Emin Misiniz ?",
      content: "Çıkmak İstediğinize Emin Misiniz ?",
      mainButtonText: "Devam",
      cancelButtonText: "Vazgeç",
    ).show(context);

    if (result) {
      _logOut(context);
    }
  }

  void _updateUsernameControl(BuildContext context) async {
    final _userViewModel = Provider.of<UserViewModel>(context);
    if (_userViewModel.user.username != _controllerUsername.text) {
      var _updateResult = await _userViewModel.updateUsername(
          _userViewModel.user.userId, _controllerUsername.text);
      if (_updateResult == true) {
        PlatformResponsiveAlertDialog(
          title: " Kullanıcı Güncelleme",
          content: "Kullanıcı Başarılı Olarak Değiştirildi.",
          mainButtonText: "Tamam",
        ).show(context);
      } else {
        _controllerUsername.text = _userViewModel.user.username;
        PlatformResponsiveAlertDialog(
          title: " Kullanıcı Güncelleme",
          content:
              "Bu Kullanıcı Adı Daha Önce Alınmıştır\nFarklı Bir Kullanıcı Adı Deneyiniz!",
          mainButtonText: "Tamam",
        ).show(context);
      }
    }
  }

  void _updateProfilePhoto(BuildContext context) async {
    var _userViewModel = Provider.of<UserViewModel>(context);
    if (_profilePhotoFile != null) {
      var url = await _userViewModel.uploadFile(
          _userViewModel.user.userId, "profile_photo", _profilePhotoFile);
      debugPrint("Gele Url : " + url);
      if (url != null) {
        PlatformResponsiveAlertDialog(
          title: "Profile Resmini Değiştirme",
          content: "Profil fotoğrafınız Başarıyla güncellendi",
          mainButtonText: 'Tamam',
        ).show(context);
      }
    } 
  }
}
