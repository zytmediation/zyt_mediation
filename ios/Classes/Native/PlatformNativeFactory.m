//
//  PlatformNativeFactory.m
//  zyt_mediation
//
//  Created by user on 2020/10/23.
//

#import "PlatformNativeFactory.h"
#import "PlatformNativeView.h"

@implementation PlatformNativeFactory
-(instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger> *)messager
{
    self = [super init];
    
    if (self) {
        self.messager = messager;
    }
    return self;
}

-(NSObject<FlutterMessageCodec> *)createArgsCodec
{
    return [FlutterStandardMessageCodec sharedInstance];
}


- (nonnull NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id _Nullable)args {
    PlatformNativeView *nativeView = [[PlatformNativeView alloc] initWithWithFrame:frame
                                                                    viewIdentifier:viewId
                                                                         arguments:args
                                                                   binaryMessenger:self.messager];
    return nativeView;
}

@end
