import UIKit
import Flutter
import Screeb

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        let controller = self.window?.rootViewController
        bindScreebApi(controller: controller as! FlutterBinaryMessenger)
        Screeb.initSdk(context: controller, channelId: "5c62c145-91f1-4abd-8aa2-63d7847db1e1")
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func bindScreebApi(controller: FlutterBinaryMessenger) {
        let screebChannel = FlutterMethodChannel.init(name: "screeb/commands", binaryMessenger: controller)
        screebChannel.setMethodCallHandler { (call, result) in
            print("ios command \(call.method)")
            switch call.method {
                case "setIdentity":
                    guard let args = call.arguments else { return }
                    if let myArgs = args as? [String: Any], let userId = myArgs["userId"] as? String {
                        Screeb.setIdentity(uniqueVisitorId: userId)
                        result(true)
                    } else {
                        result(FlutterError(code: "-1",
                                            message: "iOS could not extract flutter arguments in method: \(call.method)",
                                            details: nil))
                    }
            case "sendTrackingEvent":
                guard let args = call.arguments else { return }
                if let myArgs = args as? [String: Any], let eventId = myArgs["eventId"] as? String {
                    Screeb.trackEvent(name: eventId)
                    result(true)
                } else {
                    result(FlutterError(code: "-1",
                                        message: "iOS could not extract flutter arguments in method: \(call.method)",
                                        details: nil))
                }
            case "sendTrackingScreen":
                guard let args = call.arguments else { return }
                if let myArgs = args as? [String: Any], let screen = myArgs["screen"] as? String {
                    Screeb.trackScreen(name: screen, trackingEventProperties: [:])
                    result(true)
                } else {
                    result(FlutterError(code: "-1",
                                        message: "iOS could not extract flutter arguments in method: \(call.method)",
                                        details: nil))
                }
            case "visitorProperty":
                guard let args = call.arguments else { return }
                if let myArgs = args as? [String: Any] {
                    let map = self.mapToAnyEncodable(map: myArgs)
                    Screeb.visitorProperty(visitorProperty: map)
                    result(true)
                } else {
                    result(FlutterError(code: "-1",
                                        message: "iOS could not extract flutter arguments in method: \(call.method)",
                                        details: nil))
                }
                default:
                    result(FlutterError(code: "-1", message: "iOS could not extract " +
                           "flutter arguments in method: \(call.method)", details: nil))
                    break
            }
        }
    }
    
    private func mapToAnyEncodable(map: [String: Any]) -> [String: AnyEncodable?] {
        return map.mapValues{
            value in
            switch value {
            case is String:
                return AnyEncodable(value as! String)
            case is Bool:
                return AnyEncodable(value as! Bool)
            case is Float:
                return AnyEncodable(value as! Float)
            case is Int:
                return AnyEncodable(value as! Int)
            default: break
            }
            return nil
        }
    }
}
