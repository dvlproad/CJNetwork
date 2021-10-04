//
//  CJRequestSettingModel.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/5/8.
//  Copyright © 2018年 dvlproad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CJNetwork/CJRequestCacheSettingModel.h>    // 网络请求中的缓存相关设置
#import <CJNetwork/CJRequestLogSettingModel.h>      // 网络请求中的Log相关设置
#import <CJNetwork/CJRequestInfoModel.h>            // 网络请求的整体信息(包括请求前的request信息和请求后的reponse信息)

NS_ASSUME_NONNULL_BEGIN

@interface CJRequestSettingModel : NSObject {
    
}
//@property (nonatomic, copy) NSString *ownBaseUrl;   /**< 该请求使用的baseUrl */

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
// 网络请求中的缓存相关设置
@property (nonatomic, strong) CJRequestCacheSettingModel *requestCacheModel;

@end

NS_ASSUME_NONNULL_END
