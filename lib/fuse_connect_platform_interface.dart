import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'fuse_connect_method_channel.dart';

abstract class FuseConnectPlatform extends PlatformInterface {
  /// Constructs a FuseConnectPlatform.
  FuseConnectPlatform() : super(token: _token);

  static final Object _token = Object();

  static FuseConnectPlatform _instance = MethodChannelFuseConnect();

  /// The default instance of [FuseConnectPlatform] to use.
  ///
  /// Defaults to [MethodChannelFuseConnect].
  static FuseConnectPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FuseConnectPlatform] when
  /// they register themselves.
  static set instance(FuseConnectPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
