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

// 服务器返回值处理方法设置(一定要执行)
- (void)setupResponseConvertBlock:(CJResponseModel *(^)(id responseObject, BOOL isCacheData))responseConvertBlock
               checkIsCommonBlock:(BOOL(^)(CJResponseModel *responseModel))checkIsCommonBlock
    getRequestFailureMessageBlock:(NSString* (^)(NSError *error))getRequestFailureMessageBlock;

#pragma mark - Real
- (NSURLSessionDataTask *)real_getApi:(NSString *)apiSuffix
                               params:(NSDictionary *)params
                         settingModel:(CJRequestSettingModel *)settingModel
                        completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock;

- (NSURLSessionDataTask *)real_postApi:(NSString *)apiSuffix
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
- (NSURLSessionDataTask *)real_postUploadUrl:(nullable NSString *)Url
                                      params:(nullable NSDictionary *)customParams
                                settingModel:(CJRequestSettingModel *)settingModel
                                     fileKey:(nullable NSString *)fileKey
                                   fileValue:(nullable NSArray<CJUploadFileModel *> *)uploadFileModels
                                    progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                               completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock;


#pragma mark simulate
- (NSURLSessionDataTask *)simulate_getApi:(NSString *)apiSuffix
                                   params:(NSDictionary *)params
                             settingModel:(CJRequestSettingModel *)settingModel
                            completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock;

- (NSURLSessionDataTask *)simulate_postApi:(NSString *)apiSuffix
                                    params:(id)params
                              settingModel:(CJRequestSettingModel *)settingModel
                             completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock;

- (NSURLSessionDataTask *)simulate_postUploadUrl:(nullable NSString *)Url
                                          params:(nullable NSDictionary *)customParams
                                    settingModel:(CJRequestSettingModel *)settingModel
                                         fileKey:(nullable NSString *)fileKey
                                       fileValue:(nullable NSArray<CJUploadFileModel *> *)uploadFileModels
                                        progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                   completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock;

#pragma mark - localApi
- (NSURLSessionDataTask *)local_getApi:(NSString *)apiSuffix
                                params:(NSDictionary *)params
                          settingModel:(CJRequestSettingModel *)settingModel
                         completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock;

- (NSURLSessionDataTask *)local_postApi:(NSString *)apiSuffix
                                 params:(id)params
                           settingModel:(CJRequestSettingModel *)settingModel
                          completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock;

- (NSURLSessionDataTask *)local_postUploadUrl:(nullable NSString *)Url
                                       params:(nullable NSDictionary *)customParams
                                 settingModel:(CJRequestSettingModel *)settingModel
                                      fileKey:(nullable NSString *)fileKey
                                    fileValue:(nullable NSArray<CJUploadFileModel *> *)uploadFileModels
                                     progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock;

@end
