import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, DismissProtocol {
    var receivedPath = String()
    var resultDismiss : FlutterResult!
    
    
    func sendData(filePath: String) {
            receivedPath = filePath
            if resultDismiss != nil{
                resultDismiss(filePath)
            }else{
                resultDismiss("")
            }
        }
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      let pluginChannel = FlutterMethodChannel(name: "elatech_liveliness_plugin",
                                               binaryMessenger: controller.binaryMessenger)
         pluginChannel.setMethodCallHandler({
           (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
             //initialize all global variables like result
             self.resultDismiss = result
             if(call.method=="detectliveliness"){
                 self.detectImage(call:call);
             }
             else{
                 result("hello world. an error occured");
             }
         })
      
      GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    func detectImage(call:FlutterMethodCall){
                var msgselfieCapture = ""
                var msgBlinkEye = ""
                guard let args = call.arguments else {
                    return
                }
                if let myArgs = args as? [String: Any],
                    let captureText = myArgs["msgselfieCapture"] as? String,
                    let blinkText = myArgs["msgBlinkEye"] as? String{
                    msgselfieCapture = captureText
                    msgBlinkEye = blinkText
                }
           self.detectLiveness(captureMessage: msgselfieCapture, blinkMessage: msgBlinkEye)
           
         }
    
    public func detectLiveness(captureMessage: String, blinkMessage: String){
        if let viewController = UIApplication.shared.keyWindow?.rootViewController as? FlutterViewController{
            let storyboardName = "MainLive"
            let storyboardBundle = Bundle.init(for: type(of: self))
            let storyboard = UIStoryboard(name: storyboardName, bundle: storyboardBundle)
            if let vc = storyboard.instantiateViewController(withIdentifier: "TestViewController") as? TestViewController {
                vc.captureMessageText = captureMessage
                vc.modalPresentationStyle = .fullScreen
                vc.blinkMessageText = blinkMessage 
                viewController.present(vc, animated: true, completion: nil)
                vc.dismissDelegate = self
            }
        }
    }
}
