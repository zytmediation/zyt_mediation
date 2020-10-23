//
//  PlatformNativeView.h
//  zyt_mediation
//
//  Created by user on 2020/10/23.
//

#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlatformNativeView : NSObject<FlutterPlatformView>

- (instancetype)initWithWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args
                  binaryMessenger:(NSObject<FlutterBinaryMessenger> *)messenger;

@end

NS_ASSUME_NONNULL_END
