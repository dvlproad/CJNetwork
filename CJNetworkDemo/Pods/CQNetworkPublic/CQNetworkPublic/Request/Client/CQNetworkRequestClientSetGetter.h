//
//  CQNetworkRequestClientSetGetter.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/6/3.
//  Copyright © 2018年 dvlproad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CQNetworkRequestCompletionClientProtocal.h"
#import "CQNetworkRequestSuccessFailureClientProtocal.h"

NS_ASSUME_NONNULL_BEGIN

@interface CQNetworkRequestClientSetGetter : NSObject

+ (void)setNetworkRequestClient:(id<CQNetworkRequestCompletionClientProtocal, CQNetworkRequestSuccessFailureClientProtocal>)networkRequestClient;

+ (id<CQNetworkRequestCompletionClientProtocal, CQNetworkRequestSuccessFailureClientProtocal>)networkRequestClient;

@end

NS_ASSUME_NONNULL_END
