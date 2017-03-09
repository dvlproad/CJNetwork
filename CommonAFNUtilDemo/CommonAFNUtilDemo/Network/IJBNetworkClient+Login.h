//
//  IJBNetworkClient+Login.h
//  CommonAFNUtilDemo
//
//  Created by 李超前 on 2017/3/6.
//  Copyright © 2017年 ciyouzen. All rights reserved.
//

#import "IJBNetworkClient.h"

@interface IJBNetworkClient (Login)

- (NSURLSessionDataTask *)requestijinbuLogin_name:(NSString *)name
                                             pasd:(NSString*)pasd
                                          success:(HPSuccess)success
                                          failure:(HPFailure)failure;

@end
