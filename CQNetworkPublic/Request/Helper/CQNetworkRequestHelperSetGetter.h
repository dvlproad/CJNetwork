//
//  CQNetworkRequestHelperSetGetter.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/6/3.
//  Copyright © 2018年 dvlproad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CQNetworkRequestCompletionHelperProtocal.h"
#import "CQNetworkRequestSuccessFailureHelperProtocal.h"

NS_ASSUME_NONNULL_BEGIN

@interface CQNetworkRequestHelperSetGetter : NSObject

+ (void)setNetworkRequestHelper:(id<CQNetworkRequestCompletionHelperProtocal, CQNetworkRequestSuccessFailureHelperProtocal>)networkRequestHelper;

+ (id<CQNetworkRequestCompletionHelperProtocal, CQNetworkRequestSuccessFailureHelperProtocal>)networkRequestHelper;

@end

NS_ASSUME_NONNULL_END
