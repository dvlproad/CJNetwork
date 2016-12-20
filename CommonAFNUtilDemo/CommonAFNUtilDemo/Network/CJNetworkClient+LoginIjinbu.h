//
//  CJNetworkClient+LoginIjinbu.h
//  CommonAFNUtilDemo
//
//  Created by dvlproad on 2016/12/20.
//  Copyright © 2016年 ciyouzen. All rights reserved.
//

#import "CJNetworkClient.h"
#import "IjinbuHTTPSessionManager.h"

@interface CJNetworkClient (LoginIjinbu)

//ijinbu
+ (void)requestijinbuLogin_name:(NSString *)name
                           pasd:(NSString*)pasd
                        success:(CJRequestSuccess)success
                        failure:(CJRequestFailure)failure;

@end
