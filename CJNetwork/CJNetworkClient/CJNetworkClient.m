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
@property (nonatomic, copy) NSString *(^completeFullUrlBlock)(NSString *apiSuffix);
@property (nonatomic, copy) NSDictionary *(^completeAllParamsBlock)(NSDictionary *customParams);

#pragma mark - 请求判断
//必须实现：将responseObject转为CJResponseModel
@property (nonatomic, copy) CJResponseModel *(^responseConvertBlock)(id responseObject, BOOL isCacheData);

//必须实现：检查是否是共同错误并在此对共同错误做处理，如statusCode == -5 为异地登录(可为ni,非nil时一般返回值为NO)
@property (nonatomic, copy) BOOL(^checkIsCommonBlock)(CJResponseModel *responseModel);

//可选实现：获取"请求失败的回调"的错误信息
@property (nonatomic, copy) NSString* (^getRequestFailureMessageBlock)(NSError *error);

@end



@implementation CJNetworkClient

- (instancetype)init {
    self = [super init];
    if (self) {
        __weak typeof(self)weakSelf = self;
        _completeFullUrlBlock = ^NSString *(NSString *apiSuffix) {
            NSMutableString *fullUrl = [NSMutableString string];
            [fullUrl appendFormat:@"%@", weakSelf.baseUrl];
            if (![weakSelf.baseUrl hasSuffix:@"/"]) {
                [fullUrl appendFormat:@"/"];
            }
            [fullUrl appendFormat:@"%@", apiSuffix];
            return [fullUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            //return [environmentManager completeUrlWithApiSuffix:apiSuffix];
        };
        
        _completeAllParamsBlock = ^NSDictionary *(NSDictionary *customParams) {
            NSMutableDictionary *allParams = [NSMutableDictionary dictionaryWithDictionary:customParams];
            [allParams addEntriesFromDictionary:weakSelf.commonParams];
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

//- (void)setupCompleteFullUrlBlock:(NSString * (^)(NSString *apiSuffix))completeFullUrlBlock
//           completeAllParamsBlock:(NSDictionary * (^)(NSDictionary *customParams))completeAllParamsBlock
//{
//    NSAssert(completeFullUrlBlock, @"Url 的获取方法都不能为空");
//    _completeFullUrlBlock = completeFullUrlBlock;
//    _completeAllParamsBlock = completeAllParamsBlock;
//}

- (void)setupResponseConvertBlock:(CJResponseModel *(^)(id responseObject, BOOL isCacheData))responseConvertBlock
               checkIsCommonBlock:(BOOL(^)(CJResponseModel *responseModel))checkIsCommonBlock
    getRequestFailureMessageBlock:(NSString* (^)(NSError *error))getRequestFailureMessageBlock
{
    NSAssert(responseConvertBlock, @"responseConvertBlock不能为空");
    self.responseConvertBlock = responseConvertBlock;
    self.checkIsCommonBlock = checkIsCommonBlock;
    self.getRequestFailureMessageBlock = getRequestFailureMessageBlock;
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

#pragma mark - Real
- (NSURLSessionDataTask *)real1_getApi:(NSString *)apiSuffix
                                params:(NSDictionary *)params
                          settingModel:(CJRequestSettingModel *)settingModel
                         completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock
{
    NSString *Url = self.completeFullUrlBlock(apiSuffix);
    
    return [self requestUrl:Url params:params method:CJRequestMethodGET settingModel:settingModel completeBlock:completeBlock];
}

- (NSURLSessionDataTask *)real1_postApi:(NSString *)apiSuffix
                                 params:(id)params
                           settingModel:(CJRequestSettingModel *)settingModel
                          completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock
{
    NSString *Url = self.completeFullUrlBlock(apiSuffix);
    
    return [self requestUrl:Url params:params method:CJRequestMethodPOST settingModel:settingModel completeBlock:completeBlock];
}

- (NSURLSessionDataTask *)real1_postUploadUrl:(nullable NSString *)Url
                                       params:(nullable NSDictionary *)customParams
                                 settingModel:(CJRequestSettingModel *)settingModel
                                      fileKey:(nullable NSString *)fileKey
                                    fileValue:(nullable NSArray<CJUploadFileModel *> *)uploadFileModels
                                     progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock
{
    AFHTTPSessionManager *manager = settingModel.shouldEncrypt ? self.cryptHTTPSessionManager : self.cleanHTTPSessionManager;
    
    NSDictionary *allParams = customParams;
    if (self.completeAllParamsBlock) {
        allParams = self.completeAllParamsBlock(customParams);
    }
    return [manager cj_postUploadUrl:Url params:customParams settingModel:settingModel fileKey:fileKey fileValue:uploadFileModels progress:uploadProgress success:^(CJSuccessRequestInfo * _Nullable successNetworkInfo) {
        [self __dealSuccessRequestInfo:successNetworkInfo completeBlock:completeBlock];
        
    } failure:^(CJFailureRequestInfo * _Nullable failureNetworkInfo) {
        [self __dealFailureNetworkInfo:failureNetworkInfo completeBlock:completeBlock];
    }];
}

#pragma mark simulate
- (NSURLSessionDataTask *)simulate1_getApi:(NSString *)apiSuffix
                                    params:(NSDictionary *)params
                              settingModel:(CJRequestSettingModel *)settingModel
                             completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock
{
    NSString *Url = [CJRequestSimulateUtil remoteSimulateUrlWithDomain:self.simulateDomain apiSuffix:apiSuffix];
    
    return [self requestUrl:Url params:params method:CJRequestMethodGET settingModel:settingModel completeBlock:completeBlock];
}


- (NSURLSessionDataTask *)simulate1_postApi:(NSString *)apiSuffix
                                     params:(id)params
                               settingModel:(CJRequestSettingModel *)settingModel
                              completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock
{
    NSString *Url = [CJRequestSimulateUtil remoteSimulateUrlWithDomain:self.simulateDomain apiSuffix:apiSuffix];
    
    return [self requestUrl:Url params:params method:CJRequestMethodGET settingModel:settingModel completeBlock:completeBlock];
}

- (NSURLSessionDataTask *)simulate1_postUploadUrl:(nullable NSString *)Url
                                           params:(nullable NSDictionary *)customParams
                                     settingModel:(CJRequestSettingModel *)settingModel
                                          fileKey:(nullable NSString *)fileKey
                                        fileValue:(nullable NSArray<CJUploadFileModel *> *)uploadFileModels
                                         progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                    completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock
{
    NSString *apiSuffix = @"upload_api/image"; //图片上传暂时固定写死
    Url = [CJRequestSimulateUtil remoteSimulateUrlWithDomain:self.simulateDomain apiSuffix:apiSuffix];
    
    return [self requestUrl:Url params:customParams method:CJRequestMethodGET settingModel:settingModel completeBlock:completeBlock];
}

#pragma mark - localApi
- (NSURLSessionDataTask *)local1_getApi:(NSString *)apiSuffix
                                 params:(NSDictionary *)params
                           settingModel:(CJRequestSettingModel *)settingModel
                          completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock
{
    [CJRequestSimulateUtil localSimulateApi:apiSuffix completeBlock:^(NSDictionary *responseDictionary) {
        BOOL isCacheData = NO;
        CJResponseModel *responseModel = self.responseConvertBlock(responseDictionary, isCacheData);
        
        if (completeBlock) {
            completeBlock(CJResponeFailureTypeUncheck, responseModel);
        }
    }];
    return nil;
}


- (NSURLSessionDataTask *)local1_postApi:(NSString *)apiSuffix
                                  params:(id)params
                            settingModel:(CJRequestSettingModel *)settingModel
                           completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock
{
    [CJRequestSimulateUtil localSimulateApi:apiSuffix completeBlock:^(NSDictionary *responseDictionary) {
        BOOL isCacheData = NO;
        CJResponseModel *responseModel = self.responseConvertBlock(responseDictionary, isCacheData);
        
        if (completeBlock) {
            completeBlock(CJResponeFailureTypeUncheck, responseModel);
        }
    }];
    return nil;
}

- (nullable NSURLSessionDataTask *)local1_postUploadUrl:(nullable NSString *)Url
                                                 params:(nullable NSDictionary *)customParams
                                           settingModel:(CJRequestSettingModel *)settingModel
                                                fileKey:(nullable NSString *)fileKey
                                              fileValue:(nullable NSArray<CJUploadFileModel *> *)uploadFileModels
                                               progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                          completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock
{
    NSString *apiSuffix = @"upload_api/image"; //图片上传暂时固定写死
    [CJRequestSimulateUtil localSimulateApi:apiSuffix completeBlock:^(NSDictionary *responseDictionary) {
        BOOL isCacheData = NO;
        CJResponseModel *responseModel = self.responseConvertBlock(responseDictionary, isCacheData);
        
        if (completeBlock) {
            completeBlock(CJResponeFailureTypeUncheck, responseModel);
        }
    }];
    return nil;
}


#pragma mark - Base
- (nullable NSURLSessionDataTask *)requestUrl:(nullable NSString *)Url
                                       params:(nullable id)customParams
                                       method:(CJRequestMethod)method
                                 settingModel:(CJRequestSettingModel *)settingModel
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
    
    NSURLSessionDataTask *URLSessionDataTask =
    [manager cj_requestUrl:Url params:allParams method:method settingModel:settingModel success:^(CJSuccessRequestInfo * _Nullable successNetworkInfo) {
        [self __dealSuccessRequestInfo:successNetworkInfo completeBlock:completeBlock];
        
    } failure:^(CJFailureRequestInfo * _Nullable failureNetworkInfo) {
        [self __dealFailureNetworkInfo:failureNetworkInfo completeBlock:completeBlock];
    }];
    
    return URLSessionDataTask;
}

#pragma mark - Private
- (void)__dealSuccessRequestInfo:(CJSuccessRequestInfo *)successNetworkInfo completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock {
    NSDictionary *responseDictionary = successNetworkInfo.responseObject;
    BOOL isCacheData = successNetworkInfo.isCacheData;
    CJResponseModel *responseModel = self.responseConvertBlock(responseDictionary, isCacheData);
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
    
    if (self.checkIsCommonBlock) {
        BOOL isCommonFailure = self.checkIsCommonBlock(responseModel);
        CJResponeFailureType failureType = isCommonFailure ? CJResponeFailureTypeCommonFailure : CJResponeFailureTypeNeedFurtherJudgeFailure;
        if (completeBlock) {
            completeBlock(failureType, responseModel);
        }
        
    } else {
        if (completeBlock) {
            completeBlock(CJResponeFailureTypeNeedFurtherJudgeFailure, responseModel);
        }
    }
}


- (void)__dealFailureNetworkInfo:(CJFailureRequestInfo *)failureNetworkInfo completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock {
    NSError *error = failureNetworkInfo.error;
    NSString *errorMessage = failureNetworkInfo.errorMessage;
    if (self.getRequestFailureMessageBlock) {
        errorMessage = self.getRequestFailureMessageBlock(error);
    }
    
    CJResponseModel *responseModel = [CJResponseModel responseModelWithRequestFailureMessage:errorMessage];
    CJResponeFailureType failureType = CJResponeFailureTypeRequestFailure;
    if (completeBlock) {
        completeBlock(failureType, responseModel);
    }
}

@end
