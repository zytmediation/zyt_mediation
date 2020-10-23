//
//  PlatformBannerFactory.h
//  zyt_mediation
//
//  Created by user on 2020/10/22.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlatformBannerFactory : NSObject<FlutterPlatformViewFactory>

@property (nonatomic, strong) NSObject<FlutterBinaryMessenger> *messager;

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messager;

@end

NS_ASSUME_NONNULL_END
