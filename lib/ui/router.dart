import 'package:compound/models/productPageArg.dart';
import 'package:compound/models/products.dart';
import 'package:compound/models/route_argument.dart';
import 'package:compound/ui/views/appointment_booked_view.dart';
import 'package:compound/ui/views/cart_view.dart';
import 'package:compound/ui/views/categories_view.dart';
import 'package:compound/ui/views/category_indi_view.dart';
import 'package:compound/ui/views/home_view.dart';
import 'package:compound/ui/views/map_view.dart';
import 'package:compound/ui/views/myorders_view.dart';
import 'package:compound/ui/views/dynamic_content_loading_view.dart';
import 'package:compound/ui/views/notification_view.dart';
import 'package:compound/ui/views/order_placed_view.dart';
import 'package:compound/ui/views/otp_verified_view.dart';
import 'package:compound/ui/views/otp_verified_2_view.dart';
import 'package:compound/ui/views/productListView.dart';
import 'package:compound/ui/views/product_individual_view.dart';
import 'package:compound/ui/views/product_whishlist_view.dart';
import 'package:compound/ui/views/profile_view.dart';
import 'package:compound/ui/views/search_view.dart';
import 'package:compound/ui/views/settings_page_view.dart';
import 'package:compound/ui/views/verify_otp.dart';
import 'package:compound/ui/views/myAppointments_view.dart';
import 'package:compound/ui/views/seller_indi_view.dart';
import 'package:compound/ui/views/intro.dart';
import 'package:flutter/material.dart';
import 'package:compound/constants/route_names.dart';
import 'package:compound/ui/views/login_view.dart';
import 'package:page_transition/page_transition.dart';
import 'package:compound/ui/views/loader.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  PageTransitionType transitionType = PageTransitionType.fade;
  Object pageArguments = settings.arguments;

  if (settings.arguments is CustomRouteArgument) {
    var customRouteArgument = settings.arguments as CustomRouteArgument;
    transitionType = customRouteArgument.type;
    pageArguments = customRouteArgument.arguments;
  }

  switch (settings.name) {
    case LoginViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: LoginView(),
        pageArguments: pageArguments,
        pageTransitionType: transitionType,
      );
    case MyHomePageRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: MyHomePage(),
        pageArguments: pageArguments,
        pageTransitionType: transitionType,
      );
    case LoaderRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: loader(),
        pageArguments: pageArguments,
        pageTransitionType: transitionType,
      );
    case HomeViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: HomeView(),
        pageArguments: pageArguments,
        pageTransitionType: transitionType,
      );
    case VerifyOTPViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: VerifyOTPView(),
        pageArguments: pageArguments,
        pageTransitionType: PageTransitionType.rightToLeft,
      );
    case OtpVerifiedRoute : 
      return _getPageRoute(
        pageArguments: pageArguments, 
        routeName: settings.name, 
        viewToShow: OtpVerifiedView(), 
        pageTransitionType: PageTransitionType.rightToLeft
      );
    case OtpVerified2Route : 
      return _getPageRoute(
        pageArguments: pageArguments, 
        routeName: settings.name, 
        viewToShow: OtpVerifiedView2(), 
        pageTransitionType: PageTransitionType.rightToLeft
      );
    case SearchViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: SearchView(),
        pageArguments: pageArguments,
        pageTransitionType: transitionType,
      );
    case CartViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: CartView(),
        pageArguments: pageArguments,
        pageTransitionType: PageTransitionType.rightToLeft,
      );
    case ProductsListRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: ProductListView(
          queryString: (pageArguments as ProductPageArg).queryString,
          subCategory: (pageArguments as ProductPageArg).subCategory,
        ),
        pageArguments: pageArguments,
        pageTransitionType: PageTransitionType.rightToLeft,
      );
    case WhishListRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: WhishList(),
        pageArguments: pageArguments,
        pageTransitionType: PageTransitionType.rightToLeft,
      );
    case CategoriesRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: CategoriesView(),
        pageArguments: pageArguments,
        pageTransitionType: PageTransitionType.rightToLeft,
      );
    case ProductIndividualRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: ProductIndiView(data: (pageArguments as Product)),
        pageArguments: pageArguments as Product,
        pageTransitionType: PageTransitionType.rightToLeft,
      );
    case MapViewRoute:
      return _getPageRoute(
          pageArguments: pageArguments,
          routeName: settings.name,
          viewToShow: MapView(),
          pageTransitionType: PageTransitionType.rightToLeft);
    case ProductIndividualRoute:
      return _getPageRoute(
          pageArguments: pageArguments,
          routeName: settings.name,
          viewToShow: ProductIndiView(data: pageArguments),
          pageTransitionType: PageTransitionType.rightToLeft);
    case PaymentFinishedScreenRoute:
      return _getPageRoute(
          pageArguments: pageArguments,
          routeName: settings.name,
          viewToShow: OrderPlacedView(),
          pageTransitionType: PageTransitionType.rightToLeft);
    case AppointmentBookedScreenRoute:
      return _getPageRoute(
          pageArguments: pageArguments,
          routeName: settings.name,
          viewToShow: AppointmentBookedView(),
          pageTransitionType: PageTransitionType.rightToLeft);
    case MyOrdersRoute:
      return _getPageRoute(
          pageArguments: pageArguments,
          routeName: settings.name,
          viewToShow: MyOrdersView(),
          pageTransitionType: PageTransitionType.rightToLeft);

    case NotifcationViewRoute:
      return _getPageRoute(
          pageArguments: pageArguments,
          routeName: settings.name,
          viewToShow: NotificationView(),
          pageTransitionType: PageTransitionType.rightToLeft);

    case DynamicContentViewRoute: 
      return _getPageRoute(pageArguments: pageArguments, 
      routeName: settings.name, 
      viewToShow: DynamicContentLoadingView(data: pageArguments), 
      pageTransitionType: PageTransitionType.downToUp);

    case BuyNowRoute:
      print("Buy now page args " + pageArguments.toString());
      return _getPageRoute(
          pageArguments: pageArguments,
          routeName: settings.name,
          viewToShow: CartView(
            productId: pageArguments.toString(),
          ),
          pageTransitionType: PageTransitionType.rightToLeft);
    case SellerIndiViewRoute:
      return _getPageRoute(
          pageArguments: pageArguments,
          routeName: settings.name,
          viewToShow: SellerIndi(data: pageArguments),
          pageTransitionType: transitionType);
    case MyAppointmentViewRoute:
      return _getPageRoute(
          pageArguments: pageArguments,
          routeName: settings.name,
          viewToShow: myAppointments(),
          pageTransitionType: PageTransitionType.rightToLeft);
    case ProfileViewRoute:
      return _getPageRoute(
          pageArguments: pageArguments,
          routeName: settings.name,
          viewToShow: ProfileView(),
          pageTransitionType: PageTransitionType.rightToLeft);

    case CategoryIndiViewRoute:
      var pargs = pageArguments as ProductPageArg;
      return _getPageRoute(
          pageArguments: pageArguments,
          routeName: settings.name,
          viewToShow: CategoryIndiView(
            queryString: pargs.queryString,
            subCategory: pargs.subCategory,
          ),
          pageTransitionType: PageTransitionType.rightToLeft);

    case SettingsRoute:
      return _getPageRoute(
          pageArguments: pageArguments,
          routeName: settings.name,
          viewToShow: SettingsView(),
          pageTransitionType:  PageTransitionType.rightToLeft);
    default:
      return MaterialPageRoute(
          builder: (_) => Scaffold(
                body: Center(
                    child: Text('No route defined for ${settings.name}')),
              ));
  }
}

PageRoute _getPageRoute({
  @required Object pageArguments,
  @required String routeName,
  @required Widget viewToShow,
  @required PageTransitionType pageTransitionType,
}) {
  return PageTransition(
    settings: RouteSettings(name: routeName, arguments: pageArguments),
    child: viewToShow,
    type: pageTransitionType,
  );
}
