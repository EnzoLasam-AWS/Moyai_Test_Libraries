//
//  Generated file. Do not edit.
//

// clang-format off

#import "GeneratedPluginRegistrant.h"

#if __has_include(<beacon_broadcast/BeaconBroadcastPlugin.h>)
#import <beacon_broadcast/BeaconBroadcastPlugin.h>
#else
@import beacon_broadcast;
#endif

#if __has_include(<flutter_udid/FlutterUdidPlugin.h>)
#import <flutter_udid/FlutterUdidPlugin.h>
#else
@import flutter_udid;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [BeaconBroadcastPlugin registerWithRegistrar:[registry registrarForPlugin:@"BeaconBroadcastPlugin"]];
  [FlutterUdidPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterUdidPlugin"]];
}

@end
