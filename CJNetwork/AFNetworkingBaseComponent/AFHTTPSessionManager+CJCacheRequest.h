//
//  AFHTTPSessionManager+CJCacheRequest.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 6/25/15.
//  Copyright (c) 2015 dvlproad. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "CJNetworkMonitor.h"

#import "CJRequestCacheDataUtil.h"

typedef NS_OPTIONS(NSUInteger, CJNeedGetCacheOption) {
    CJNeedGetCacheOptionNone = 1 << 0,             /**< 不缓存 */
    CJNeedGetCacheOptionNetworkUnable = 1 << 1,    /**< 无网 */
    CJNeedGetCacheOptionRequestFailure = 1 << 2,   /**< 有网，但是请求地址或者服务器错误等 */
};

/**
 *  AFN的请求方法(包含缓存方法)
 */
@interface AFHTTPSessionManager (CJCategory) {
    
}
//@property (nonatomic, copy) void (^_Nullable cjNoNetworkHandle)(void);    /**< 没有网络时候要执行的操作(添加此此代码块，解除对SVProgressHUD的依赖) */


/**
 *  发起请求
 *
 *  @param Url          Url
 *  @param params       params
 *  @param cache        是否缓存网络数据(如果有缓存，则即代表可以从缓存中获取数据)
 *  @param success      请求成功的回调success
 *  @param failure      请求失败的回调failure
 *
 *  @return NSURLSessionDataTask
 */
- (nullable NSURLSessionDataTask *)cj_postUrl:(nullable NSString *)Url
                                       params:(nullable id)params
                                        cache:(BOOL)cache
                                      success:(nullable void (^)(NSDictionary *_Nullable responseObject, BOOL isCacheData))success
                                      failure:(nullable void (^)(NSError * _Nullable error))failure;

@end
