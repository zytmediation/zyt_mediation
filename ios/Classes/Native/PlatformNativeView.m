//
//  PlatformNativeView.m
//  zyt_mediation
//
//  Created by user on 2020/10/23.
//

#import "PlatformNativeView.h"
#import <ZYTSDK/ZYTSDK.h>
#import "ZytPluginConst.h"
@interface PlatformNativeView()<ZYTNativeAdDelegate>

@property (nonatomic, assign) CGRect frame;
@property (nonatomic, strong) NSString *viewId;
@property (nonatomic, strong) NSDictionary *args;
@property (nonatomic, strong) FlutterMethodChannel *channel;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, weak) NSObject<FlutterBinaryMessenger> *messenger;

@property (nonatomic, strong) ZYTNativeAd *nativeAd;

@end

@implementation PlatformNativeView

- (void)dealloc
{
    NSLog(@"Native Dealloc");
}

-(instancetype)initWithWithFrame:(CGRect)frame
                  viewIdentifier:(int64_t)viewId
                       arguments:(id)args
                 binaryMessenger:(NSObject<FlutterBinaryMessenger> *)messenger
{
    self = [super init];
    if (self) {
        
        self.viewId = @(viewId).stringValue;
        self.args = (NSDictionary *)args;
        self.messenger = messenger;
        
        NSString *adUnitId = self.args[kAdUnitId];
        NSNumber *height = self.args[kAdHeight];
        NSNumber *width = self.args[kAdWidth];
        
        self.nativeAd = [[ZYTNativeAd alloc] initWithSlotKey:adUnitId size:CGSizeMake(width.doubleValue,height.doubleValue)];
        self.nativeAd.delegate = self;
        [self.nativeAd loadNativeAd:1];
    }
    return self;
}

- (UIView *)view
{
    return self.containerView;
}


-(UIView *)containerView
{
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
    }
    return _containerView;
}


#pragma mark - ZYTNativeAdDelegate
-(void)nativeExpressAdSuccessToLoad:(ZYTNativeAd *)nativeExpressAd
                              views:(NSArray<__kindof ZYTNativeAdView *> *)views
{
    UIViewController *rootVC = [UIApplication sharedApplication].delegate.window.rootViewController;
    ZYTNativeAdView *adView = views[0];
    
    NSNumber *height = self.args[kAdHeight];
    NSNumber *width = self.args[kAdWidth];
    
    adView.frame = CGRectMake(0, 0, width.doubleValue, height.doubleValue);
    adView.controller = rootVC;
    [self.containerView addSubview:adView];
    
    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:[NSString stringWithFormat:@"%@%@/%@",kMediationChannelName,kNativePluginChannelName,self.viewId]
                                                                binaryMessenger:self.messenger];
    
    [channel invokeMethod:@"onAdLoaded"
                arguments:@{@"adUnitId":nativeExpressAd.adUnitId,}
     ];
    
    [adView registerViewForNativeAd:nativeExpressAd
                           nativeMaterial:nil
                           viewController:rootVC
                           clickableViews:nil];
}

-(void)nativeExpressAdFailToLoad:(ZYTNativeAd *)nativeExpressAd
                           error:(NSError *)error
{
    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:[NSString stringWithFormat:@"%@%@/%@",kMediationChannelName,kNativePluginChannelName,self.viewId]
                                                                binaryMessenger:self.messenger];
    
    [channel invokeMethod:@"onError"
                arguments:@{@"adUnitId":nativeExpressAd.adUnitId,
                            @"errMsg":error.description ? error.description : @"no fill"}
     ];
}

-(void)nativeExpressAdViewClicked:(ZYTNativeAd *)nativeExpressAdView
{
    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:[NSString stringWithFormat:@"%@%@/%@",kMediationChannelName,kNativePluginChannelName,self.viewId]
                                                                binaryMessenger:self.messenger];
    
    [channel invokeMethod:@"onAdClick"
                arguments:@{@"adUnitId":nativeExpressAdView.adUnitId}
     ];
}

@end
