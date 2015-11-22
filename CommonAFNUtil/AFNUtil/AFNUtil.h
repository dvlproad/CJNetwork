//
//  AFNUtil.h
//  CommonAFNUtilDemo
//
//  Created by lichq on 6/25/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface AFNUtil : NSObject

+ (AFHTTPRequestOperation *)useManager:(AFHTTPRequestOperationManager *)manager
                        postRequestUrl:(NSString *)Url
                                params:(NSDictionary *)params
                               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                               failure:(void (^)(AFHTTPRequestOperation *operation, NSString *failMesg))failure;

@end
