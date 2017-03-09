//
//  IJBNetworkClient.h
//  CommonAFNUtilDemo
//
//  Created by 李超前 on 2017/3/6.
//  Copyright © 2017年 ciyouzen. All rights reserved.
//

#import "CJNetworkClient.h"
#import "IjinbuHTTPSessionManager.h"
#import "IjinbuResponseModel.h"

typedef  void ((^HPSuccess)(id responseModel));
typedef  void ((^HPFailure)(NSError *error));

@interface IJBNetworkClient : CJNetworkClient

+ (IJBNetworkClient *)sharedInstance;

- (NSURLSessionDataTask *)postWithPath:(NSString *)Url
                                params:(NSDictionary *)params
                               success:(HPSuccess)success
                               failure:(HPFailure)failure;

@end
