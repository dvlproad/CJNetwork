//
//  CQNetworkRequestClientSetGetter.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/6/3.
//  Copyright © 2018年 dvlproad. All rights reserved.
//

#import "CQNetworkRequestClientSetGetter.h"

@implementation CQNetworkRequestClientSetGetter

#pragma mark - 网络单例请求服务的设置代理
static id _networkRequestClient;

+ (void)setNetworkRequestClient:(id<CJNetworkRequestOriginCallbackProtocal, CJNetworkRequestResponseCallbackProtocal>)networkRequestClient
{
    _networkRequestClient = networkRequestClient;
}

+ (id<CJNetworkRequestOriginCallbackProtocal, CJNetworkRequestResponseCallbackProtocal>)networkRequestClient
{
    return _networkRequestClient;
}

@end
