//
//  InterstitialPlugin.m
//  zyt_mediation
//
//  Created by user on 2020/10/21.
//

#import "InterstitialPlugin.h"
#import "ZytPluginConst.h"
#import "ZYTInterstitialAd+Flutter.h"
@interface InterstitialPlugin()<ZYTInterstitialAdDelegate>

@property (nonatomic, weak) NSObject<FlutterPluginRegistrar> * registrar;

@property (nonatomic, strong) FlutterMethodChannel *channel;

@property (nonatomic, strong) NSMutableDictionary *interAdDic;

@end

@implementation InterstitialPlugin

+(void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar
{
    FlutterMethodChannel* channel = [FlutterMethodChannel methodChannelWithName:[kMediationChannelName stringByAppendingString:kInterPluginChannelName]
                                                                binaryMessenger:[registrar messenger]];
    
    InterstitialPlugin* instance = [[InterstitialPlugin alloc] init];
    instance.channel = channel;
    instance.registrar = registrar;
    [registrar addMethodCallDelegate:instance channel:channel];
}

-(void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result
{
    if ([kInterLoadAd isEqual:call.method]) {
        [self loadInterstitialAd:call];
    } else if ([kRewardAdIsReady isEqual:call.method]) {
        [self isAdReady:call result:result];
    } else if ([kRewardAdShow isEqual:call.method]) {
        [self showInterstitialAd:call result:result];
    }
}

- (void)loadInterstitialAd:(FlutterMethodCall *)call
{
    NSString *adUnitId = call.arguments[@"adUnitId"];
    NSString *channelId = call.arguments[@"channelId"];
    if (adUnitId.length == 0) {
        return;
    }
    
    ZYTInterstitialAd *interAd = self.interAdDic[adUnitId];
    
    // 如果缓存中已经存在广告
    if (interAd) {
        // 广告处于加载状态，不再次加载
        if (interAd.isLoading) {
            return;
        }
        // 广告已经加载过，新建对象加载
        interAd = [[ZYTInterstitialAd alloc] initWithAdSlotKey:adUnitId];
    } else {
    // 缓存中没有广告
        interAd = [[ZYTInterstitialAd alloc] initWithAdSlotKey:adUnitId];
    }
    
    interAd.delegate = self;
    interAd.channelId = channelId;
    [self.interAdDic setValue:interAd
                        forKey:adUnitId];
    
    [interAd loadInterstitalAd];
}

- (void)isAdReady:(FlutterMethodCall *)call result:(FlutterResult)result
{
    NSString *adUnitId = call.arguments[@"adUnitId"];
    ZYTInterstitialAd *videoAd = self.interAdDic[adUnitId];
    result(@(videoAd.adReady));
}

- (void)showInterstitialAd:(FlutterMethodCall *)call result:(FlutterResult)result
{
    NSString *adUnitId = call.arguments[@"adUnitId"];
    NSString *channelId = call.arguments[@"channelId"];
    ZYTInterstitialAd *interAd = self.interAdDic[adUnitId];
    if (!interAd.adReady) {
        return;
    }
//    interAd.channelId = channelId;
    [interAd showAdFromRootViewController:[UIApplication sharedApplication].delegate.window.rootViewController];
}

#pragma mark - getter
-(NSMutableDictionary *)interAdDic
{
    if (!_interAdDic) {
        _interAdDic = [NSMutableDictionary dictionary];
    }
    return _interAdDic;
}

#pragma mark - ZYTInterstitialAdDelegate
-(void)interstitialAdDidLoad:(ZYTInterstitialAd *)interstitialAd
{
    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:[NSString stringWithFormat:@"%@%@%@",kMediationChannelName,kInterPluginChannelName,interstitialAd.channelId]
                                                                binaryMessenger:[self.registrar messenger]];

    [channel invokeMethod:@"onAdLoaded"
                arguments:@{@"adUnitId":interstitialAd.adUnitId}];
}

-(void)interstitialAd:(ZYTInterstitialAd *)interstitialAd failedToLoadWithError:(NSError *)error
{
    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:[NSString stringWithFormat:@"%@%@%@",kMediationChannelName,kInterPluginChannelName,interstitialAd.channelId]
                                                                binaryMessenger:[self.registrar messenger]];

    [channel invokeMethod:@"onError"
                arguments:@{@"adUnitId":interstitialAd.adUnitId,
                            @"errMsg":error.description
                }];
}

-(void)interstitialAdDidOpen:(ZYTInterstitialAd *)interstitialAd{}

-(void)interstitialAdDidClickAd:(ZYTInterstitialAd *)interstitialAd
{
    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:[NSString stringWithFormat:@"%@%@%@",kMediationChannelName,kInterPluginChannelName,interstitialAd.channelId]
                                                                binaryMessenger:[self.registrar messenger]];

    [channel invokeMethod:@"onAdClick"
                arguments:@{@"adUnitId":interstitialAd.adUnitId}];
}

-(void)interstitialAdDidClose:(ZYTInterstitialAd *)interstitialAd
{
    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:[NSString stringWithFormat:@"%@%@%@",kMediationChannelName,kInterPluginChannelName,interstitialAd.channelId]
                                                                binaryMessenger:[self.registrar messenger]];

    [channel invokeMethod:@"onAdClose"
                arguments:@{@"adUnitId":interstitialAd.adUnitId}];
}



@end
