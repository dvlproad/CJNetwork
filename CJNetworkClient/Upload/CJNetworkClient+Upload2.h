//
//  CJNetworkClient+Upload2.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/6/3.
//  Copyright © 2018年 dvlproad. All rights reserved.
//
//  有两个回调，分别为 success + failure

#import "CJNetworkClient.h"
#import <CQNetworkPublic/CQNetworkUploadSuccessFailureClientProtocal.h>

NS_ASSUME_NONNULL_BEGIN

@interface CJNetworkClient (Upload2) <CQNetworkUploadSuccessFailureClientProtocal>


@end

NS_ASSUME_NONNULL_END
