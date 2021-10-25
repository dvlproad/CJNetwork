//
//  CJRequestParamProtocol.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/6/3.
//  Copyright © 2018年 dvlproad. All rights reserved.
//
//  请求参数需要遵守的协议

#ifndef CJRequestParamProtocol_h
#define CJRequestParamProtocol_h

#import <Foundation/Foundation.h>
#import "CJRequestInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CJRequestParamProtocol <NSObject>

@required
@property (nonatomic, assign) CJRequestMethod requestMethod;    /**< 请求方式 */
@property (nonatomic, strong) NSString *Url;                    /**< 请求地址 */

@optional
@property (nullable, nonatomic, strong) NSDictionary *allParams;    /**< 请求参数 */
@property (nullable, nonatomic, strong) NSDictionary<NSString *, NSString *> *headers;

@property (nullable, nonatomic, strong) CJRequestCacheSettingModel *cacheSettingModel;
@property (nullable, nonatomic, assign) CJRequestLogType logType;   /**< log的打印方式 */

@end

NS_ASSUME_NONNULL_END

#endif /* CJRequestParamProtocol_h */

