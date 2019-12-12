import 'package:flutter/material.dart';
import 'package:messaging_app/app/talk_page.dart';
import 'package:messaging_app/models/user.dart';
import 'package:messaging_app/viewmodel/all_users_view_model.dart';
import 'package:messaging_app/viewmodel/chat_view_model.dart';
import 'package:messaging_app/viewmodel/user_view_model.dart';
import 'package:provider/provider.dart';

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  bool _isLoading = false;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    //minscrollextent listenin en sonunda oldugunda calisir.
    //maxscrollextent ise listenin en basinda oldugunda calisir
    _scrollController.addListener(_listScrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Kullanıcılar",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () async {
              _bringMoreUsers();
            },
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.supervised_user_circle,
                  color: Colors.white,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text(
                    "Next Users",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          )
        ],
      ),
      body: Consumer<AllUsersViewModel>(
        builder: (context, model, child) {
          if (model.allUsersViewState == AllUsersViewState.Busy) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (model.allUsersViewState == AllUsersViewState.Loaded) {
            return RefreshIndicator(
              onRefresh: model.refreshIndicator,
              child: ListView.builder(
                controller: _scrollController,
                itemBuilder: (BuildContext context, int index) {
                  if (model.allUsers.length == 1) {
                    return _noUsers();
                  } else {
                    if (model.hasMoreLoading &&
                        index == model.allUsers.length) {
                      return _loadingNewElementsIndicator();
                    } else {
                      return _createElementForUserList(index);
                    }
                  }
                },
                itemCount: model.hasMoreLoading
                    ? model.allUsers.length + 1
                    : model.allUsers.length,
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _createElementForUserList(int index) {
    final _allUsersViewModel = Provider.of<AllUsersViewModel>(context);
    final _userViewmodel = Provider.of<UserViewModel>(context);
    User _currentUser = _allUsersViewModel.allUsers[index];

    // Burada giriş yapan kullanıcının listeden gorunmesini engellemek içindir.
    if (_currentUser.userId == _userViewmodel.user.userId) {
      return Container();
    }
    return GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider<ChatViewModel>(
              builder: (context) => ChatViewModel(
                currentUser: _userViewmodel.user,
                chatUser: _currentUser,
              ),
              child: TalkPage(
              ),
            ),
          ),
        );
      },
      child: Card(
        elevation: 4,
        child: ListTile(
          title: Text(
            _currentUser.username,
            style: TextStyle(
                color: Colors.teal, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            _currentUser.email,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          leading: CircleAvatar(
            backgroundImage: _currentUser.profilePhotoUrl.isNotEmpty
                ? NetworkImage(_currentUser.profilePhotoUrl)
                : null,
            radius: 30,
          ),
        ),
      ),
    );
  }

  _loadingNewElementsIndicator() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  //daha fazla kullanıcı getir
  void _bringMoreUsers() async {
    if (_isLoading == false) {
      _isLoading = true;
      final _allUsersViewModel = Provider.of<AllUsersViewModel>(context);
      await _allUsersViewModel.bringMoreUsers();
      _isLoading = false;
    }
  }

  void _listScrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _bringMoreUsers();
      print("Listenin sonundayım");
    }
  }

  Widget _noUsers() {
    final _allUsersViewModel = Provider.of<AllUsersViewModel>(context);
    return RefreshIndicator(
      onRefresh: _allUsersViewModel.refreshIndicator,
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
                  Icons.supervised_user_circle,
                  size: 40,
                  color: Theme.of(context).primaryColor,
                ),
                Text(
                  "Kayıtlı Hiç Bir Kullanıcı Yok",
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
}
