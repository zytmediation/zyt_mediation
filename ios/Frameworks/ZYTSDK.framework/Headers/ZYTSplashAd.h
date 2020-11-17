//
//  ZYTSplashAd.h
//  DotcAd
//
//  Created by 乔岩 on 2019/6/19.
//  Copyright © 2019 DotC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYTSplashAdDelegate;
@interface ZYTSplashAd : NSObject

@property (nonatomic, readonly, copy) NSString *adUnitId;

@property (nonatomic, assign) BOOL adValid;

@property (nonatomic, weak, nullable) id<ZYTSplashAdDelegate> delegate;

- (instancetype)initWithAdSlotKey:(NSString *)slotKey;

- (void)loadSplashAd;

- (BOOL)showSplashAdUsingKeyWindow:(UIWindow *)keyWindow;

@end

@protocol ZYTSplashAdDelegate <NSObject>

@optional
/**
 This method is called when splash ad loaded successfully.
 */
- (void)splashAdDidLoad:(ZYTSplashAd *)splashAd;

/**
 This method is called when splash ad failed to load.

 */
- (void)splashAd:(ZYTSplashAd *)splashAd didFailWithError:(NSError *)error;

/**
 This method is called when splash ad slot will be showing.
 */
- (void)splashAdWillShow:(ZYTSplashAd *)splashAd;

/**
 This method is called when splash ad is clicked.
 */
- (void)splashAdDidClick:(ZYTSplashAd *)splashAd;

/**
 This method is called when splash ad is closed.
 */
- (void)splashAdDidClose:(ZYTSplashAd *)splashAd;


@end


NS_ASSUME_NONNULL_END
