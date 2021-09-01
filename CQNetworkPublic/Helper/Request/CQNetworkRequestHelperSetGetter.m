//
//  CQNetworkRequestHelperSetGetter.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/6/3.
//  Copyright © 2018年 dvlproad. All rights reserved.
//

#import "CQNetworkRequestHelperSetGetter.h"

@implementation CQNetworkRequestHelperSetGetter

#pragma mark - 网络单例请求服务的设置代理
static Class _networkRequestHelper;

+ (void)setNetworkRequestHelper:(Class<CQNetworkRequestCompletionHelperProtocal, CQNetworkRequestSuccessFailureHelperProtocal>)networkRequestHelper
{
    _networkRequestHelper = networkRequestHelper;
}

+ (Class<CQNetworkRequestCompletionHelperProtocal, CQNetworkRequestSuccessFailureHelperProtocal>)networkRequestHelper
{
    return _networkRequestHelper;
}

@end
