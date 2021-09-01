//
//  CQNetworkUploadHelperSetGetter.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/6/3.
//  Copyright © 2018年 dvlproad. All rights reserved.
//

#import "CQNetworkUploadHelperSetGetter.h"

@implementation CQNetworkUploadHelperSetGetter

#pragma mark - 网络单例请求服务的设置代理
static Class _networkUploadHelper;

+ (void)setNetworkUploadHelper:(Class<CQNetworkUploadCompletionHelperProtocal, CQNetworkUploadSuccessFailureHelperProtocal>)networkUploadHelper
{
    _networkUploadHelper = networkUploadHelper;
}


+ (Class<CQNetworkUploadCompletionHelperProtocal, CQNetworkUploadSuccessFailureHelperProtocal>)networkUploadHelper
{
    return _networkUploadHelper;
}

@end
