#import "MediationFlutterPlugin.h"
#import <ZYTSDK/ZYTSDK.h>
#import "zyt_mediation.h"
@interface MediationFlutterPlugin()

@property (nonatomic, strong) FlutterMethodChannel *channel;

@end


@implementation MediationFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"mediation_flutter"
            binaryMessenger:[registrar messenger]];
    MediationFlutterPlugin* instance = [[MediationFlutterPlugin alloc] init];
    instance.channel = channel;
    [registrar addMethodCallDelegate:instance channel:channel];
    
    [self registerAdPlugins:registrar];
}

+ (void)registerAdPlugins:(NSObject<FlutterPluginRegistrar>*)registrar
{
    [RewardPlugin registerWithRegistrar:registrar];
    [InterstitialPlugin registerWithRegistrar:registrar];
    [BannerPlugin registerWithRegistrar:registrar];
    [NativePlugin registerWithRegistrar:registrar];
    [SplashPlugin registerWithRegistrar:registrar];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {

  if ([@"initialize" isEqualToString:call.method]) {

      [self zytMediationInitialize:call.arguments[@"appId"]
                            pubkey:call.arguments[@"pubKey"]
                     flutterResult:result];

  } else {
    result(FlutterMethodNotImplemented);
  }
}


- (void)zytMediationInitialize:(NSString *)appid
                        pubkey:(NSString *)pubKey
                 flutterResult:(FlutterResult)result
{
    [ZYTSDK initWithAppID:appid pubKey:pubKey completion:^(BOOL success) {
       
        
        if (success) {
            [self.channel invokeMethod:@"initSuccess" arguments:nil];
        } else {
            [self.channel invokeMethod:@"initFailure" arguments:nil];
        }
        
    }];
}

@end
