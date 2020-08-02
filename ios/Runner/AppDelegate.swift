import UIKit
import Flutter
import GoogleMaps
import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyCQo523YX7WkavuVVYLdFNXf79sJ89X2Ns")
//   if(FirebaseApp.app() == nil){
       FirebaseApp.configure()
//   }
  
    GeneratedPluginRegistrant.register(with: self)
    
  
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
	
