//
//  RewardPlugin.m
//  zyt_mediation
//
//  Created by user on 2020/10/17.
//

#import "RewardPlugin.h"
#import "ZytPluginConst.h"
#import "ZYTRewardedVideoAd+Flutter.h"

@interface RewardPlugin()<ZYTRewardedVideoAdDelegate>

@property (nonatomic, weak) NSObject<FlutterPluginRegistrar> * registrar;

@property (nonatomic, strong) FlutterMethodChannel *channel;

@property (nonatomic, strong) ZYTRewardedVideoAd *rewardVideoAd;

@property (nonatomic, strong) NSMutableDictionary *rewardAdDic;

@end

@implementation RewardPlugin

+(void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar
{
    FlutterMethodChannel* channel = [FlutterMethodChannel methodChannelWithName:[kMediationChannelName stringByAppendingString:kRewardPluginChannelName]
                                                                binaryMessenger:[registrar messenger]];
    
    RewardPlugin* instance = [[RewardPlugin alloc] init];
    instance.channel = channel;
    instance.registrar = registrar;
    [registrar addMethodCallDelegate:instance channel:channel];

}

-(void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result
{
    if ([kRewardLoadAd isEqual:call.method]) {
        [self loadRewardAd:call];
    }
}

- (void)loadRewardAd:(FlutterMethodCall *)call
{
    NSString *adUnitId = call.arguments[@"adUnitId"];
    NSString *channelId = call.arguments[@"channelId"];
    
    if (adUnitId.length == 0) {
        return;
    }
    
    ZYTRewardedVideoAd *videoAd = self.rewardAdDic[adUnitId];
    
    // 如果缓存中已经存在广告
    if (videoAd && [videoAd.channelId isEqualToString:channelId]) {
        
        // 广告处于加载状态，不再次加载
        if (videoAd.isAdLoading) {
            return;
        }
        
        // 广告已经加载过，新建对象加载
        videoAd = [[ZYTRewardedVideoAd alloc] initWithAdSlotKey:adUnitId];
    } else {
    // 缓存中没有广告
        videoAd = [[ZYTRewardedVideoAd alloc] initWithAdSlotKey:adUnitId];
    }
    
    videoAd.delegate = self;
    videoAd.channelId = channelId;
    [videoAd loadAd];
}

#pragma mark - ZYTRewardedVideoAdDelegate
-(void)rewardedVideoAdDidLoad:(ZYTRewardedVideoAd *)rewardedVideoAd
{
    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:[kRewardPluginChannelName stringByAppendingString:rewardedVideoAd.channelId]
                                                                binaryMessenger:[self.registrar messenger]];
    
    [channel invokeMethod:@"onLoaded"
                arguments:@{@"adUnitId":rewardedVideoAd.adUnitId}];
}

-(void)rewardedVideoAd:(ZYTRewardedVideoAd *)rewardedVideoAd failToLoadWithError:(NSError *)error
{
    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:[kRewardPluginChannelName stringByAppendingString:rewardedVideoAd.channelId]
                                                                binaryMessenger:[self.registrar messenger]];
    
    [channel invokeMethod:@"onLoaded"
                arguments:@{@"adUnitId":rewardedVideoAd.adUnitId,
                            @"errMsg":error.description}];
}

- (void)rewardedVideoAdDidClick:(ZYTRewardedVideoAd *)rewardedVideoAd
{
    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:[kRewardPluginChannelName stringByAppendingString:rewardedVideoAd.channelId]
                                                                binaryMessenger:[self.registrar messenger]];
    
    [channel invokeMethod:@"onAdClick"
                arguments:@{@"adUnitId":rewardedVideoAd.adUnitId}];
}

-(void)rewardedVideoAdDidShow:(ZYTRewardedVideoAd *)rewardedVideoAd
{
    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:[kRewardPluginChannelName stringByAppendingString:rewardedVideoAd.channelId]
                                                                binaryMessenger:[self.registrar messenger]];
    
    [channel invokeMethod:@"onAdShow"
                arguments:@{@"adUnitId":rewardedVideoAd.adUnitId}];
}
-(void)rewardedVideoAdDidClose:(ZYTRewardedVideoAd *)rewardedVideoAd withReward:(BOOL)shouldReward
{
    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:[kRewardPluginChannelName stringByAppendingString:rewardedVideoAd.channelId]
                                                                binaryMessenger:[self.registrar messenger]];
    
    [channel invokeMethod:@"onAdShow"
                arguments:@{@"adUnitId":rewardedVideoAd.adUnitId}];
}

@end

