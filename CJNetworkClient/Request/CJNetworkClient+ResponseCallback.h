//
//  CJNetworkClient+ResponseCallback.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/6/3.
//  Copyright © 2018年 dvlproad. All rights reserved.
//
//  回调值为responseModel：有两个回调，分别为 success + failure

#import "CJNetworkClient.h"
#import <CQNetworkPublic/CJNetworkRequestResponseCallbackProtocal.h>
#import "CJRequestBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CJNetworkClient (ResponseCallback) <CJNetworkRequestResponseCallbackProtocal>


@end

NS_ASSUME_NONNULL_END
