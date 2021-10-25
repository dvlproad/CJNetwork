//
//  CJRequestModelProtocol.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/6/3.
//  Copyright © 2018年 dvlproad. All rights reserved.
//
//  请求信息需要遵守的协议

#ifndef CJRequestModelProtocol_h
#define CJRequestModelProtocol_h

#import <Foundation/Foundation.h>
#import "CJRequestNetworkEnum.h"
#import "CJRequestSettingModel.h"

/// 请求方式
typedef NS_ENUM(NSUInteger, CQRequestType) {
    CQRequestTypeReal = 0,      /**< 执行网络请求 */
    CQRequestTypeSimulate,      /**< 执行模拟请求 */
    CQRequestTypeLocal,         /**< 执行本地请求 */
};


NS_ASSUME_NONNULL_BEGIN

@protocol CJRequestModelProtocol <NSObject>

@optional
@property (nonatomic, assign) CQRequestType requestType;        /**< 请求方式 */

@required
@property (nonatomic, assign) CJRequestMethod requestMethod;    /**< 请求方式 */
@property (nonatomic, strong) NSString *apiSuffix;              /**< 请求地址的后缀 */

@optional
@property (nonatomic, strong) NSDictionary *customParams;       /**< 请求参数 */

@optional
@property (nullable, nonatomic, strong) CJRequestSettingModel *settingModel;

@end

NS_ASSUME_NONNULL_END

#endif /* CJRequestModelProtocol_h */

