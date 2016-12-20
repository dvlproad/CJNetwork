//
//  CJNetworkClient+Test.h
//  CommonAFNUtilDemo
//
//  Created by dvlproad on 2016/12/20.
//  Copyright © 2016年 ciyouzen. All rights reserved.
//

#import "CJNetworkClient.h"
#import "TestHTTPSessionManager.h"

@interface CJNetworkClient (Test)

+ (void)requestBaiduHomeSuccess:(CJRequestSuccess)success
                        failure:(CJRequestFailure)failure;

@end
