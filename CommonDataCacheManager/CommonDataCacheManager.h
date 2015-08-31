//
//  CommonDataCacheManager.h
//  SDWebData
//
//  Created by lichq on 7/31/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "NSDictionary+Convert.h"
#import "NSData+Convert.h"
#import "NSString+MD5.h"

@class CommonDataCacheManager;
@protocol CommonDataCacheManagerDelegate<NSObject>
@optional
- (void)dataCache:(CommonDataCacheManager *)dataCacheManager didFindData:(NSData *)data forKey:(NSString *)key userInfo:(NSDictionary *)info;
- (void)dataCache:(CommonDataCacheManager *)dataCacheManager didNotFindDataForKey:(NSString *)key userInfo:(NSDictionary *)info;

@end


@interface CommonDataCacheManager : NSObject
{
    NSString *diskCachePath;
    NSString *imageCachePath;
    
    NSOperationQueue *cacheInQueue, *cacheOutQueue;
    NSMutableDictionary *memoryCache;
    NSMutableArray      *memoryCacheKeyArray;   //所有缓存地址的数组
    unsigned long long  memoryCacheMaxage;      //缓存数据最大的存放时间
    unsigned long long  memoryCacheMaxsize;     //缓存数据最大的空间大小
}
//硬盘上缓存保留的时候,单位为秒,默认为1周(60*60*24*7)
@property (nonatomic, assign) unsigned long long memoryCacheMaxage;
//内存中缓存数据的大小,单位为B,默认为2M(2*1024*1024)
@property (nonatomic, assign) unsigned long long  memoryCacheMaxsize;

+ (CommonDataCacheManager *)sharedCacheManager;

//存储data
- (void)cacheData:(NSData *)cacheData forCacheKey:(NSString *)cacheKey;
- (void)cacheData:(NSData *)cacheData forCacheKey:(NSString *)cacheKey toDisk:(BOOL)toDisk;

//得到指定的data
- (NSData *)dataFromKey:(NSString *)key;
- (NSData *)dataFromKey:(NSString *)key isMemoryCacheNil_then_getFromDisk:(BOOL)isMemoryCacheNil_then_getFromDisk;

- (void)queryDiskCacheForKey:(NSString *)cacheKey delegate:(id <CommonDataCacheManagerDelegate>)delegate userInfo:(NSDictionary *)userInfo;

- (void)removeMemoryCacheForKey:(NSString *)key;//移除指点的元素
- (void)clearMemoryCache;   //清理内存
- (void)clearDiskCache; //清理所有的缓存
- (void)cleanDiskCache; //清理过期的缓存
- (float)cacheFileSize; //缓存文件大小
@end



