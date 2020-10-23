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
        
        FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:
                                         [kMediationChannelName stringByAppendingFormat:@"%@%d",kNativeViewName,viewId]
                                                                    binaryMessenger:messenger];
        
        NSString *adUnitId = self.args[kAdUnitId];
        
        self.nativeAd = [[ZYTNativeAd alloc] initWithSlotKey:adUnitId size:CGSizeZero];
        self.nativeAd.delegate = self;
        [self.nativeAd loadNativeAd:1];
        
        self.channel = channel;
    }
    return self;
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


#pragma mark - ZYTNativeAdDelegate
-(void)nativeExpressAdSuccessToLoad:(ZYTNativeAd *)nativeExpressAd
                              views:(NSArray<__kindof ZYTNativeAdView *> *)views
{
    ZYTNativeAdView *adView = views[0];
    adView.controller = [UIApplication sharedApplication].delegate.window.rootViewController;
    [self.containerView addSubview:adView];
}

-(void)nativeExpressAdFailToLoad:(ZYTNativeAd *)nativeExpressAd
                           error:(NSError *)error
{
    
}

@end
