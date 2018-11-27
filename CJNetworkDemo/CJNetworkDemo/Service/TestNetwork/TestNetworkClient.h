//
//  TestNetworkClient.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2016/12/20.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CJNetworkClient.h"
#import "AFHTTPSessionManager+CJSerializerEncrypt.h"
#import "AFHTTPSessionManager+CJMethodEncrypt.h"
#import "CJResponseModel.h"

@interface TestNetworkClient : CJNetworkClient

+ (TestNetworkClient *)sharedInstance;

- (NSURLSessionDataTask *)testSimulate_postApi:(NSString *)apiSuffix
                                        params:(nullable id)params
                                  settingModel:(CJRequestSettingModel *)settingModel
                                       success:(void (^)(CJResponseModel *responseModel))success
                                       failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure;

- (NSURLSessionDataTask *)testLocal_postApi:(NSString *)apiSuffix
                                     params:(id)params
                               settingModel:(CJRequestSettingModel *)settingModel
                                    success:(void (^)(CJResponseModel *responseModel))success
                                    failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure;

@end
