//
//  NativePlugin.m
//  zyt_mediation
//
//  Created by user on 2020/10/23.
//

#import "NativePlugin.h"
#import "PlatformNativeFactory.h"
#import "ZytPluginConst.h"
@implementation NativePlugin

+(void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar
{
    [registrar registerViewFactory:[[PlatformNativeFactory alloc] initWithMessenger:[registrar messenger]]
                            withId:kNativeViewName];
}

@end
