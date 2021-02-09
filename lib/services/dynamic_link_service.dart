import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:compound/locator.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:compound/constants/route_names.dart';


class DynamicLinkService {

  NavigationService _navigationService = locator<NavigationService>();

  Future handleDynamicLink() async {
    // final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();
    // final Uri deepLink = data?.link;
    // print("Deep Link : ${deepLink.data}");
    FirebaseDynamicLinks.instance.onLink(
      onSuccess : (PendingDynamicLinkData linkData) async {
        final Uri deepLink = linkData?.link;
        if(deepLink != null){
          List<String> segments = deepLink.pathSegments;
          Map<String,String> data = {
            "contentType": segments[0],
            "id": segments[1],
          };
          _navigationService.navigateTo(DynamicContentViewRoute, arguments: data);
        }
      },
      onError: (OnLinkErrorException e) {
        print("Dynamic Link Failed : ${e.message}");
      }
    );
    return;
  }

  Future<String> createLink(String url) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
    uriPrefix: "http://dzor.page.link",
    link: Uri.parse(url),
    androidParameters: AndroidParameters(
      packageName: "in.dzor.dzor_app", 
      minimumVersion: 0
      ),
    iosParameters: IosParameters(
      bundleId: "in.dzor.dzor-app", 
      minimumVersion: '1.0.1',
      appStoreId: '123456789'
      ),
  );

  final link = await parameters.buildUrl();
  final ShortDynamicLink shortenedLink = await DynamicLinkParameters.shortenUrl(
      link,
      DynamicLinkParametersOptions(shortDynamicLinkPathLength: ShortDynamicLinkPathLength.unguessable),
    );
  return shortenedLink.shortUrl.toString();
  }
 
}
