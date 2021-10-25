//
//  CJUploadModelProtocol.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/6/3.
//  Copyright © 2018年 dvlproad. All rights reserved.
//
//  请求信息需要遵守的协议

#ifndef CJUploadModelProtocol_h
#define CJUploadModelProtocol_h

#import <Foundation/Foundation.h>
#import "CJRequestNetworkEnum.h"
#import "CJRequestSettingModel.h"
#import <CJNetworkFileModel/CJUploadFileModel.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CJUploadModelProtocol <NSObject>

@optional
@property (nonatomic, assign) CQRequestType requestType;        /**< 请求方式（网络/模拟/本地） */

@required
//@property (nonatomic, assign) CJRequestMethod requestMethod;    /**< 请求方式 */
@property (nonatomic, copy) NSString *apiSuffix;                /**< 请求地址的后缀 */
@optional
@property (nullable, nonatomic, copy) NSString *ownBaseUrl;     /**< 该请求使用自己的baseUrl，而不用全局的(为nil时使用全局的) */


@optional
@property (nullable, nonatomic, copy) NSDictionary *urlParams;  /**< 请求参数(需要拼接到url后的参数) */
@property (nullable, nonatomic, copy) NSDictionary *formParams; /**< 请求参数(除fileKey之外需要作为表单提交的参数) */
@property (nonatomic, assign) CJRequestEncrypt requestEncrypt;  /**< 参数的加密方式 */

#pragma mark - 上传
@property (nullable, nonatomic, strong) NSArray<CJUploadFileModel *> *uploadFileModels; /**< 文件数据：要上传的数据组uploadFileModels */
//@property (nullable, nonatomic, copy) void (^uploadProgress)(NSProgress *progress); // 放在方法里

@optional
@property (nullable, nonatomic, strong) CJRequestSettingModel *settingModel;

@end


NS_ASSUME_NONNULL_END

#endif /* CJUploadModelProtocol_h */

