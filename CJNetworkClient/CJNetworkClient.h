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
#import "AFHTTPSessionManager+CJSerializerEncrypt.h"
#import "AFHTTPSessionManager+CJUploadFile.h"
#import "CJResponseModel.h"

#import "CJRequestSettingModel.h"

typedef NS_ENUM(NSUInteger, CJResponeFailureType) {
    CJResponeFailureTypeUncheck = 0,            /**< 未进行是否等失败判断 */
    CJResponeFailureTypeRequestFailure,         /**< 请求失败 */
    CJResponeFailureTypeCommonFailure,          /**< 通用失败 */
    CJResponeFailureTypeNeedFurtherJudgeFailure,/**< 需要进一步判断是否错误的那些(在未进行归类或者未归类进指定错误的时候，都是这个值) */
};

/**
 *  必须实现：将"网络请求成功返回的数据responseObject"转换为"模型"的方法
 *
 *  @param responseObject   网络请求成功返回的数据
 *  @param isCacheData      是否是缓存数据
 *
 *  @return 数据模型
 */
typedef CJResponseModel * _Nullable (^CJNetworkClientGetSuccessResponseModelBlock)(id _Nullable responseObject, BOOL isCacheData);


/**
 *  必须实现：将"网络请求失败返回的数据error"转换为"模型"的方法
 *
 *  @param error            网络请求失败返回的数据
 *  @param errorMessage     从网络中获取到错误信息getErrorMessageFromHTTPURLResponse
 *
 *  @return 数据模型
 */
typedef CJResponseModel * _Nullable (^CJNetworkClientGetFailureResponseModelBlock)(NSError * _Nullable error, NSString * _Nullable errorMessage);







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

// 外界环境变化的时候要修改的值(一定要执行)
/**< 共有Url，形如@"http://xxx.xxx.xxx"，会通过baseUrl与apiSuffix组成fullUrl */
@property (nonatomic, copy) NSString *baseUrl;
/**< 公共参数(可变类型，如登录之后需要追加uid，退出时候需要remove uid) */
@property (nullable, nonatomic, strong) NSMutableDictionary *commonParams;

// Option
//@property (nonatomic, copy) id (^ _Nullable urlParamsHandle)(id _Nullable urlParams);  /**< if has urlParams, deal them before append them to Url */

// 可选设置(当你需要执行本地模拟(有服务器时候)的时候才需要)
@property (nonatomic, copy) NSString *simulateDomain;   /**< 本地模拟(有服务器时候)，模拟接口所在的域名 */


/**
 *  设置服务器返回值的各种处理方法(一定要执行)
 *
 *  @param getSuccessResponseModelBlock 将"网络请求成功返回的数据responseObject"转换为"模型"的方法
 *  @param checkIsCommonFailureBlock    在"网络请求成功并转换为模型"后判断其是否是"异地登录"等共同错误并在此对共同错误做处理(可为nil)
 *  @param getFailureResponseModelBlock 将"网络请求失败返回的数据error"转换为"模型"的方法
 */
- (void)setupGetSuccessResponseModelBlock:(CJNetworkClientGetSuccessResponseModelBlock)getSuccessResponseModelBlock
                checkIsCommonFailureBlock:(BOOL(^)(CJResponseModel *responseModel))checkIsCommonFailureBlock
             getFailureResponseModelBlock:(CJNetworkClientGetFailureResponseModelBlock)getFailureResponseModelBlock;


#pragma mark - RealApi
- (NSURLSessionDataTask *)real1_getApi:(NSString *)apiSuffix
                                params:(NSDictionary *)params
                          settingModel:(nullable CJRequestSettingModel *)settingModel
                         completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock;

- (NSURLSessionDataTask *)real1_postApi:(NSString *)apiSuffix
                                 params:(id)params
                           settingModel:(nullable CJRequestSettingModel *)settingModel
                          completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock;

- (NSURLSessionDataTask *)real1_uploadApi:(NSString *)apiSuffix
                                urlParams:(nullable id)urlParams
                               formParams:(nullable id)formParams
                             settingModel:(nullable CJRequestSettingModel *)settingModel
                         uploadFileModels:(nullable NSArray<CJUploadFileModel *> *)uploadFileModels
                                 progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                            completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock;
/**
 *  上传文件的请求方法：只是上传文件，不对上传过程中的各个时刻信息的进行保存
 *
 *  @param Url              Url
 *  @param urlParams        urlParams(需要拼接到url后的参数)
 *  @param formParams       formParams(除fileKey之外需要作为表单提交的参数)
 *  @param settingModel     settingModel
 *  @param uploadFileModels 文件数据：要上传的数据组uploadFileModels
 *  @param uploadProgress   uploadProgress
 *  @param completeBlock    上传结束执行的回调
 *
 *  @return 上传文件的请求
 */
- (NSURLSessionDataTask *)real1_uploadUrl:(NSString *)Url
                                urlParams:(nullable id)urlParams
                               formParams:(nullable id)formParams
                             settingModel:(nullable CJRequestSettingModel *)settingModel
                         uploadFileModels:(nullable NSArray<CJUploadFileModel *> *)uploadFileModels
                                 progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                            completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock;


#pragma mark - simulateApi
// 为方便接口的重复利用回调中的responseModel使用id类型
- (NSURLSessionDataTask *)simulate1_getApi:(NSString *)apiSuffix
                                    params:(nullable NSDictionary *)params
                              settingModel:(nullable CJRequestSettingModel *)settingModel
                             completeBlock:(void (^)(CJResponeFailureType failureType, id responseModel))completeBlock;

- (NSURLSessionDataTask *)simulate1_postApi:(NSString *)apiSuffix
                                     params:(nullable id)params
                               settingModel:(nullable CJRequestSettingModel *)settingModel
                              completeBlock:(void (^)(CJResponeFailureType failureType, id responseModel))completeBlock;

- (NSURLSessionDataTask *)simulate1_uploadApi:(NSString *)apiSuffix
                                    urlParams:(nullable id)urlParams
                                   formParams:(nullable id)formParams
                                 settingModel:(nullable CJRequestSettingModel *)settingModel
                             uploadFileModels:(nullable NSArray<CJUploadFileModel *> *)uploadFileModels
                                     progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                completeBlock:(void (^)(CJResponeFailureType failureType, id responseModel))completeBlock;


#pragma mark - localApi
// 为方便接口的重复利用回调中的responseModel使用id类型
- (nullable NSURLSessionDataTask *)local1_getApi:(NSString *)apiSuffix
                                          params:(NSDictionary *)params
                                    settingModel:(nullable CJRequestSettingModel *)settingModel
                                   completeBlock:(void (^)(CJResponeFailureType failureType, id responseModel))completeBlock;

- (nullable NSURLSessionDataTask *)local1_postApi:(NSString *)apiSuffix
                                           params:(id)params
                                     settingModel:(nullable CJRequestSettingModel *)settingModel
                                    completeBlock:(void (^)(CJResponeFailureType failureType, id responseModel))completeBlock;

- (nullable NSURLSessionDataTask *)local1_uploadApi:(NSString *)apiSuffix
                                          urlParams:(nullable id)urlParams
                                         formParams:(nullable id)formParams
                                       settingModel:(nullable CJRequestSettingModel *)settingModel
                                   uploadFileModels:(nullable NSArray<CJUploadFileModel *> *)uploadFileModels
                                           progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                      completeBlock:(void (^)(CJResponeFailureType failureType, id responseModel))completeBlock;

NS_ASSUME_NONNULL_END

@end
