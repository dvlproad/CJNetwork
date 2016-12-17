////
////  AFNUtilCache.m
////  CommonAFNUtilDemo
////
////  Created by 李超前 on 15/11/22.
////  Copyright © 2015年 ciyouzen. All rights reserved.
////
//
//#import "AFNUtilCache.h"
//#import "AFHTTPRequestOperation+Get.h"
//#import "CommonDataCacheManager.h"
//
//@implementation AFNUtilCache
//
//#pragma mark - 私有方法
//+ (void)hud_showNoNetwork{
//    [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"网络不给力", nil)];
//}
//
//#pragma mark - 公共方法
//+ (AFHTTPRequestOperation *)useManager:(AFHTTPSessionManager *)manager
//    postRequestUrl:(NSString *)Url
//            params:(NSDictionary *)params
//          useCache:(BOOL)useCache
//           success:(void(^)(AFHTTPRequestOperation *operation, id responseObject, BOOL isCacheData))success
//           failure:(void(^)(AFHTTPRequestOperation *operation, NSString *failMesg, BOOL isCacheData))failure
//{
//    
//    BOOL isNetworkEnabled = [AFNetworkReachabilityManager sharedManager].isReachable;
//    if (isNetworkEnabled == NO) {
//#pragma mark 网络不可用，读取本地缓存数据
//        if (useCache == NO) {
//            NSLog(@"提示：这里之前未缓存，无法读取缓存，提示网络不给力");
//            [self hud_showNoNetwork];
//            return nil;
//        }
//        
//        NSString *cacheKey = [[params convertToString] MD5];
//        if (nil == cacheKey) {
//            NSLog(@"error: cacheKey == nil, 无法读取缓存，提示网络不给力");
//            [self hud_showNoNetwork];
//            return nil;
//        }
//        
//        NSData *cacheData = [[CommonDataCacheManager sharedCacheManager] dataFromKey:cacheKey isMemoryCacheNil_then_getFromDisk:YES];
//        if (cacheData) {
//            NSDictionary *responseObject = [cacheData convertToDictionary];
//            if (success) {
//                success(nil, responseObject, YES);
//            }
//            
//        }else{
//            if (failure) {
//                NSLog(@"未读到缓存数据，提示网络不给力");
//                [self hud_showNoNetwork];
//            }
//        }
//        
//        return nil;
//        
//    }else{
//        
//#pragma mark - 网络可用，直接下载数据，并根据是否需要缓存来进行缓存操作
//        AFHTTPRequestOperation *operation =
//        [manager POST:Url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            if (success)
//            {
//                NSMutableDictionary *responseObject_dic = [operation responseObject_dic:operation];
//                success(operation, responseObject_dic, NO);//有网络的时候,responseObject等就不是来源磁盘(缓存),故为NO
//            }
//            
//            if (useCache) { //本地缓存
//                NSString *cacheKey = [[params convertToString] MD5];
//                if (nil == cacheKey) {
//                    NSLog(@"error: cacheKey == nil, 无法进行缓存");
//                    
//                }else{
//                    if (!responseObject){
//                        [[CommonDataCacheManager sharedCacheManager] removeMemoryCacheForKey:cacheKey];
//                        
//                    }else{
//                        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:responseObject];
//                        [[CommonDataCacheManager sharedCacheManager] cacheData:[dic convertToData] forCacheKey:cacheKey toDisk:YES];
//                    }
//                }
//            }
//            
//            
//            
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            if (failure)
//            {
//                NSString *failMesg = [operation failMesg:operation];
//                failure(operation, failMesg, NO);
//            }
//        }];
//        return operation;
//    }
//}
//
//
//
//
//
//@end
