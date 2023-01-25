import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fuse_connect/fuse_connect_method_channel.dart';

void main() {
  MethodChannelFuseConnect platform = MethodChannelFuseConnect();
  const MethodChannel channel = MethodChannel('fuse_connect');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
