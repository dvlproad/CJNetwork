//
//  CJNetworkClient.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/6/3.
//  Copyright © 2018年 dvlproad. All rights reserved.
//

#import "CJNetworkClient.h"
#import <objc/runtime.h>

#import "CJRequestSimulateUtil.h"

@interface CJNetworkClient () {
    
}
#pragma mark - 整体网络
@property (nonatomic, strong) AFHTTPSessionManager *cleanHTTPSessionManager;
@property (nonatomic, strong) AFHTTPSessionManager *cryptHTTPSessionManager;
//@property (nonatomic, strong) AFHTTPSessionManager *uploadHTTPSessionManager;
//@property (nonatomic, strong) AFHTTPSessionManager *httpSessionManager;
//@property (nonatomic, copy) NSDictionary *(^paramsCryptHandle)(id params);      /**< 加密之参数加密 */
//@property (nonatomic, copy) id (^responseDataDecryptHandle)(id responseData);   /**< 加密之值解密 */

@property (nonatomic, copy) NSString *(^completeFullUrlBlock)(NSString *baseUrl, NSString *apiSuffix);
@property (nonatomic, copy) NSDictionary *(^completeAllParamsBlock)(NSDictionary *customParams);

#pragma mark - 请求判断
//必须实现：将"网络请求成功返回的数据responseObject"转换为"模型"的方法
@property (nonatomic, copy) CJResponseModel *(^getSuccessResponseModelBlock)(id responseObject, BOOL isCacheData);

//必须实现：将"网络请求失败返回的数据error"转换为"模型"的方法
@property (nonatomic, copy) CJResponseModel* (^getFailureResponseModelBlock)(NSError *error, NSString *errorMessage);

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
@property (nonatomic, copy) BOOL(^checkIsCommonFailureBlock)(CJResponseModel *responseModel);

@end



@implementation CJNetworkClient

- (instancetype)init {
    self = [super init];
    if (self) {
        __weak typeof(self)weakSelf = self;
        _completeFullUrlBlock = ^NSString *(NSString *baseUrl, NSString *apiSuffix) {
            return [weakSelf __completeFullUrlWithBaseUrl:baseUrl apiSuffix:apiSuffix];
        };
        
        _completeAllParamsBlock = ^NSDictionary *(NSDictionary *customParams) {
            NSMutableDictionary *allParams = [[NSMutableDictionary alloc] init];
            if (weakSelf.commonParams) {
                [allParams addEntriesFromDictionary:weakSelf.commonParams];
            }
            if (customParams) {
                [allParams addEntriesFromDictionary:customParams];
            }
            return allParams;
            //return [environmentManager completeParamsWithCustomParams:customParams];
        };
    }
    return self;
}

- (void)setupCleanHTTPSessionManager:(AFHTTPSessionManager *)cleanHTTPSessionManager
             cryptHTTPSessionManager:(AFHTTPSessionManager *)cryptHTTPSessionManager
{
    NSAssert(cleanHTTPSessionManager || cryptHTTPSessionManager, @"不加密和加密的不可以同时都没有");
    self.cleanHTTPSessionManager = cleanHTTPSessionManager;
    self.cryptHTTPSessionManager = cryptHTTPSessionManager;
}

/*
- (void)setupHTTPSessionManager:(AFHTTPSessionManager *)httpSessionManager cryptWithParamsEncryptHandle:(NSDictionary * _Nonnull (^)(id _Nonnull))paramsCryptHandle responseDataDecryptHandle:(id  _Nonnull (^)(id _Nonnull))responseDataDecryptHandle
{
    _httpSessionManager = httpSessionManager;
    _paramsCryptHandle = paramsCryptHandle;
    _responseDataDecryptHandle = responseDataDecryptHandle;
}
//*/

- (void)setupGetSuccessResponseModelBlock:(CJNetworkClientGetSuccessResponseModelBlock)getSuccessResponseModelBlock
                checkIsCommonFailureBlock:(BOOL(^)(CJResponseModel *responseModel))checkIsCommonFailureBlock
             getFailureResponseModelBlock:(CJNetworkClientGetFailureResponseModelBlock)getFailureResponseModelBlock
{
    NSAssert(getSuccessResponseModelBlock, @"getSuccessResponseModelBlock不能为空");
    NSAssert(getFailureResponseModelBlock, @"getFailureResponseModelBlock不能为空");
    self.getSuccessResponseModelBlock = getSuccessResponseModelBlock;
    self.checkIsCommonFailureBlock = checkIsCommonFailureBlock;
    self.getFailureResponseModelBlock = getFailureResponseModelBlock;
}

/*
#pragma mark - 单例
+ (instancetype)sharedInstance {
    id sharedInstance = objc_getAssociatedObject(self, @"cjNetworkClientSharedInstance");
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL] init];
        objc_setAssociatedObject(self, @"cjNetworkClientSharedInstance", sharedInstance, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return sharedInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}

- (id)copyWithZone:(nullable NSZone *)zone {
    return [[self class] sharedInstance];
}
*/


#pragma mark - RealApi
- (NSURLSessionDataTask *)real1_getApi:(NSString *)apiSuffix
                                params:(NSDictionary *)params
                          settingModel:(nullable CJRequestSettingModel *)settingModel
                         completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock
{
    NSString *baseUrl = self.baseUrl;
    //NSString *baseUrl = settingModel.ownBaseUrl ? settingModel.ownBaseUrl : self.baseUrl;
    NSString *Url = self.completeFullUrlBlock(baseUrl, apiSuffix);
    
    return [self __requestUrl:Url params:params method:CJRequestMethodGET settingModel:settingModel completeBlock:completeBlock];
}

- (NSURLSessionDataTask *)real1_postApi:(NSString *)apiSuffix
                                 params:(id)params
                           settingModel:(nullable CJRequestSettingModel *)settingModel
                          completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock
{
    NSString *baseUrl = self.baseUrl;
    //NSString *baseUrl = settingModel.ownBaseUrl ? settingModel.ownBaseUrl : self.baseUrl;
    NSString *Url = self.completeFullUrlBlock(baseUrl, apiSuffix);
    
    return [self __requestUrl:Url params:params method:CJRequestMethodPOST settingModel:settingModel completeBlock:completeBlock];
}

- (NSURLSessionDataTask *)real1_uploadApi:(NSString *)apiSuffix
                                urlParams:(nullable id)urlParams
                               formParams:(nullable id)formParams
                             settingModel:(nullable CJRequestSettingModel *)settingModel
                         uploadFileModels:(nullable NSArray<CJUploadFileModel *> *)uploadFileModels
                                 progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                            completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock
{
    NSString *baseUrl = self.baseUrl;
    //NSString *baseUrl = settingModel.ownBaseUrl ? settingModel.ownBaseUrl : self.baseUrl;
    NSString *Url = self.completeFullUrlBlock(baseUrl, apiSuffix);
    
    return [self real1_uploadUrl:Url urlParams:urlParams formParams:formParams settingModel:settingModel uploadFileModels:uploadFileModels progress:uploadProgress completeBlock:completeBlock];
}

- (NSURLSessionDataTask *)real1_uploadUrl:(NSString *)Url
                                urlParams:(nullable id)urlParams
                               formParams:(nullable id)formParams
                             settingModel:(nullable CJRequestSettingModel *)settingModel
                         uploadFileModels:(nullable NSArray<CJUploadFileModel *> *)uploadFileModels
                                 progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                            completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock
{
    AFHTTPSessionManager *manager = settingModel.shouldEncrypt ? self.cryptHTTPSessionManager : self.cleanHTTPSessionManager;
    
    id lastUrlParams = urlParams;
//    if (urlParams && self.urlParamsHandle) {
//        lastUrlParams = self.urlParamsHandle(urlParams);
//    }
    CJRequestCacheSettingModel *cacheSettingModel = settingModel.requestCacheModel;
    CJRequestLogType logType = settingModel.logType;
    
    return [manager cj_uploadUrl:Url urlParams:lastUrlParams formParams:formParams uploadFileModels:uploadFileModels cacheSettingModel:cacheSettingModel logType:logType progress:uploadProgress success:^(CJSuccessRequestInfo * _Nullable successNetworkInfo) {
        [self __dealSuccessRequestInfo:successNetworkInfo
          getSuccessResponseModelBlock:self.getSuccessResponseModelBlock
             checkIsCommonFailureBlock:self.checkIsCommonFailureBlock
                         completeBlock:completeBlock];
        
    } failure:^(CJFailureRequestInfo * _Nullable failureNetworkInfo) {
        [self __dealFailureNetworkInfo:failureNetworkInfo completeBlock:completeBlock];
    }];
}


#pragma mark - simulateApi
- (NSURLSessionDataTask *)simulate1_getApi:(NSString *)apiSuffix
                                    params:(NSDictionary *)params
                              settingModel:(nullable CJRequestSettingModel *)settingModel
                             completeBlock:(void (^)(CJResponeFailureType failureType, id responseModel))completeBlock
{
    NSString *Url = [CJRequestSimulateUtil remoteSimulateUrlWithDomain:self.simulateDomain apiSuffix:apiSuffix];
    
    return [self __requestUrl:Url params:params method:CJRequestMethodGET settingModel:settingModel completeBlock:completeBlock];
}


- (NSURLSessionDataTask *)simulate1_postApi:(NSString *)apiSuffix
                                     params:(id)params
                               settingModel:(nullable CJRequestSettingModel *)settingModel
                              completeBlock:(void (^)(CJResponeFailureType failureType, id responseModel))completeBlock
{
    NSString *Url = [CJRequestSimulateUtil remoteSimulateUrlWithDomain:self.simulateDomain apiSuffix:apiSuffix];
    
    return [self __requestUrl:Url params:params method:CJRequestMethodGET settingModel:settingModel completeBlock:completeBlock];
}

- (NSURLSessionDataTask *)simulate1_uploadApi:(NSString *)apiSuffix
                                    urlParams:(nullable id)urlParams
                                   formParams:(nullable id)formParams
                                 settingModel:(nullable CJRequestSettingModel *)settingModel
                             uploadFileModels:(nullable NSArray<CJUploadFileModel *> *)uploadFileModels
                                     progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                completeBlock:(void (^)(CJResponeFailureType failureType, id responseModel))completeBlock
{
    NSString *Url = [CJRequestSimulateUtil remoteSimulateUrlWithDomain:self.simulateDomain apiSuffix:apiSuffix];
    
    return [self __requestUrl:Url params:formParams method:CJRequestMethodGET settingModel:settingModel completeBlock:completeBlock];
}


#pragma mark - localApi
- (nullable NSURLSessionDataTask *)local1_getApi:(NSString *)apiSuffix
                                          params:(NSDictionary *)params
                                    settingModel:(nullable CJRequestSettingModel *)settingModel
                                   completeBlock:(void (^)(CJResponeFailureType failureType, id responseModel))completeBlock
{
    [CJRequestSimulateUtil localSimulateApi:apiSuffix completeBlock:^(NSDictionary *responseDictionary) {
        BOOL isCacheData = NO;
        CJResponseModel *responseModel = self.getSuccessResponseModelBlock(responseDictionary, isCacheData);
        
        if (completeBlock) {
            completeBlock(CJResponeFailureTypeUncheck, responseModel);
        }
    }];
    return nil;
}


- (nullable NSURLSessionDataTask *)local1_postApi:(NSString *)apiSuffix
                                           params:(id)params
                                     settingModel:(nullable CJRequestSettingModel *)settingModel
                                    completeBlock:(void (^)(CJResponeFailureType failureType, id responseModel))completeBlock
{
    [CJRequestSimulateUtil localSimulateApi:apiSuffix completeBlock:^(NSDictionary *responseDictionary) {
        BOOL isCacheData = NO;
        CJResponseModel *responseModel = self.getSuccessResponseModelBlock(responseDictionary, isCacheData);
        
        if (completeBlock) {
            completeBlock(CJResponeFailureTypeUncheck, responseModel);
        }
    }];
    return nil;
}

- (nullable NSURLSessionDataTask *)local1_uploadApi:(NSString *)apiSuffix
                                          urlParams:(nullable id)urlParams
                                         formParams:(nullable id)formParams
                                       settingModel:(nullable CJRequestSettingModel *)settingModel
                                   uploadFileModels:(nullable NSArray<CJUploadFileModel *> *)uploadFileModels
                                           progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                      completeBlock:(void (^)(CJResponeFailureType failureType, id responseModel))completeBlock
{
    [CJRequestSimulateUtil localSimulateApi:apiSuffix completeBlock:^(NSDictionary *responseDictionary) {
        BOOL isCacheData = NO;
        CJResponseModel *responseModel = self.getSuccessResponseModelBlock(responseDictionary, isCacheData);
        
        if (completeBlock) {
            completeBlock(CJResponeFailureTypeUncheck, responseModel);
        }
    }];
    return nil;
}


#pragma mark - Base
- (nullable NSURLSessionDataTask *)__requestUrl:(NSString *)Url
                                         params:(nullable id)customParams
                                         method:(CJRequestMethod)method
                                   settingModel:(nullable CJRequestSettingModel *)settingModel
                                  completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock
{
    AFHTTPSessionManager *manager = nil;
    if (method == CJRequestMethodGET) {
        manager = self.cleanHTTPSessionManager;
        
    } else if (method == CJRequestMethodPOST) {
        manager = settingModel.shouldEncrypt ? self.cryptHTTPSessionManager : self.cleanHTTPSessionManager;
    }
    
    NSDictionary *allParams = customParams;
    if (self.completeAllParamsBlock) {
        allParams = self.completeAllParamsBlock(customParams);
    }
    
    CJRequestCacheSettingModel *cacheSettingModel = settingModel.requestCacheModel;
    CJRequestLogType logType = settingModel.logType;
    void (^progress)(NSProgress * _Nonnull) = settingModel.uploadProgress;
    
    NSURLSessionDataTask *URLSessionDataTask =
    [manager cj_requestUrl:Url params:allParams method:method cacheSettingModel:cacheSettingModel logType:logType progress:progress success:^(CJSuccessRequestInfo * _Nullable successNetworkInfo) {
        [self __dealSuccessRequestInfo:successNetworkInfo
          getSuccessResponseModelBlock:self.getSuccessResponseModelBlock
             checkIsCommonFailureBlock:self.checkIsCommonFailureBlock
                         completeBlock:completeBlock];
        
    } failure:^(CJFailureRequestInfo * _Nullable failureNetworkInfo) {
        [self __dealFailureNetworkInfo:failureNetworkInfo completeBlock:completeBlock];
    }];
    
    return URLSessionDataTask;
}

#pragma mark - Private
- (NSString *)__completeFullUrlWithBaseUrl:(NSString *)baseUrl apiSuffix:(NSString *)apiSuffix {
    NSMutableString *fullUrl = [NSMutableString string];
    [fullUrl appendFormat:@"%@", baseUrl];
    
    if ([self.baseUrl hasSuffix:@"/"] == NO) {
        if ([apiSuffix hasPrefix:@"/"]) {
            [fullUrl appendFormat:@"%@", apiSuffix];
        } else { //shouldAddSlash
            [fullUrl appendFormat:@"/%@", apiSuffix];
        }
    } else {
        if ([apiSuffix hasPrefix:@"/"]) {//shouldRemoveSlash
            [fullUrl appendFormat:@"%@", [apiSuffix substringFromIndex:1]];
        } else {
            [fullUrl appendFormat:@"%@", apiSuffix];
        }
    }
    return [fullUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //return [environmentManager completeUrlWithApiSuffix:apiSuffix];
}

- (void)__dealSuccessRequestInfo:(CJSuccessRequestInfo *)successNetworkInfo
    getSuccessResponseModelBlock:(CJResponseModel *(^)(id responseObject, BOOL isCacheData))getSuccessResponseModelBlock
       checkIsCommonFailureBlock:(BOOL(^)(CJResponseModel *responseModel))checkIsCommonFailureBlock
                   completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock
{
    NSDictionary *responseDictionary = successNetworkInfo.responseObject;
    BOOL isCacheData = successNetworkInfo.isCacheData;
    CJResponseModel *responseModel = getSuccessResponseModelBlock(responseDictionary, isCacheData);
    //方式①
    //CJResponseModel *responseModel = [CJResponseModel mj_objectWithKeyValues:responseDictionary];
    //方式②
    //CJResponseModel *responseModel = [[CJResponseModel alloc] initWithResponseDictionary:responseDictionary isCacheData:successNetworkInfo.isCacheData];
    //方式③
    //CJResponseModel *responseModel = [[CJResponseModel alloc] init];
    //responseModel.statusCode = [responseDictionary[@"status"] integerValue];
    //responseModel.message = responseDictionary[@"message"];
    //responseModel.result = responseDictionary[@"result"];
    //responseModel.isCacheData = isCacheData;
    
    CJResponeFailureType failureType = CJResponeFailureTypeNeedFurtherJudgeFailure;
    if (checkIsCommonFailureBlock) {
        BOOL isCommonFailure = checkIsCommonFailureBlock(responseModel);
        failureType = isCommonFailure ? CJResponeFailureTypeCommonFailure : CJResponeFailureTypeNeedFurtherJudgeFailure;
    }
    
    if (completeBlock) {
        completeBlock(failureType, responseModel);
    }
}


- (void)__dealFailureNetworkInfo:(CJFailureRequestInfo *)failureNetworkInfo completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock {
    NSError *error = failureNetworkInfo.error;
    NSString *errorMessage = failureNetworkInfo.errorMessage;

    CJResponseModel *responseModel = self.getFailureResponseModelBlock(error, errorMessage);
    //responseModel.isCacheData = NO;
    CJResponeFailureType failureType = CJResponeFailureTypeRequestFailure;
    if (completeBlock) {
        completeBlock(failureType, responseModel);
    }
}

@end
