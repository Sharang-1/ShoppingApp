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
 
}
