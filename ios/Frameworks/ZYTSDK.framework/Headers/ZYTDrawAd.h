//
//  ZYTDrawAd.h
//  ZYTAds
//
//  Created by user on 2020/9/21.
//  Copyright © 2020 ZYT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZYTDrawAdView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZYTDrawAdDelegate;
@interface ZYTDrawAd : NSObject

@property (nonatomic, copy, readonly) NSString *adUnitId;

@property (nonatomic, assign, readonly) BOOL adReady;

@property (nonatomic, assign, readonly) BOOL isLoading;

@property (nonatomic, weak) id<ZYTDrawAdDelegate> delegate;

- (instancetype)initWithAdSlotKey:(NSString *)slotKey;

- (void)loadDrawAd:(NSInteger)count;

- (void)registerViewForAdView:(UIView *)adView
               viewController:(UIViewController *)viewController;

@end

@protocol ZYTDrawAdDelegate <NSObject>

/**
 * 拉取draw信息流广告成功
 */
- (void)drawAdSuccessToLoad:(ZYTDrawAd *)drawAd views:(NSArray<__kindof ZYTDrawAdView *> *)views;

/**
 * 拉取draw信息流广告失败
 */
- (void)drawAdFailToLoad:(ZYTDrawAd *)drawAd error:(NSError *)error;

/**
 * draw信息流广告点击回调
 */
- (void)drawAdViewClicked:(ZYTDrawAd *)drawAdView;

/**
* draw信息流详情页 WillPresent 回调
*/
- (void)drawAdViewWillPresentVC:(ZYTDrawAd *)drawAdView;

/**
 * draw信息流详情页 DidDismiss 回调
 */
- (void)drawAdViewDidDismissVC:(ZYTDrawAd *)drawAdView;

@end

NS_ASSUME_NONNULL_END
