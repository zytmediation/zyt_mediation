//
//  ZYTSDK.h
//  DotcAd
//
//  Created by user on 2018/7/27.
//  Copyright © 2018年 DotC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZYTInterstitialAd.h"
#import "ZYTBannerAd.h"
#import "ZYTLogLevel.h"
#import "ZYTSplashAd.h"
#import "ZYTNativeAdUnifiedView.h"
#import "ZYTNativeAd.h"
#import "ZYTNativeAdView.h"
#import "ZYTRewardedVideoAd.h"
#import "ZYTDrawAd.h"
#import "ZYTDrawAdView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZYTSDK : NSObject

/**
 初始化SDK
 initialize SDK
 
 */
+ (void)initWithAppID:(nullable NSString *)appID
               pubKey:(nullable NSString *)pubKey
           completion:(void(^)(BOOL success))completion;

/**
 广告SDK初始化结果查询接口
 Check the 'ZYTSDK' has been initialized.

 @return If 'YES',the SDK has been successfully initialized.
 */
+ (BOOL)isAdSDKInitialized;

+ (void)setLogLevel:(ZYTLogLevel)loglevel;

+ (void)sendAfDeepLinkData:(NSDictionary *)data;

+ (void)setGDPRConsentStatus:(BOOL)status;

+ (void)showConsentInfoTips:(nullable void (^)(BOOL consentStatus, NSError *_Nullable error))callback;

+ (void)setCountry:(BOOL)isChina;

@end

NS_ASSUME_NONNULL_END
