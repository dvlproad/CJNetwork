//
//  AFHTTPSessionManager+CJReponseOrError.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2017/6/13.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "CJRequestSettingModel.h"
#import "CJNetworkInfoModel.h"
#import "CJRequestCacheDataUtil.h"

@interface AFHTTPSessionManager (CJReponseOrError)

///请求得到数据时候执行的方法(responseObject必须是解密后的数据)
- (void)__didRequestSuccessForTask:(NSURLSessionDataTask * _Nonnull)task
                withResponseObject:(nullable id)responseObject
                       isCacheData:(BOOL)isCacheData
                            forUrl:(nullable NSString *)Url
                            params:(nullable id)params
                      settingModel:(CJRequestSettingModel *)settingModel
                           success:(nullable void (^)(CJSuccessNetworkInfo * _Nullable successNetworkInfo))success;

///请求不到数据时候（无网 或者 有网但服务器异常等无数据时候）执行的方法
- (void)__didCacheRequestFailureForTask:(NSURLSessionDataTask * _Nonnull)task
                      withResponseError:(NSError * _Nullable)error
                                 forUrl:(nullable NSString *)Url
                                 params:(nullable id)params
                           settingModel:(CJRequestSettingModel *)settingModel
                                failure:(nullable void (^)(CJFailureNetworkInfo * _Nullable failureNetworkInfo))failure
                        getCacheSuccess:(nullable void (^)(CJSuccessNetworkInfo * _Nullable successNetworkInfo))success;

@end
