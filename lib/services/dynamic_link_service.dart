import 'package:fimber/fimber.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

import '../constants/route_names.dart';
import 'navigation_service.dart';

class DynamicLinkService {
  Future handleDynamicLink() async {
    FirebaseDynamicLinks.instance.onLink.listen((linkData) {
      final Uri deepLink = linkData.link;
      // ignore: unnecessary_null_comparison
      if (deepLink != null) {
        List<String> segments = deepLink.pathSegments;
        Map<String, String> data = {
          "contentType": segments[0],
          "id": segments[1],
        };
        NavigationService.to(DynamicContentViewRoute, arguments: data);
      }
    }).onError((error) {
      Fimber.e("Dynamic Link Failed : ${error.toString()}");
    });
    //   (
    //     onSuccess: (PendingDynamicLinkData linkData) async {
    //   final Uri deepLink = linkData?.link;
    //   if (deepLink != null) {
    //     List<String> segments = deepLink.pathSegments;
    //     Map<String, String> data = {
    //       "contentType": segments[0],
    //       "id": segments[1],
    //     };
    //     NavigationService.to(DynamicContentViewRoute, arguments: data);
    //   }
    // }, onError: (final Uri deepLink = linkData?.link;
    //     //   if (deepLink != null) {
    //     //     List<String> segments = deepLink.pathSegments;
    //     //     Map<String, String> data = {
    //     //       "contentType": segments[0],
    //     //       "id": segments[1],
    //     //     };
    //     //     NavigationService.to(DynamicContentViewRoute, arguments: data);
    // });

    // FirebaseDynamicLinks.instance.onLink(
    //       onSuccess: (PendingDynamicLinkData linkData) async {
    //   final Uri deepLink = linkData?.link;
    //   if (deepLink != null) {
    //     List<String> segments = deepLink.pathSegments;
    //     Map<String, String> data = {
    //       "contentType": segments[0],
    //       "id": segments[1],
    //     };
    //     NavigationService.to(DynamicContentViewRoute, arguments: data);
    //   }
    // }, onError: (Error e) {
    //   // Fimber.e("Dynamic Link Failed : ${e.message}");
    //   return;
    // });
  }

  //// NEED TO SOLVE
  Future<String?> createLink(String url) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: "https://host.page.link",
        link: Uri.parse(url),
        androidParameters: AndroidParameters(
            packageName: "in.host.host_app", minimumVersion: 0),
        iosParameters: IOSParameters(
            bundleId: "in.host.host-app",
            minimumVersion: '1.0.0',
            appStoreId: '1562083632'));

    final ShortDynamicLink shortDynamicLink =
        await FirebaseDynamicLinks.instance.buildShortLink(parameters);
    final Uri uri = shortDynamicLink.shortUrl;
    return uri.toString();

    // final link = await parameters.buildUrl();

    // final ShortDynamicLink shortenedLink =
    //     await DynamicLinkParameters.shortenUrl(
    //   link,
    //   DynamicLinkParametersOptions(
    //       shortDynamicLinkPathLength: ShortDynamicLinkPathLength.unguessable),
    // );
    // return shortenedLink.shortUrl.toString();
  }
}
