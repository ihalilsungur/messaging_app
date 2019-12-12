import 'package:get_it/get_it.dart';
import 'package:messaging_app/repository/message_repository_impl/message_repository_impl.dart';
import 'package:messaging_app/repository/pagination_repository_impl/pagination_repository_impl.dart';
import 'package:messaging_app/repository/user_repository_impl/user_repository_impl.dart';
import 'package:messaging_app/services/auth_base_user_service/auth_base_service_impl.dart';
import 'package:messaging_app/services/db_message_service_impl/db_message_service_impl.dart';
import 'package:messaging_app/services/db_pagination_service_impl/db_pagination_service_impl.dart';
import 'package:messaging_app/services/db_user_service_impl/db_user_service_impl.dart';
import 'package:messaging_app/services/fake_authentication_service/fake_authentication_service.dart';
import 'package:messaging_app/services/notification_bring_token_service_impl/notification_bring_token_service_impl.dart';
import 'package:messaging_app/services/notification_send_service_impl/notification_send_service_impl.dart';
import 'package:messaging_app/services/storage_base/storage_base_service_impl.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => AuthBaseServiceImpl());
  locator.registerLazySingleton(() => FakeAuthhenticationService());
  locator.registerLazySingleton(() => DbUserServiceImpl());
  locator.registerLazySingleton(() => UserRepositoryImpl());
  locator.registerLazySingleton(() => MessageRepositoryImpl());
  locator.registerLazySingleton(() => PaginationRepositoryImpl());
  locator.registerLazySingleton(() => StorageBaseServiceImpl());
  locator.registerLazySingleton(() => DbMessageServiceImpl());
  locator.registerLazySingleton(() => DbPaginationServiceImpl());
  locator.registerLazySingleton(() => NotificationSendServiceImpl());
  locator.registerLazySingleton(() => NotificationBringTokenServiceImpl());
}
