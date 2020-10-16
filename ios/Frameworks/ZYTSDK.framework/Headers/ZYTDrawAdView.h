//
//  ZYTDrawAdView.h
//  ZYTAds
//
//  Created by user on 2020/9/22.
//  Copyright © 2020 ZYT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZYTDrawAd;
@interface ZYTDrawAdView : UIView

@property (nonatomic, weak) UIViewController *controller;

/// 原生自渲染广告需要将视图放置本容器
- (void)registerViewForNativeAd:(ZYTDrawAd *)drawAd
                  containerView:(UIView *)containerView
                 viewController:(UIViewController *)controller;

@end

NS_ASSUME_NONNULL_END
