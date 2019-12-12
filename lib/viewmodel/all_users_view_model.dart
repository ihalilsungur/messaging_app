import 'package:flutter/material.dart';
import 'package:messaging_app/models/user.dart';
import 'package:messaging_app/repository/pagination_repository_impl/pagination_repository_impl.dart';
import '../locator .dart';

enum AllUsersViewState { Idle, Loaded, Busy }

class AllUsersViewModel with ChangeNotifier {
  List<User> _allUsers;
    PaginationRepositoryImpl _paginationRepository = locator<PaginationRepositoryImpl>();
  AllUsersViewState _allUsersViewState = AllUsersViewState.Idle;
  User _bringedTheLastUser;
  final int _messageCountPerPage = 8;
  bool _hasMore = true;

  bool get hasMoreLoading => _hasMore;

  List<User> get allUsers => _allUsers;
  AllUsersViewState get allUsersViewState => _allUsersViewState;

  set allUsersViewState(AllUsersViewState value) {
    _allUsersViewState = value;
    notifyListeners();
  }

  AllUsersViewModel() {
    _allUsers = [];
    _bringedTheLastUser = null;
    getAllUsersWithPagination(_bringedTheLastUser, false);
  }

  //Refresh ve sayfalam icin
  //yeni elemanlar getirilir  ve true yapilir
  //ilk acilis icin yeni elemanlar için false deger verilir
  getAllUsersWithPagination(
      User _bringedTheLastUser, bool fetchingNewElements) async {
    if (_allUsers.length > 0) {
      _bringedTheLastUser = _allUsers.last;
      print("Listenin içindeki en son eleman :" + _bringedTheLastUser.username);
    }
    if (fetchingNewElements) {
    } else {
      allUsersViewState = AllUsersViewState.Busy;
    }

    var _newList = await _paginationRepository.getAllUsersWithPagination(
        _bringedTheLastUser, _messageCountPerPage);
    if (_newList.length < _messageCountPerPage) {
      _hasMore = false;
    }

    _newList.forEach((user) => print("Gelen Username : " + user.username));
    _allUsers.addAll(_newList);

    allUsersViewState = AllUsersViewState.Loaded;
  }

  Future<void> bringMoreUsers() async {
    print("Daha fazla kullanıcı getir _allUsersViewModeldeyiz");
    if (_hasMore) {
      await getAllUsersWithPagination(_bringedTheLastUser, true);
    } else {
      print("Daha fazla eleman yok lutfen rahatsız etmeyin");
    }
    Future.delayed(Duration(seconds: 1));
  }

  Future<Null> refreshIndicator() async {
    _hasMore = true;
    _bringedTheLastUser = null;
    _allUsers = [];
    getAllUsersWithPagination(_bringedTheLastUser, false);
  }
}
