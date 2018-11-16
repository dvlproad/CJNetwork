//
//  CJRequestCacheDataUtil.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2017/3/29.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, CJRequestCacheFailureType) {
    CJRequestCacheFailureTypeCacheKeyNil,            /**< cacheKey == nil */
    CJRequestCacheFailureTypeCacheDataNil,           /**< 未读到缓存数据,如第一次就是无网请求,提示网络不给力 */
};


@interface CJRequestCacheDataUtil : NSObject

/**
 *  缓存网络请求的数据
 *
 *  @param responseObject       要缓存的数据
 *  @param Url                  Url
 *  @param parameters           parameters
 *  @param cacheTimeInterval    cacheTimeInterval
 */
+ (void)cacheNetworkData:(nullable id)responseObject
            byRequestUrl:(nullable NSString *)Url
              parameters:(nullable NSDictionary *)parameters
       cacheTimeInterval:(NSTimeInterval)cacheTimeInterval;

/**
 *  获取请求的缓存数据
 *
 *  @param Url          Url
 *  @param params       params
 *
 *  return 获取到缓存数据
 */
+ (NSDictionary *)requestCacheDataByUrl:(nullable NSString *)Url
                                 params:(nullable id)params;

@end
