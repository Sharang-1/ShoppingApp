import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DynamicLinkService {
  final DynamicLinkParameters parameters = DynamicLinkParameters(
    uriPrefix: "http://dzor.in",
    link: Uri.parse("https://dzor.in/"),
    androidParameters: AndroidParameters(
      packageName: "com.example.dzor_app", 
      minimumVersion: 0
      ),
    iosParameters: IosParameters(
      bundleId: "com.example.dzor_app", 
      minimumVersion: '0',
      ),
  );

  Future handleDynamicLink() async {
    final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;
    print("Deep Link : ${deepLink.data}");
    FirebaseDynamicLinks.instance.onLink(
      onSuccess : (PendingDynamicLinkData linkData) async {
        print("Deep Link : $linkData");
        //Functionality to be added
      },
      onError: (OnLinkErrorException e) {
        print("Dynamic Link Failed : ${e.message}");
      }
    );
    return;
  }
 
}
