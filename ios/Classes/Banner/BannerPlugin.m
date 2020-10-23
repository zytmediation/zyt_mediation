//
//  BannerPlugin.m
//  zyt_mediation
//
//  Created by user on 2020/10/22.
//

#import "BannerPlugin.h"
#import "PlatformBannerView.h"
#import "PlatformBannerFactory.h"
#import "zyt_mediation.h"
#import "ZytPluginConst.h"
@interface BannerPlugin()

@end

@implementation BannerPlugin

+(void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar
{
    [registrar registerViewFactory:[[PlatformBannerFactory alloc]initWithMessenger:[registrar messenger]]
                            withId:kBannerViewName];
}


@end
