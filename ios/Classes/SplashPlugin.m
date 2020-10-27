//
//  SplashPlugin.m
//  zyt_mediation
//
//  Created by user on 2020/10/27.
//

#import "SplashPlugin.h"
#import "ZytPluginConst.h"
#import "ZYTSplashAd+Flutter.h"

@interface SplashPlugin()<ZYTSplashAdDelegate>

@property (nonatomic, weak) NSObject<FlutterPluginRegistrar> * registrar;

@property (nonatomic, strong) FlutterMethodChannel *channel;

@property (nonatomic, strong) ZYTSplashAd *splashAd;

@end

@implementation SplashPlugin

+(void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar
{
    FlutterMethodChannel* channel = [FlutterMethodChannel methodChannelWithName:[kMediationChannelName stringByAppendingString:kSplashPluginName]
                                                                binaryMessenger:[registrar messenger]];
    
    SplashPlugin* instance = [[SplashPlugin alloc] init];
    instance.channel = channel;
    instance.registrar = registrar;
    [registrar addMethodCallDelegate:instance channel:channel];
}

-(void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result
{
    if ([kSplashLoadAndShowAd isEqual:call.method]) {
        [self showSplashAdView:call];
    }
}

- (void)showSplashAdView:(FlutterMethodCall *)call
{
    NSString *adUnitId = call.arguments[@"adUnitId"];
    NSString *channelId = call.arguments[@"channelId"];
    
    if (adUnitId.length == 0) {
        return;
    }
    
    self.splashAd = [[ZYTSplashAd alloc] initWithAdSlotKey:adUnitId];
    self.splashAd.delegate = self;
    self.splashAd.channelId = channelId;
    [self.splashAd loadAdAndShowInWindow:[UIApplication sharedApplication].delegate.window];
}

#pragma mark - ZYTSplashAdDelegate
-(void)splashAdDidLoad:(ZYTSplashAd *)splashAd
{
    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:[NSString stringWithFormat:@"%@%@%@",kMediationChannelName,kSplashPluginName,splashAd.channelId]
                                                                binaryMessenger:[self.registrar messenger]];

    [channel invokeMethod:@"onAdLoaded"
                arguments:@{@"adUnitId":splashAd.adUnitId}];
}

-(void)splashAd:(ZYTSplashAd *)splashAd didFailWithError:(NSError *)error
{
    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:[NSString stringWithFormat:@"%@%@%@",kMediationChannelName,kSplashPluginName,splashAd.channelId]
                                                                binaryMessenger:[self.registrar messenger]];

    [channel invokeMethod:@"onError"
                arguments:@{@"adUnitId":splashAd.adUnitId,
                            @"errMsg":error.description}];
}

-(void)splashAdDidClick:(ZYTSplashAd *)splashAd
{
    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:[NSString stringWithFormat:@"%@%@%@",kMediationChannelName,kSplashPluginName,splashAd.channelId]
                                                                binaryMessenger:[self.registrar messenger]];

    [channel invokeMethod:@"onAdClick"
                arguments:@{@"adUnitId":splashAd.adUnitId}];
}

-(void)splashAdDidClose:(ZYTSplashAd *)splashAd
{
    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:[NSString stringWithFormat:@"%@%@%@",kMediationChannelName,kSplashPluginName,splashAd.channelId]
                                                                binaryMessenger:[self.registrar messenger]];

    [channel invokeMethod:@"onAdClose"
                arguments:@{@"adUnitId":splashAd.adUnitId}];
}

-(void)splashAdWillShow:(ZYTSplashAd *)splashAd
{
    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:[NSString stringWithFormat:@"%@%@%@",kMediationChannelName,kSplashPluginName,splashAd.channelId]
                                                                binaryMessenger:[self.registrar messenger]];

    [channel invokeMethod:@"onAdShow"
                arguments:@{@"adUnitId":splashAd.adUnitId}];
}

@end
