// Services
import 'package:get_it/get_it.dart';

import 'services/address_service.dart';
import 'services/analytics_service.dart';
import 'services/api/api_service.dart';
import 'services/authentication_service.dart';
import 'services/cart_local_store_service.dart';
import 'services/dynamic_link_service.dart';
import 'services/error_handling_service.dart';
import 'services/location_service.dart';
import 'services/navigation_service.dart';
import 'services/push_notification_service.dart';
import 'services/whishlist_service.dart';
import 'utils/image_selector.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => AnalyticsService());
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => APIService());
  locator.registerLazySingleton(() => AuthenticationService());
  locator.registerLazySingleton(() => ImageSelector());
  locator.registerLazySingleton(() => LocationService());
  locator.registerLazySingleton(() => PushNotificationService());
  locator.registerLazySingleton(() => AddressService());
  locator.registerLazySingleton(() => WhishListService());
  locator.registerLazySingleton(() => CartLocalStoreService());
  locator.registerLazySingleton(() => DynamicLinkService());
  locator.registerLazySingleton(() => ErrorHandlingService());
}
