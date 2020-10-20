//
//  ZYTRewardedVideoAd+Flutter.m
//  Pods-Runner
//
//  Created by user on 2020/10/20.
//

#import "ZYTRewardedVideoAd+Flutter.h"
#import <objc/runtime.h>
@implementation ZYTRewardedVideoAd (Flutter)


- (void)setChannelId:(NSString *)channelId
{
    objc_setAssociatedObject(self, @selector(channelId), channelId, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSString *)channelId
{
    return objc_getAssociatedObject(self, @selector(channelId));
}

@end
