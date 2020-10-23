//
//  PlatformBannerView.m
//  zyt_mediation
//
//  Created by user on 2020/10/22.
//

#import "PlatformBannerView.h"
#import "ZytPluginConst.h"
@interface PlatformBannerView()<ZYTBannerAdDelegate>

@property (nonatomic, assign) CGRect frame;
@property (nonatomic, strong) NSString *viewId;
@property (nonatomic, strong) NSDictionary *args;
@property (nonatomic, strong) FlutterMethodChannel *channel;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, weak) NSObject<FlutterBinaryMessenger> *messenger;

@property (nonatomic, strong) ZYTBannerAd *bannerAd;

@end

@implementation PlatformBannerView

-(instancetype)initWithWithFrame:(CGRect)frame
                  viewIdentifier:(int64_t)viewId
                       arguments:(id)args
                 binaryMessenger:(NSObject<FlutterBinaryMessenger> *)messenger
{
    self = [super init];
    if (self) {
        self.frame = frame;
        self.viewId = @(viewId).stringValue;
        self.args = (NSDictionary *)args;
        self.messenger = messenger;
        
        FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:[kMediationChannelName stringByAppendingFormat:@"%@%d",kRewardPluginChannelName,viewId]
                                                                    binaryMessenger:messenger];
        
        NSString *adUnitId = self.args[kAdUnitId];
        self.bannerAd = [[ZYTBannerAd alloc] initWithSlotKey:adUnitId
                                          rootViewController:[UIApplication sharedApplication].delegate.window.rootViewController
                                                    delegate:self];
        [self.bannerAd showBanner];
        
        self.channel = channel;
    }
    return self;
}


#pragma mark - ZYTBannerAdDelegate
-(void)bannerAdLoadSuccess
{
    self.bannerAd.bannerView.frame = self.containerView.bounds;
    [self.containerView addSubview:self.bannerAd.bannerView];
    
    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:[NSString stringWithFormat:@"%@%@/%@",kMediationChannelName,kBannerPluginChannelName,self.viewId]
                                                                binaryMessenger:self.messenger];
    
    [channel invokeMethod:@"onAdLoaded"
                arguments:@{@"adUnitId":self.bannerAd.unitId,
                }];
}

-(void)bannerAdDidClicked
{
    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:[NSString stringWithFormat:@"%@%@/%@",kMediationChannelName,kBannerPluginChannelName,self.viewId]
                                                                binaryMessenger:self.messenger];
    
    [channel invokeMethod:@"onAdClick"
                arguments:@{@"adUnitId":self.bannerAd.unitId,
                }];
}

-(void)bannerAdDidClosed
{
    
}

-(void)bannerAdShowError:(NSError *)error
{
    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:[NSString stringWithFormat:@"%@%@/%@",kMediationChannelName,kBannerPluginChannelName,self.viewId]
                                                                binaryMessenger:self.messenger];
    
    [channel invokeMethod:@"onAdClose"
                arguments:@{@"adUnitId":self.bannerAd.unitId,
                            @"errMsg":error.description}];
}


- (UIView*)view
{
    return self.containerView;
}


-(UIView *)containerView
{
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor redColor];
    }
    return _containerView;
}

@end
