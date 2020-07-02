import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if let googleMapsApiKey = getGoogleMapsApiKey() {
            GMSServices.provideAPIKey(googleMapsApiKey)
        }
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func getGoogleMapsApiKey() -> String? {
        if let path = Bundle.main.path(forResource: "Keys", ofType: "plist") {
            if let keys = NSDictionary(contentsOfFile: path) {
                return keys.value(forKey: "google_maps_api_key") as? String
            }
        }
        return nil
    }
}
