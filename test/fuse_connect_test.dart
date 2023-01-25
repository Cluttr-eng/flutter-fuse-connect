import 'package:flutter_test/flutter_test.dart';
import 'package:fuse_connect/fuse_connect.dart';
import 'package:fuse_connect/fuse_connect_platform_interface.dart';
import 'package:fuse_connect/fuse_connect_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFuseConnectPlatform
    with MockPlatformInterfaceMixin
    implements FuseConnectPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FuseConnectPlatform initialPlatform = FuseConnectPlatform.instance;

  test('$MethodChannelFuseConnect is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFuseConnect>());
  });

  test('getPlatformVersion', () async {
    FuseConnect fuseConnectPlugin = FuseConnect();
    MockFuseConnectPlatform fakePlatform = MockFuseConnectPlatform();
    FuseConnectPlatform.instance = fakePlatform;

    expect(await fuseConnectPlugin.getPlatformVersion(), '42');
  });
}
