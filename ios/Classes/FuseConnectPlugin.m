#import "FuseConnectPlugin.h"
#if __has_include(<fuse_connect/fuse_connect-Swift.h>)
#import <fuse_connect/fuse_connect-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "fuse_connect-Swift.h"
#endif

@implementation FuseConnectPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFuseConnectPlugin registerWithRegistrar:registrar];
}
@end
