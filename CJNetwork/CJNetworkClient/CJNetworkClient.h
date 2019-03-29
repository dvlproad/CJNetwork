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

typedef NS_ENUM(NSUInteger, CJResponeFailureType) {
    CJResponeFailureTypeUncheck = 0,            /**< 未进行是否等失败判断 */
    CJResponeFailureTypeRequestFailure,         /**< 请求失败 */
    CJResponeFailureTypeCommonFailure,          /**< 通用失败 */
    CJResponeFailureTypeNeedFurtherJudgeFailure,/**< 需要进一步判断是否错误的那些(在未进行归类或者未归类进指定错误的时候，都是这个值) */
};

/**
 *  将"网络成功返回的数据"转换为"模型"的方法
 *
 *  @param responseObject   网络成功返回的数据
 *  @param isCacheData      是否是缓存数据
 *
 *  @return 数据模型
 */
typedef CJResponseModel *(^CJNetworkClientResponseConvertBlock)(id responseObject, BOOL isCacheData);
//typedef BOOL(^CJNetworkClientCheckIsCommonFailureBlock)(CJResponseModel *responseModel);
//typedef NSString* (^CJNetworkClientGetRequestFailureMessageBlock)(NSError *error);


@interface CJNetworkClient : NSObject {
    
}
// 执行请求的Manager(一定要执行)
- (void)setupCleanHTTPSessionManager:(AFHTTPSessionManager *)cleanHTTPSessionManager
             cryptHTTPSessionManager:(AFHTTPSessionManager *)cryptHTTPSessionManager;

// 外界环境变化的时候要修改的值(一定要执行)
/**< 共有Url，形如@"http://xxx.xxx.xxx"，会通过baseUrl与apiSuffix组成fullUrl */
@property (nonatomic, copy) NSString *baseUrl;
/**< 公共参数 */
@property (nonatomic, strong) NSDictionary *commonParams;

// 可选设置(当你需要执行本地模拟(有服务器时候)的时候才需要)
@property (nonatomic, copy) NSString *simulateDomain;   /**< 本地模拟(有服务器时候)，模拟接口所在的域名 */

/**
 *  服务器返回值处理方法设置(一定要执行)
 *
 *  @param responseConvertBlock             将"网络成功返回的数据"转换为"模型"的方法
 *  @param checkIsCommonFailureBlock        对"已转换为模型的网络数据"判断当前是否是"异地登录"等公共错误结果
 *  @param getRequestFailureMessageBlock    对"网络失败返回的error"转换为"错误信息字符串"的方法
 */
- (void)setupResponseConvertBlock:(CJNetworkClientResponseConvertBlock)responseConvertBlock
        checkIsCommonFailureBlock:(BOOL(^)(CJResponseModel *responseModel))checkIsCommonFailureBlock
    getRequestFailureMessageBlock:(NSString* (^)(NSError *error))getRequestFailureMessageBlock;



#pragma mark - Real
- (NSURLSessionDataTask *)real1_getApi:(NSString *)apiSuffix
                                params:(NSDictionary *)params
                          settingModel:(CJRequestSettingModel *)settingModel
                         completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock;

- (NSURLSessionDataTask *)real1_postApi:(NSString *)apiSuffix
                                 params:(id)params
                           settingModel:(CJRequestSettingModel *)settingModel
                          completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock;

/**
 *  上传文件的请求方法：只是上传文件，不对上传过程中的各个时刻信息的进行保存
 *
 *  @param Url              Url
 *  @param customParams     customParams
 *  @param settingModel     settingModel
 *  @param fileKey          文件参数：有些人会用file,有些人用upfile
 *  @param uploadFileModels 文件数据：要上传的数据组uploadFileModels
 *  @param uploadProgress   uploadProgress
 *  @param completeBlock    上传结束执行的回调
 *
 *  @return 上传文件的请求
 */
- (NSURLSessionDataTask *)real1_postUploadUrl:(nullable NSString *)Url
                                       params:(nullable NSDictionary *)customParams
                                 settingModel:(CJRequestSettingModel *)settingModel
                                      fileKey:(nullable NSString *)fileKey
                                    fileValue:(nullable NSArray<CJUploadFileModel *> *)uploadFileModels
                                     progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock;


#pragma mark simulate
- (NSURLSessionDataTask *)simulate1_getApi:(NSString *)apiSuffix
                                    params:(NSDictionary *)params
                              settingModel:(CJRequestSettingModel *)settingModel
                             completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock;

- (NSURLSessionDataTask *)simulate1_postApi:(NSString *)apiSuffix
                                     params:(id)params
                               settingModel:(CJRequestSettingModel *)settingModel
                              completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock;

- (NSURLSessionDataTask *)simulate1_postUploadUrl:(nullable NSString *)Url
                                           params:(nullable NSDictionary *)customParams
                                     settingModel:(CJRequestSettingModel *)settingModel
                                          fileKey:(nullable NSString *)fileKey
                                        fileValue:(nullable NSArray<CJUploadFileModel *> *)uploadFileModels
                                         progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                    completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock;

#pragma mark - localApi
- (NSURLSessionDataTask *)local1_getApi:(NSString *)apiSuffix
                                 params:(NSDictionary *)params
                           settingModel:(CJRequestSettingModel *)settingModel
                          completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock;

- (NSURLSessionDataTask *)local1_postApi:(NSString *)apiSuffix
                                  params:(id)params
                            settingModel:(CJRequestSettingModel *)settingModel
                           completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock;

- (NSURLSessionDataTask *)local1_postUploadUrl:(nullable NSString *)Url
                                        params:(nullable NSDictionary *)customParams
                                  settingModel:(CJRequestSettingModel *)settingModel
                                       fileKey:(nullable NSString *)fileKey
                                     fileValue:(nullable NSArray<CJUploadFileModel *> *)uploadFileModels
                                      progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                 completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock;

@end
