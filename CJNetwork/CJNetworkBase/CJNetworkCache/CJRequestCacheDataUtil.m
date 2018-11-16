//
//  CJRequestCacheDataUtil.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2017/3/29.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "CJRequestCacheDataUtil.h"

#import "CJObjectConvertUtil.h"

#ifdef CJTESTPOD
#import "CJCacheManager.h"
#else
#import <CJCacheManager/CJCacheManager.h>
#endif


static NSString * const kRelativeDirectoryPath = @"CJNetworkCache";

@implementation CJRequestCacheDataUtil

/** 完整的描述请参见文件头部 */
+ (void)cacheNetworkData:(nullable id)responseObject
            byRequestUrl:(nullable NSString *)Url
              parameters:(nullable NSDictionary *)parameters
       cacheTimeInterval:(NSTimeInterval)cacheTimeInterval
{
    NSString *requestCacheKey = [self getRequestCacheKeyByRequestUrl:Url parameters:parameters];
    if (nil == requestCacheKey) {
        NSLog(@"error: cacheKey == nil, 无法进行缓存");
        
    }else{
        if (!responseObject){
            [[CJCacheManager sharedInstance] removeCacheForCacheKey:requestCacheKey diskRelativeDirectoryPath:kRelativeDirectoryPath];
            
            
        } else {
            //TODO:responseObject(json) 转data
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:responseObject];
            NSData *cacheData = [CJObjectConvertUtil dataFromDictionary:dic];
            
            [[CJCacheManager sharedInstance] cacheData:cacheData forCacheKey:requestCacheKey andSaveInDisk:YES withDiskRelativeDirectoryPath:kRelativeDirectoryPath];
        }
    }
}

/** 完整的描述请参见文件头部 */
+ (NSDictionary *)requestCacheDataByUrl:(nullable NSString *)Url
                                 params:(nullable id)params
{
    NSString *requestCacheKey = [self getRequestCacheKeyByRequestUrl:Url parameters:params];
    if (nil == requestCacheKey) {
        NSLog(@"error: cacheKey == nil, 无法读取缓存，提示网络不给力");
        return nil;
    }
    
    NSData *requestCacheData = [[CJCacheManager sharedInstance] getCacheDataByCacheKey:requestCacheKey diskRelativeDirectoryPath:kRelativeDirectoryPath];
    if (requestCacheData) {
        //NSLog(@"读到有缓存数据，但不保证该数据是最新的，因为网络还是不给力");
        NSDictionary *responseObject = [CJObjectConvertUtil dictionaryFromData:requestCacheData];
        return responseObject;
        
    } else {
        //NSLog(@"未读到有缓存数据,如第一次就是无网请求,提示网络不给力");
        return nil;
    }
}

/**
 *  获取请求的缓存key
 *
 *  @param Url          Url
 *  @param parameters   parameters
 *
 *  return 请求的缓存key
 */
+ (NSString *)getRequestCacheKeyByRequestUrl:(NSString *)Url
                                  parameters:(NSDictionary *)parameters {
    NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] init];
    [mutableDictionary addEntriesFromDictionary:parameters];
    [mutableDictionary setObject:Url forKey:@"cjRequestUrl"];
    
    NSString *string = [CJObjectConvertUtil stringFromDictionary:mutableDictionary];
    NSString *requestCacheKey = [CJObjectConvertUtil MD5StringFromString:string];
    
    NSAssert(requestCacheKey, @"requestCacheKey值不能为空");
    return requestCacheKey;
}


@end
