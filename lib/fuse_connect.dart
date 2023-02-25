library fuse_connect;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

typedef SuccessCallback = void Function(String publicToken);
typedef InstitutionCallback = void Function(
  String institutionId,
  Function(String linkToken),
);
typedef ExitCallback = void Function(
  ConnectError? error,
  Map<String, dynamic>? metadata,
);

class ConnectError {
  String? errorCode;
  String? errorType;
  String? displayMessage;
  String? errorMessage;

  ConnectError({
    this.errorCode,
    this.errorType,
    this.displayMessage,
    this.errorMessage,
  });
}

class FuseConnect {
  /// A function that is called when a user successfully
  /// completes an onboarding.
  SuccessCallback onSuccess;
  InstitutionCallback onInstitutionSelected;

  /// A function that is called when a user exits Link without successfully
  /// linking an Item, or when an error occurs during Link initialization.
  /// The function should expect two arguments, a nullable error
  /// object and a metadata object.
  ExitCallback onExit;

  static const platform = MethodChannel('fuse_connect');

  FuseConnect({
    required this.onSuccess,
    required this.onExit,
    required this.onInstitutionSelected,
  }) {
    platform.setMethodCallHandler((call) async {
      switch (call.method) {
        case "onSuccess":
          _handleOnSuccess(call);
          break;
        case "onInstitutionSelected":
          Map<String, dynamic> arguments =
              Map<String, dynamic>.from(call.arguments);
          String institutionId = arguments['institution_id'];
          onInstitutionSelected(institutionId, (linkToken) {
            platform.invokeMethod('institutionSelectCallBack', [linkToken]);
          });
          break;
        case "onExit":
          _handleOnExit(call);

          break;
        case "close":
          platform.invokeMethod('close', []);
          break;
        case "event":
          _handleEventMethod(call);
          break;
      }
    });
  }

  _handleOnSuccess(MethodCall call) {
    Map<String, dynamic> arguments = Map<String, dynamic>.from(call.arguments);
    String publicToken = arguments['public_token'];
    onSuccess(publicToken);
  }

  _handleOnExit(MethodCall call) {
    ConnectError? connectErrorArg;
    Map<String, dynamic>? metadataArg;

    if (kDebugMode) {
      print("_handleOnExit");
      print(call.arguments);
    }

    Map<String, dynamic> arguments = Map<String, dynamic>.from(call.arguments);

    if (arguments['err']) {
      Map<String, dynamic> errorArguments =
          Map<String, dynamic>.from(arguments['err']);
      String errorCode = errorArguments["error_code"];
      String errorType = errorArguments["error_type"];
      String displayMessage = errorArguments["display_message"];
      String errorMessage = errorArguments["error_message"];
      connectErrorArg = ConnectError(
        errorCode: errorCode,
        displayMessage: displayMessage,
        errorType: errorType,
        errorMessage: errorMessage,
      );
    }

    onExit(connectErrorArg, metadataArg);
  }

  void _handleEventMethod(MethodCall call) {
    if (kDebugMode) {
      print('got event ${call.arguments}');
    }

    try {
      Map<String, dynamic> arguments =
          Map<String, dynamic>.from(call.arguments);
      String eventName = arguments['eventName'];

      Map<String, dynamic> meta = Map<String, dynamic>.from(arguments['meta']);

      if (kDebugMode) {
        print('event name $eventName');
        print('meta $meta');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Invalid arguments');
      }
    }
  }

  close() async {
    await platform.invokeMethod('close', []);
  }

  open(String token) async {
    await platform.invokeMethod('open', [token]);
  }
}
