import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'fuse_connect_platform_interface.dart';

/// An implementation of [FuseConnectPlatform] that uses method channels.
class MethodChannelFuseConnect extends FuseConnectPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('fuse_connect');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
