//
//  CQNetworkUploadClientSetGetter.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/6/3.
//  Copyright © 2018年 dvlproad. All rights reserved.
//

#import "CQNetworkUploadClientSetGetter.h"

@implementation CQNetworkUploadClientSetGetter

#pragma mark - 网络单例请求服务的设置代理
static Class _networkUploadClient;

+ (void)setNetworkUploadClient:(Class<CQNetworkUploadCompletionClientProtocal, CQNetworkUploadSuccessFailureClientProtocal>)networkUploadClient
{
    _networkUploadClient = networkUploadClient;
}

+ (Class<CQNetworkUploadCompletionClientProtocal, CQNetworkUploadSuccessFailureClientProtocal>)networkUploadClient
{
    return _networkUploadClient;
}

@end
