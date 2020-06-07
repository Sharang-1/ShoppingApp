import 'package:compound/services/whishlist_service.dart';
import 'package:get_it/get_it.dart';

// Services
import 'package:compound/services/address_service.dart';
import 'package:compound/services/authentication_service.dart';
import 'package:compound/services/api/api_service.dart';
import 'package:compound/services/location_service.dart';
import 'package:compound/services/push_notification_service.dart';
import 'package:compound/utils/image_selector.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:compound/services/dialog_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => APIService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => AuthenticationService());
  locator.registerLazySingleton(() => ImageSelector());
  locator.registerLazySingleton(() => LocationService());
  locator.registerLazySingleton(() => PushNotificationService());
  locator.registerLazySingleton(() => AddressService());
  locator.registerLazySingleton(() => WhishListService());
}
