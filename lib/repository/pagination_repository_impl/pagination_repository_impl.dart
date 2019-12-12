import 'package:messaging_app/locator%20.dart';
import 'package:messaging_app/models/message.dart';
import 'package:messaging_app/models/talk.dart';
import 'package:messaging_app/models/user.dart';
import 'package:messaging_app/repository/pagination_repository/pagination_repository.dart';
import 'package:messaging_app/services/db_pagination_service_impl/db_pagination_service_impl.dart';
import 'package:messaging_app/services/db_user_service_impl/db_user_service_impl.dart';
import 'package:timeago/timeago.dart' as timeago;

enum AppMode { DEBUG, RELEASE }

class PaginationRepositoryImpl implements PaginationRepository {

    //hangi veritabana göre calisacagini ayarliyoruz.
  AppMode appMode = AppMode.RELEASE;
 DbPaginationServiceImpl _dbPaginationServiceImpl = locator<DbPaginationServiceImpl>();
 DbUserServiceImpl _dbUserServiceImpl = locator<DbUserServiceImpl>();
 List<User> _allUsersList = [];
 
  @override
  Future<List<Talk>> getAllConversations(String currentUserId) async{
   
   if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      DateTime _time = await _dbPaginationServiceImpl.showTheClock(currentUserId);

      var _talksList =
          await _dbPaginationServiceImpl.getAllConversations(currentUserId);
      for (var currentTalk in _talksList) {
        var _userInUserList = _findUserFromList(currentTalk.listen);

        if (_userInUserList != null) {
          print("Veriler Lokal Olarak Okundu.");
          currentTalk.spokenUsername = _userInUserList.username;
          currentTalk.spokenUsernameProfileUrl =
              _userInUserList.profilePhotoUrl;
        } else {
          print("Veriler Veritabanından Okundu.");
          print(
              "Aranan Kullanıcı Verileri Local Cachede Bulunmadı.\n Kullanıcı Verileri Veritabanından Getirildi.");
          var _userReadFromDatabase =
              await _dbUserServiceImpl.readUser(currentTalk.listen);
          currentTalk.spokenUsername = _userReadFromDatabase.username;
          currentTalk.spokenUsernameProfileUrl =
              _userReadFromDatabase.profilePhotoUrl;
        }
        _accountTheTimeAgo(currentTalk, _time);
      }
      return _talksList;
    }
  }

   void _accountTheTimeAgo(Talk currentTalk, DateTime time) {
    currentTalk.lastReadTime = time;
    timeago.setLocaleMessages("tr", timeago.TrMessages());
    var _duration = time.difference(currentTalk.dateMessageToSent.toDate());
    currentTalk.timeDifference =
        timeago.format(time.subtract(_duration), locale: "tr");
  }

   User _findUserFromList(String currentUserId) {
    for (var i = 0; i < _allUsersList.length; i++) {
      if (_allUsersList[i].userId == currentUserId) {
        return _allUsersList[i];
      }
    }
    return null;
  }

  @override
  Future<List<User>> getAllUsersWithPagination(User bringedTheLastUser, int numberOfUsersToBring) async{
   if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      List<User> _userList = await _dbPaginationServiceImpl
          .getAllUsersWithPagination(bringedTheLastUser, numberOfUsersToBring);
      _allUsersList.addAll(_userList);
      return _userList;
    }
  }

  @override
  Future<List<Message>> getMessagesWithPagination(String currentUserId, String chatUserId, Message bringedTheLastMessage, messageCountPerPage)async {
   if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      return await _dbPaginationServiceImpl.getMessagesWithPagination(currentUserId,
          chatUserId, bringedTheLastMessage, messageCountPerPage);
    }
  }
}
