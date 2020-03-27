import 'package:compound/models/route_argument.dart';
import 'package:compound/ui/views/home_view.dart';
import 'package:compound/ui/views/search_view.dart';
import 'package:compound/ui/views/verify_otp.dart';
import 'package:flutter/material.dart';
import 'package:compound/constants/route_names.dart';
import 'package:compound/ui/views/login_view.dart';
import 'package:compound/ui/views/signup_view.dart';
import 'package:page_transition/page_transition.dart';

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
    // case SignUpViewRoute:
    //   return _getPageRoute(
    //     routeName: settings.name,
    //     viewToShow: SignUpView(),
    //     pageArguments: pageArguments,
    //     pageTransitionType: transitionType,
    //   );
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
        pageTransitionType: transitionType,
      );
    case SearchViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: SearchView(),
        pageArguments: pageArguments,
        pageTransitionType: transitionType,
      );
    // case CreatePostViewRoute:
    //   var postToEdit = settings.arguments as Post;
    //   return _getPageRoute(
    //     routeName: settings.name,
    //     viewToShow: CreatePostView(
    //       edittingPost: postToEdit,
    //     ),
    //   );
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
    settings: RouteSettings(
      name: routeName,
      arguments: pageArguments
    ),
    child: viewToShow,
    type: pageTransitionType,
  );
}
