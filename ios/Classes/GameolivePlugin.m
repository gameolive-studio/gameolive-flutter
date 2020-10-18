#import "GameolivePlugin.h"
#if __has_include(<gameolive/gameolive-Swift.h>)
#import <gameolive/gameolive-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "gameolive-Swift.h"
#endif

@implementation GameolivePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftGameolivePlugin registerWithRegistrar:registrar];
}
@end
