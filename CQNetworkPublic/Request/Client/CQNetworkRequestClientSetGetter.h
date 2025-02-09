//
//  CQNetworkRequestClientSetGetter.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/6/3.
//  Copyright © 2018年 dvlproad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CJNetworkRequestOriginCallbackProtocal.h"
#import "CJNetworkRequestResponseCallbackProtocal.h"

NS_ASSUME_NONNULL_BEGIN

@interface CQNetworkRequestClientSetGetter : NSObject

+ (void)setNetworkRequestClient:(id<CJNetworkRequestOriginCallbackProtocal, CJNetworkRequestResponseCallbackProtocal>)networkRequestClient;

+ (id<CJNetworkRequestOriginCallbackProtocal, CJNetworkRequestResponseCallbackProtocal>)networkRequestClient;

@end

NS_ASSUME_NONNULL_END
