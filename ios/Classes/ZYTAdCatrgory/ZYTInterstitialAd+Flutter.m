//
//  ZYTInterstitialAd+Flutter.m
//  zyt_mediation
//
//  Created by user on 2020/10/21.
//

#import "ZYTInterstitialAd+Flutter.h"
#import <objc/runtime.h>

@implementation ZYTInterstitialAd (Flutter)
- (void)setChannelId:(NSString *)channelId
{
    objc_setAssociatedObject(self, @selector(channelId), channelId, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSString *)channelId
{
    return objc_getAssociatedObject(self, @selector(channelId));
}

@end
