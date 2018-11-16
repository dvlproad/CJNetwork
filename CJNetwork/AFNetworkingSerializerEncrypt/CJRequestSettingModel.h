//
//  CJRequestSettingModel.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/5/8.
//  Copyright © 2018年 dvlproad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CJNetworkInfoModel.h"

///缓存时间等级
typedef NS_ENUM(NSUInteger, CJNetworkCacheLevel) {
    CJNetworkCacheLevelCustom = 0,
    CJNetworkCacheLevelOne,
    CJNetworkCacheLevelTwo,
    CJNetworkCacheLevelThree,
    CJNetworkCacheLevelFour,
    CJNetworkCacheLevelFive,
    CJNetworkCacheLevelSix
};

@interface CJRequestSettingModel : NSObject {
    
}

#pragma mark - 上传
// 上传请求进度
@property (nonatomic, copy) void (^uploadProgress)(NSProgress *progress);

#pragma mark log相关
// log类型(默认CJNetworkLogTypeConsoleLog)
@property (nonatomic, assign) CJNetworkLogType logType;

//#pragma mark 加密相关
//
//// 是否需要加密
//@property (nonatomic, assign) BOOL shouldEncrypt;
//
//// 加密方法
//@property (nonatomic, copy) NSData* (^encryptBlock)(NSDictionary *requestParmas);
//
//// 解密方法
//@property (nonatomic, copy) NSDictionary* (^decryptBlock)(NSString *responseString);


#pragma mark 缓存相关

// 是否需要缓存
@property (nonatomic, assign) BOOL shouldCache;

// 缓存时间等级类型
@property (nonatomic, assign ) CJNetworkCacheLevel cacheLevel;

// 缓存时间,默认不缓存
@property (nonatomic, assign ) NSTimeInterval cacheTimeInterval;

@end
