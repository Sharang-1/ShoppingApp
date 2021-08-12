import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../constants/route_names.dart';
import '../models/productPageArg.dart';
import '../models/products.dart';
import '../models/route_argument.dart';
import 'views/address_input_form_view.dart';
import 'views/appointment_booked_view.dart';
import 'views/cart_view.dart';
import 'views/categories_view.dart';
import 'views/category_indi_view.dart';
import 'views/dynamic_content_loading_view.dart';
import 'views/dzor_explore_view.dart';
import 'views/home_view.dart';
import 'views/intro.dart';
import 'views/loader.dart';
import 'views/login_view.dart';
import 'views/map_view.dart';
import 'views/myAppointments_view.dart';
import 'views/myorders_details_view.dart';
import 'views/myorders_view.dart';
import 'views/order_error_view.dart';
import 'views/order_placed_view.dart';
import 'views/otp_verified_2_view.dart';
import 'views/otp_verified_view.dart';
import 'views/productListView.dart';
import 'views/product_individual_view.dart';
import 'views/product_wishlist_view.dart';
import 'views/profile_view.dart';
import 'views/reviews_screen.dart';
import 'views/search_view.dart';
import 'views/seller_indi_view.dart';
import 'views/settings_page_view.dart';
import 'views/verify_otp.dart';

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

    case IntroPageRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: IntroPage(),
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
        viewToShow: HomeView(args: pageArguments,),
        pageArguments: pageArguments,
        pageTransitionType: transitionType,
      );

    case VerifyOTPViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: VerifyOTPView(
          ageId: (pageArguments as Map<String, int>)["ageId"],
          genderId: (pageArguments as Map<String, int>)["genderId"],
        ),
        pageArguments: pageArguments,
        pageTransitionType: PageTransitionType.rightToLeft,
      );

    case OtpVerifiedRoute:
      return _getPageRoute(
          pageArguments: pageArguments,
          routeName: settings.name,
          viewToShow: OtpVerifiedView(),
          pageTransitionType: PageTransitionType.rightToLeft);

    case OtpVerified2Route:
      return _getPageRoute(
          pageArguments: pageArguments,
          routeName: settings.name,
          viewToShow: OtpVerifiedView2(),
          pageTransitionType: PageTransitionType.rightToLeft);

    case SearchViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: SearchView(showSellers: pageArguments),
        pageArguments: pageArguments,
        pageTransitionType: transitionType,
      );

    case DzorExploreViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: DzorExploreView(),
        pageArguments: pageArguments,
        pageTransitionType: PageTransitionType.bottomToTop,
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
          queryString: (pageArguments as ProductPageArg)?.queryString,
          subCategory: (pageArguments as ProductPageArg)?.subCategory,
          sellerPhoto: (pageArguments as ProductPageArg)?.sellerPhoto,
          productList: (pageArguments as ProductPageArg)?.productList,
        ),
        pageArguments: pageArguments,
        pageTransitionType: PageTransitionType.rightToLeft,
      );

    case WishListRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: WishList(),
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
          viewToShow: MapView(sellerKey: (pageArguments as String)),
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

    case PaymentErrorScreenRoute:
      return _getPageRoute(
          pageArguments: pageArguments,
          routeName: settings.name,
          viewToShow: OrderErrorView(error: (pageArguments as OrderError)),
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

    case MyOrderDetailsRoute:
      return _getPageRoute(
          pageArguments: pageArguments,
          routeName: settings.name,
          viewToShow: MyOrdersDetailsView(pageArguments),
          pageTransitionType: PageTransitionType.rightToLeft);

    case DynamicContentViewRoute:
      return _getPageRoute(
          pageArguments: pageArguments,
          routeName: settings.name,
          viewToShow: DynamicContentLoadingView(data: pageArguments),
          pageTransitionType: PageTransitionType.bottomToTop);

    case ReviewScreenRoute:
      return _getPageRoute(
          pageArguments: pageArguments,
          routeName: settings.name,
          viewToShow: ReviewsScreen(reviews: pageArguments),
          pageTransitionType: PageTransitionType.bottomToTop);

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
          pageTransitionType: PageTransitionType.rightToLeft);

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
          viewToShow: ProfileView(
            controller: pageArguments,
          ),
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

    case AddressInputPageRoute:
      return _getPageRoute(
          pageArguments: pageArguments,
          routeName: settings.name,
          viewToShow: AddressInputPage(),
          pageTransitionType: PageTransitionType.rightToLeft);

    case SettingsRoute:
      return _getPageRoute(
          pageArguments: pageArguments,
          routeName: settings.name,
          viewToShow: SettingsView(),
          pageTransitionType: PageTransitionType.rightToLeft);
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
