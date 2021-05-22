// Services
import 'package:compound/controllers/cart_count_controller.dart';
import 'package:compound/services/remote_config_service.dart';
import 'package:get/get.dart';

import 'controllers/home_controller.dart';
import 'controllers/lookup_controller.dart';
import 'controllers/wishlist_controller.dart';
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
import 'services/wishlist_service.dart';
import 'utils/image_selector.dart';

T locator<T>({String tag}) => Get.find<T>(tag: tag);

void setupLocator() {
  Get.lazyPut(() => AnalyticsService());
  Get.lazyPut(() => NavigationService());
  Get.lazyPut(() => APIService());
  Get.lazyPut(() => AuthenticationService());
  Get.lazyPut(() => ImageSelector());
  Get.lazyPut(() => LocationService());
  Get.lazyPut(() => PushNotificationService());
  Get.lazyPut(() => AddressService());
  Get.lazyPut(() => WishListService());
  Get.lazyPut(() => CartLocalStoreService());
  Get.lazyPut(() => DynamicLinkService());
  Get.lazyPut(() => RemoteConfigService());
  Get.lazyPut(() => ErrorHandlingService());
  Get.lazyPut(() => HomeController(), tag: "HomeController");
  Get.lazyPut(() => CartCountController(count: 0.obs));
  Get.lazyPut(() => WishListController(list: []));
  Get.lazyPut(() => LookupController());
}
