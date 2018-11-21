//
//  CJNetworkClient.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/6/3.
//  Copyright © 2018年 dvlproad. All rights reserved.
//
//  网络请求管理类，其他NetworkClient可通过本CJNetworkClient继承，也可自己再实现

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager+CJSerializerEncrypt.h"

#import "CJRequestSimulateUtil.h"

/////缓存时间等级
//typedef NS_ENUM(NSUInteger, CJNetworkCacheLevel) {
//    CJNetworkCacheLevelCustom = 0,
//    CJNetworkCacheLevelOne,
//    CJNetworkCacheLevelTwo,
//    CJNetworkCacheLevelThree,
//    CJNetworkCacheLevelFour,
//    CJNetworkCacheLevelFive,
//    CJNetworkCacheLevelSix
//};

@interface CJNetworkClient : NSObject {
    
}

@end
