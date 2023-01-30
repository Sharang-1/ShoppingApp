import UIKit
import Flutter
<<<<<<< Updated upstream
//import GoogleMaps
=======
// import GoogleMaps
>>>>>>> Stashed changes
import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
       FirebaseApp.configure()
    // GMSServices.provideAPIKey("AIzaSyCQo523YX7WkavuVVYLdFNXf79sJ89X2Ns")
//   if(FirebaseApp.app() == nil){
//   }
  
    GeneratedPluginRegistrant.register(with: self)
    
  
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

   Messaging.messaging().apnsToken = deviceToken
   super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
 }
}
	
