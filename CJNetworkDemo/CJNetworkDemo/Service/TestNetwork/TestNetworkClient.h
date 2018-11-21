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

- (nullable NSURLSessionDataTask *)testSimulate_postApiSuffix:(NSString *)apiSuffix
                                                       params:(nullable id)params
                                                 settingModel:(CJRequestSettingModel *)settingModel
                                            shouldRemoveCache:(BOOL)shouldRemoveCache
                                                      success:(void (^)(CJResponseModel *responseModel))success
                                                      failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure;

- (nullable NSURLSessionDataTask *)testEncrypt_postApiSuffix:(NSString *)apiSuffix
                                                      params:(nullable id)params
                                               cacheStrategy:(CJRequestCacheStrategy)cacheStrategy
                                               completeBlock:(void (^)(CJResponseModel *responseModel))completeBlock;

@end
