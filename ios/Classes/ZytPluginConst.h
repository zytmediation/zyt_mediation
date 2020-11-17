//
//  ZytPluginConst.h
//  Pods
//
//  Created by user on 2020/10/17.
//

#ifndef ZytPluginConst_h
#define ZytPluginConst_h

#import <ZYTSDK/ZYTSDK.h>

static const NSString *kMediationChannelName = @"mediation_flutter";
static const NSString *kInitializelName = @"mediation_flutter";

static const NSString *kRewardPluginChannelName = @"/reward";
static const NSString *kRewardLoadAd = @"loadAd";
static const NSString *kRewardAdIsReady = @"isReady";
static const NSString *kRewardAdShow = @"show";

static const NSString *kInterPluginChannelName = @"/interstitial";
static const NSString *kInterLoadAd = @"loadAd";
static const NSString *kInterAdIsReady = @"isReady";
static const NSString *kInterAdShow = @"show";

static const NSString *kBannerViewName = @"bannerView";
static const NSString *kBannerPluginChannelName = @"/banner";
static const NSString *kBannerLoadAd = @"loadAd";

static const NSString *kNativeViewName = @"nativeView";
static const NSString *kNativePluginChannelName = @"/native";

static const NSString *kSplashPluginName = @"/splash";
static const NSString *kSplashLoadAd = @"loadAd";
static const NSString *kSplashShowAd = @"showAd";

static const NSString *kAdUnitId = @"adUnitId";
static const NSString *kAdWidth = @"width";
static const NSString *kAdHeight = @"height";

#endif /* ZytPluginConst_h */
