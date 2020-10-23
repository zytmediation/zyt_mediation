//
//  PlatformBannerView.h
//  zyt_mediation
//
//  Created by user on 2020/10/22.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlatformBannerView : NSObject<FlutterPlatformView>

- (instancetype)initWithWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args binaryMessenger:(NSObject<FlutterBinaryMessenger> *)messenger;

@end


NS_ASSUME_NONNULL_END
