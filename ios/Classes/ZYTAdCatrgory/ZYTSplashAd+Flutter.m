//
//  ZYTSplashAd+Flutter.m
//  zyt_mediation
//
//  Created by user on 2020/10/27.
//

#import "ZYTSplashAd+Flutter.h"
#import <objc/runtime.h>

@implementation ZYTSplashAd (Flutter)

- (void)setChannelId:(NSString *)channelId
{
    objc_setAssociatedObject(self, @selector(channelId), channelId, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSString *)channelId
{
    return objc_getAssociatedObject(self, @selector(channelId));
}


@end
