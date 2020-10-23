//
//  PlatformNativeFactory.h
//  zyt_mediation
//
//  Created by user on 2020/10/23.
//

#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlatformNativeFactory : NSObject<FlutterPlatformViewFactory>
@property (nonatomic, strong) NSObject<FlutterBinaryMessenger> *messager;

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messager;
@end

NS_ASSUME_NONNULL_END
