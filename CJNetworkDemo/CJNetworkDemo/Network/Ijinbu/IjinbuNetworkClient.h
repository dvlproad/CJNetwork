//
//  IjinbuNetworkClient.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2017/3/6.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IjinbuResponseModel.h"

#import "IjinbuSession.h"
#import "IjinbuUser.h"

typedef void ((^ _Nullable HPSuccess)(IjinbuResponseModel * _Nullable responseModel));
typedef void ((^ _Nullable HPFailure)(NSError * _Nullable error));

@interface IjinbuNetworkClient : NSObject

+ (nullable IjinbuNetworkClient *)sharedInstance;

- (nullable NSURLSessionDataTask *)postWithRelativeUrl:(nullable NSString *)RelativeUrl
                                       params:(nullable NSDictionary *)params
                                      success:(HPSuccess)success
                                      failure:(HPFailure)failure;


- (nullable NSString *)signWithParams:(NSDictionary * _Nullable)params path:(NSString * _Nullable)path;

@end
