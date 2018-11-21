//
//  CJRequestSettingModel.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/5/8.
//  Copyright © 2018年 dvlproad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CJRequestInfoModel.h"

/// 缓存策略
typedef NS_ENUM(NSUInteger, CJRequestCacheStrategy) {
    CJRequestCacheStrategyNoneCache,            /**< 成功/失败的时候，都不使用缓存，直接使用网络数据 */
    CJRequestCacheStrategyEndWithCacheIfExist,  /**< 成功/失败的时候，如果有缓存，则不用再去取网络实际值 */
    CJRequestCacheStrategyUseCacheToTransition, /**< 成功/失败的时候，如果有缓存，使用缓存过渡来快速显示，最终以网络数据显示 */
};

@interface CJRequestSettingModel : NSObject {
    
}

#pragma mark - 拦截
// 请求拦截(默认NO)
@property (nonatomic, assign) BOOL isKeeperUrl;

// 以下 keepingAllowRequestCount 和 keptAllowRequestCount 只当 isKeeperUrl 为 YES 时候，才有用
// 请求拦截后，最多允许通过的请求个数(默认1，以阻塞线程)
@property (nonatomic, assign) BOOL keepingAllowRequestCount;

// 请求结束后，最多允许通过的请求个数(默认6，以使得并发6)
@property (nonatomic, assign) NSInteger keptAllowRequestCount;

#pragma mark - 上传
// 上传请求进度
@property (nonatomic, copy) void (^uploadProgress)(NSProgress *progress);

#pragma mark log相关
// log类型(默认CJRequestLogTypeConsoleLog)
@property (nonatomic, assign) CJRequestLogType logType;

#pragma mark 加密相关

// 是否需要加密
@property (nonatomic, assign) BOOL shouldEncrypt;

// 加密方法
@property (nonatomic, copy) NSData* (^encryptBlock)(NSDictionary *requestParmas);

// 解密方法
@property (nonatomic, copy) NSDictionary* (^decryptBlock)(NSString *responseString);


#pragma mark 缓存相关

// 缓存策略(如果设为CJRequestCacheStrategyNoneCache，那么下面两个方法的缓存相当于只是缓存，却永远不会用，即白搭了)
@property (nonatomic, assign) CJRequestCacheStrategy cacheStrategy;

// 缓存时间,默认不缓存
@property (nonatomic, assign ) NSTimeInterval cacheTimeInterval;

@end
