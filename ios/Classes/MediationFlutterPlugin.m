#import "MediationFlutterPlugin.h"
#import <ZYTSDK/ZYTSDK.h>

@implementation MediationFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"mediation_flutter"
            binaryMessenger:[registrar messenger]];
  MediationFlutterPlugin* instance = [[MediationFlutterPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {

  if ([@"initialize" isEqualToString:call.method]) {

//      self zytMediationInitialize:call.arguments pubkey:<#(NSString *)#> flutterResult:<#^(id  _Nullable result)result#>
      NSLog(@"%@",call);

  } else {
    result(FlutterMethodNotImplemented);
  }
}


- (void)zytMediationInitialize:(NSString *)appid
                        pubkey:(NSString *)pubKey
                 flutterResult:(FlutterResult)result
{
    
}

@end
