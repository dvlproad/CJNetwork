//
//  CJNetworkClient.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/6/3.
//  Copyright © 2018年 dvlproad. All rights reserved.
//
//  网络请求管理类，其他NetworkClient可通过本CJNetworkClient继承，也可自己再实现。
//  如果您的app还需要支持网络环境变化，那么由于网络环境变化的时候共有的baseUrl一定会发生变化和共有的commonParams有可能会发生变化，所以您可能需要如下两个参数：
//  @property (nonatomic, copy) NSString *baseUrl;              /**< 共有Url */
//  @property (nonatomic, strong) NSDictionary *commonParams;   /**< 共有参数 */
//  或者您进一步的自己通过实现一个NetworkEnvironmentManager来控制着这两个参数的变化

#import <Foundation/Foundation.h>
#import <AFNetworking/AFHTTPSessionManager.h>

#import "CJRequestSettingModel.h"
#import "CJResponseHelper.h"


NS_ASSUME_NONNULL_BEGIN

@interface CJNetworkClient : NSObject {
    
}
// 执行请求的Manager(一定要执行)
- (void)setupCleanHTTPSessionManager:(AFHTTPSessionManager *)cleanHTTPSessionManager
             cryptHTTPSessionManager:(AFHTTPSessionManager *)cryptHTTPSessionManager;

//// 执行请求的Manager(一定要执行)
//- (void)setupHTTPSessionManager:(AFHTTPSessionManager *)httpSessionManager
//   cryptWithParamsEncryptHandle:(NSDictionary *(^)(id params))paramsCryptHandle
//      responseDataDecryptHandle:(id (^)(id responseData))responseDataDecryptHandle;


#pragma mark - 整体网络
@property (nonatomic, strong, readonly) AFHTTPSessionManager *cleanHTTPSessionManager;
@property (nonatomic, strong, readonly) AFHTTPSessionManager *cryptHTTPSessionManager;
//@property (nonatomic, strong) AFHTTPSessionManager *uploadHTTPSessionManager;
//@property (nonatomic, strong) AFHTTPSessionManager *httpSessionManager;
//@property (nonatomic, copy) NSDictionary *(^paramsCryptHandle)(id params);      /**< 加密之参数加密 */
//@property (nonatomic, copy) id (^responseDataDecryptHandle)(id responseData);   /**< 加密之值解密 */

// 外界环境变化的时候要修改的值(一定要执行)
/**< 共有Url，形如@"http://xxx.xxx.xxx"，会通过baseUrl与apiSuffix组成fullUrl */
@property (nonatomic, copy) NSString *baseUrl;
/**< 公共参数(可变类型，如登录之后需要追加uid，退出时候需要remove uid) */
@property (nonatomic, copy, readonly) NSString *(^completeFullUrlBlock)(NSString *baseUrl, NSString *apiSuffix);
@property (nullable, nonatomic, strong) NSMutableDictionary *commonParams;
@property (nonatomic, copy, readonly) NSDictionary *(^completeAllParamsBlock)(NSDictionary *customParams);

#pragma mark - 请求判断
//必须实现：将"网络请求成功返回的数据responseObject"转换为"模型"的方法
@property (nonatomic, copy, readonly) CJResponseModel *(^getSuccessResponseModelBlock)(id responseObject, BOOL isCacheData);

//必须实现：将"网络请求失败返回的数据error"转换为"模型"的方法
@property (nonatomic, copy, readonly) CJResponseModel* (^getFailureResponseModelBlock)(NSError *error, NSString *errorMessage);

//可选实现：在"网络请求成功并转换为模型"后判断其是否是"异地登录"等共同错误并在此对共同错误做处理，如statusCode == -5 为异地登录(可为ni,非nil时一般返回值为NO)
//未设置时候 CJResponeFailureType 为 CJResponeFailureTypeNeedFurtherJudgeFailure
//设置时候 若返回YES,则即为CJResponeFailureTypeCommonFailure，其会走failure回调;
//设置时候 若返回NO,则即为CJResponeFailureTypeNeedFurtherJudgeFailure，其会走success回调；
//详细的走法如下代码所示：
//if (failureType == CJResponeFailureTypeCommonFailure) {
//    !failure ?: failure(NO, responseModel.message);
//
//} else if (failureType == CJResponeFailureTypeRequestFailure) {
//    !failure ?: failure(YES, responseModel.message);
//
//} else {
//    !success ?: success(responseModel);
//}
@property (nonatomic, copy, readonly) BOOL(^checkIsCommonFailureBlock)(CJResponseModel *responseModel);


// Option
//@property (nonatomic, copy) id (^ _Nullable urlParamsHandle)(id _Nullable urlParams);  /**< if has urlParams, deal them before append them to Url */

// 可选设置(当你需要执行本地模拟(有服务器时候)的时候才需要)
@property (nonatomic, copy) NSString *simulateDomain;   /**< 本地模拟(有服务器时候)，模拟接口所在的域名 */


/*
 *  设置服务器返回值的各种处理方法(一定要执行)
 *
 *  @param getSuccessResponseModelBlock 将"网络请求成功返回的数据responseObject"转换为"模型"的方法
 *  @param checkIsCommonFailureBlock    在"网络请求成功并转换为模型"后判断其是否是"异地登录"等共同错误并在此对共同错误做处理(可为nil)
 *  @param getFailureResponseModelBlock 将"网络请求失败返回的数据error"转换为"模型"的方法
 */
- (void)setupGetSuccessResponseModelBlock:(CJNetworkClientGetSuccessResponseModelBlock)getSuccessResponseModelBlock
                checkIsCommonFailureBlock:(BOOL(^)(CJResponseModel *responseModel))checkIsCommonFailureBlock
             getFailureResponseModelBlock:(CJNetworkClientGetFailureResponseModelBlock)getFailureResponseModelBlock;


@end

NS_ASSUME_NONNULL_END
