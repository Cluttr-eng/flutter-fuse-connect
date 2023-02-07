library fuse_connect;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

typedef SuccessCallback = void Function(String publicToken);
typedef InstitutionCallback = void Function(
    String institutionId,
    Function(String linkToken),
    );
typedef ExitCallback = void Function(String? error);

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
          handleOnSuccessMethod(call);
          break;
        case "onInstitutionSelected":
          Map<String, dynamic> arguments =
          Map<String, dynamic>.from(call.arguments);
          String institutionId = arguments['institution_id'];
          onInstitutionSelected(institutionId, (linkToken) {
            platform.invokeMethod('institutionSelectCallBack', [linkToken]);
          });
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

  handleOnSuccessMethod(MethodCall call) {
    Map<String, dynamic> arguments = Map<String, dynamic>.from(call.arguments);
    String publicToken = arguments['public_token'];

    onSuccess(publicToken);
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

      handleEvent(eventName, meta);
    } catch (e) {
      if (kDebugMode) {
        print('Invalid arguments');
      }
    }
  }

  handleEvent(String eventName, Map<String, dynamic> meta) {
    switch (eventName) {
      case "onSuccess":
        {
          // onSuccess();
        }
        break;
      case "onExit":
        {
          onExit("something went wrong");
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
