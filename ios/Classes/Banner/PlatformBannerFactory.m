//
//  PlatformBannerFactory.m
//  zyt_mediation
//
//  Created by user on 2020/10/22.
//

#import "PlatformBannerFactory.h"
#import "PlatformBannerView.h"
@implementation PlatformBannerFactory

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
    PlatformBannerView *bannerView = [[PlatformBannerView alloc] initWithWithFrame:frame
                                                                    viewIdentifier:viewId
                                                                         arguments:args
                                                                   binaryMessenger:self.messager];
    return bannerView;
}

@end
