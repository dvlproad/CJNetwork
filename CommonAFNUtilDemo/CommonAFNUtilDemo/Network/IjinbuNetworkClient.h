//
//  IjinbuNetworkClient.h
//  CommonAFNUtilDemo
//
//  Created by dvlproad on 2017/3/6.
//  Copyright © 2017年 ciyouzen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager+CJCategory.h"

#import "IjinbuResponseModel.h"

typedef  void ((^HPSuccess)(id responseModel));
typedef  void ((^HPFailure)(NSError *error));

@interface IjinbuNetworkClient : NSObject

+ (IjinbuNetworkClient *)sharedInstance;

- (NSURLSessionDataTask *)postWithPath:(NSString *)Url
                                params:(NSDictionary *)params
                               success:(HPSuccess)success
                               failure:(HPFailure)failure;

@end
