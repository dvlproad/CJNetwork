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

- (nullable NSURLSessionDataTask *)testSimulate_postApiSuffix:(NSString *)apiSuffix
                                                       params:(nullable id)params
                                                 settingModel:(CJRequestSettingModel *)settingModel
                                            shouldRemoveCache:(BOOL)shouldRemoveCache
                                                completeBlock:(void (^)(CJResponseModel *responseModel))completeBlock;

- (nullable NSURLSessionDataTask *)testEncrypt_postApiSuffix:(NSString *)apiSuffix
                                                      params:(nullable id)params
                                               cacheStrategy:(CJNetworkCacheStrategy)cacheStrategy
                                               completeBlock:(void (^)(CJResponseModel *responseModel))completeBlock;

@end
