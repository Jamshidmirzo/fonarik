import UIKit
import Flutter
import AVFoundation

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let flashlightChannel = FlutterMethodChannel(name: "com.example.flashlight/flashlight",
                                                      binaryMessenger: controller.binaryMessenger)
        flashlightChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            if (call.method == "toggleFlashlight") {
                let isOn = call.arguments as! Bool
                self.toggleFlashlight(isOn: isOn)
                result(nil)
            } else {
                result(FlutterMethodNotImplemented)
            }
        })
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func toggleFlashlight(isOn: Bool) {
        guard let device = AVCaptureDevice.default(for: .video), device.hasTorch else { return }
        do {
            try device.lockForConfiguration()
            device.torchMode = isOn ? .on : .off
            device.unlockForConfiguration()
        } catch {
            print("Torch could not be used")
        }
    }
}
