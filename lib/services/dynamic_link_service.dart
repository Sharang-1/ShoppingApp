import 'package:fimber/fimber.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

import '../constants/route_names.dart';
import '../locator.dart';
import 'navigation_service.dart';

class DynamicLinkService {
  NavigationService _navigationService = locator<NavigationService>();

  Future handleDynamicLink() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData linkData) async {
      final Uri deepLink = linkData?.link;
      if (deepLink != null) {
        List<String> segments = deepLink.pathSegments;
        Map<String, String> data = {
          "contentType": segments[0],
          "id": segments[1],
        };
        _navigationService.navigateTo(DynamicContentViewRoute, arguments: data);
      }
    }, onError: (OnLinkErrorException e) {
      Fimber.e("Dynamic Link Failed : ${e.message}");
      return;
    });

    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      List<String> segments = deepLink.pathSegments;
      Map<String, String> data = {
        "contentType": segments[0],
        "id": segments[1],
      };
      _navigationService.navigateTo(DynamicContentViewRoute, arguments: data);
    }
  }

  Future<String> createLink(String url) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: "https://dzor.page.link",
      link: Uri.parse(url),
      androidParameters:
          AndroidParameters(packageName: "in.dzor.dzor_app", minimumVersion: 0),
      iosParameters: IosParameters(
          bundleId: "in.dzor.dzor-app",
          minimumVersion: '1.0.0',
          appStoreId: '1562083632'),
    );

    final link = await parameters.buildUrl();
    final ShortDynamicLink shortenedLink =
        await DynamicLinkParameters.shortenUrl(
      link,
      DynamicLinkParametersOptions(
          shortDynamicLinkPathLength: ShortDynamicLinkPathLength.unguessable),
    );
    return shortenedLink.shortUrl.toString();
  }
}
