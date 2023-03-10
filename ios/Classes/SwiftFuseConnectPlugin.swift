import Flutter
import FuseConnect
import UIKit

public class SwiftFuseConnectPlugin: NSObject, FlutterPlugin {
    
    private var channel: FlutterMethodChannel
    private var token: String?
    private var institutionSelect: InstitutionSelect?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "fuse_connect", binaryMessenger: registrar.messenger())
        let instance = SwiftFuseConnectPlugin(channel: channel)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    init(channel : FlutterMethodChannel) {
        self.channel = channel
        super.init()
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as! [String]
        switch call.method {
        case "open":
            self.token = arguments[0]
            self.open(channel: channel)
        case "institutionSelectCallBack":
            self.institutionSelect?.callback(arguments[0])
        case "close":
            self.close()
        default:
            break
        }
    }
    
    func open(channel: FlutterMethodChannel) {
        let fuseConnectController = FuseConnectViewController(clientSecret: self.token!) { eventName, meta in
        } onSuccess: { linkSuccess in
            channel.invokeMethod("onSuccess", arguments: [
                "public_token": linkSuccess.public_token,
            ])
            self.close()
        } onInstitutionSelected: { institutionSelect in
            self.institutionSelect = institutionSelect
            channel.invokeMethod("onInstitutionSelected", arguments: [
                "institution_id": institutionSelect.institution_id,
            ])
        } onExit: { connectExit in
            var arguments: [String: Any] = [:]

            if let connectError = connectExit.err {
                arguments["err"] = [
                    "error_code": connectError.errorCode,
                    "error_type": connectError.errorType,
                    "display_message": connectError.displayMessage,
                    "error_message": connectError.errorMessage,
                ]
            } else {
                arguments["err"] = nil
            }

            channel.invokeMethod("onExit", arguments: arguments)
            self.close()
        }
        
        fuseConnectController.modalPresentationStyle = .fullScreen
        UIApplication.shared.keyWindow?.rootViewController?.present(fuseConnectController, animated: true, completion: nil)
    }
    
    func close() {
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true)
    }
}
