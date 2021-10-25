//
//  CJNetworkClient+Upload1.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/6/3.
//  Copyright © 2018年 dvlproad. All rights reserved.
//

#import "CJNetworkClient+Upload1.h"
#import <CJNetworkSimulate/CJSimulateRemoteUtil.h>
#import <CJNetworkSimulate/CJSimulateLocalUtil.h>
#import <CJNetwork/AFHTTPSessionManager+CJUploadFile.h>

@implementation CJNetworkClient (Upload1)

#pragma mark - RealApi
/*
 *  上传文件的请求方法：只是上传文件，不对上传过程中的各个时刻信息的进行保存
 *
 *  @param model            上传请求相关的信息(包含请求方法、请求地址、请求参数等)real\simulate\local
 *  @param progress         上传请求过程的回调
 *  @param completeBlock    上传请求结束的回调(为方便接口的重复利用回调中的responseModel使用id类型)
 *
 *  @return 上传文件的请求
 */
- (NSURLSessionDataTask *)uploadModel:(__kindof NSObject<CJUploadModelProtocol> *)model
                             progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                        completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock
{
    CQRequestType requestType = [model requestType];
    if (requestType == CQRequestTypeReal) {
        return [self real1_uploadModel:model progress:uploadProgress completeBlock:completeBlock];
        
    } else if (requestType == CQRequestTypeSimulate) {
        return [self simulate1_uploadModel:model progress:uploadProgress completeBlock:completeBlock];
        
    } else if (requestType == CQRequestTypeLocal) {
        return [self local1_uploadModel:model progress:uploadProgress completeBlock:completeBlock];
    }
    
    return [self real1_uploadModel:model progress:uploadProgress completeBlock:completeBlock];
}

- (NSURLSessionDataTask *)real1_uploadModel:(__kindof NSObject<CJUploadModelProtocol> *)model
                                 progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                            completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock
{
    NSString *baseUrl = [model ownBaseUrl];
    if (baseUrl) {
        baseUrl = self.baseUrl;
    }
    
    NSString *apiSuffix = [model apiSuffix];
    NSString *Url = self.completeFullUrlBlock(baseUrl, apiSuffix);
    
    id urlParams = [model urlParams];
    id formParams = [model formParams];
    
    NSArray<CJUploadFileModel *> *uploadFileModels = [model uploadFileModels];
    
    CJRequestSettingModel *settingModel = [model settingModel];
    CJRequestCacheSettingModel *cacheSettingModel = settingModel.requestCacheModel;
    CJRequestLogType logType = settingModel.logType;
    
    BOOL shouldEncrypt = [model requestEncrypt] == CJRequestEncryptYES;
    AFHTTPSessionManager *manager = shouldEncrypt ? self.cryptHTTPSessionManager : self.cleanHTTPSessionManager;
    
    id lastUrlParams = urlParams;
//    if (urlParams && self.urlParamsHandle) {
//        lastUrlParams = self.urlParamsHandle(urlParams);
//    }
    NSDictionary<NSString *, NSString *> *headers = @{};
    
    return [manager cj_uploadUrl:Url urlParams:lastUrlParams formParams:formParams headers:headers uploadFileModels:uploadFileModels cacheSettingModel:cacheSettingModel logType:logType progress:uploadProgress success:^(CJSuccessRequestInfo * _Nullable successNetworkInfo) {
        [CJResponseHelper __dealSuccessRequestInfo:successNetworkInfo
          getSuccessResponseModelBlock:self.getSuccessResponseModelBlock
             checkIsCommonFailureBlock:self.checkIsCommonFailureBlock
                         completeBlock:completeBlock];
        
    } failure:^(CJFailureRequestInfo * _Nullable failureNetworkInfo) {
        [CJResponseHelper __dealFailureNetworkInfo:failureNetworkInfo
                      getFailureResponseModelBlock:self.getFailureResponseModelBlock
                                     completeBlock:completeBlock];
    }];
}




#pragma mark - simulateApi

- (NSURLSessionDataTask *)simulate1_uploadModel:(__kindof NSObject<CJUploadModelProtocol> *)model
                                     progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock
{
    NSString *apiSuffix = [model apiSuffix];
    NSString *Url = [@"http://localhost/" stringByAppendingString:apiSuffix];
    
    NSMutableDictionary *allParams = [[NSMutableDictionary alloc] init];
    //if (weakSelf.commonParams) {
    //    [allParams addEntriesFromDictionary:weakSelf.commonParams];
    //}
    
    id urlParams = [model urlParams];
    id formParams = [model formParams];
    if (formParams) {
        [allParams addEntriesFromDictionary:formParams];
    }
    
    NSDictionary<NSString *, NSString *> *headers = @{};
    
    AFHTTPSessionManager *manager = [self __simulateUploadHTTPSessionManager];
    
    NSURLSessionDataTask *URLSessionDataTask =
    [manager GET:Url parameters:allParams headers:headers progress:uploadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSURLRequest *request = task.originalRequest;
        CJRequestLogType logType = CJRequestLogTypeConsoleLog;
        
        CJSuccessRequestInfo *successRequestInfo = [CJSuccessRequestInfo successNetworkLogWithType:logType Url:Url params:allParams request:request responseObject:responseObject];
        successRequestInfo.isCacheData = NO;
        
        [CJResponseHelper __dealSuccessRequestInfo:successRequestInfo
                      getSuccessResponseModelBlock:^CJResponseModel * _Nonnull(id  _Nonnull responseObject, BOOL isCacheData) {
            
            NSDictionary *responseDictionary = responseObject;
            //CJResponseModel *responseModel = [CJResponseModel mj_objectWithKeyValues:responseDictionary];
            //CJResponseModel *responseModel = [[CJResponseModel alloc] initWithResponseDictionary:responseDictionary isCacheData:isCacheData];
            CJResponseModel *responseModel = [[CJResponseModel alloc] init];
            responseModel .statusCode = [responseDictionary[@"status"] integerValue];
            responseModel.message = responseDictionary[@"message"];
            responseModel.result = responseDictionary[@"result"];
            responseModel.isCacheData = isCacheData;
            
            return responseModel;
            
        } checkIsCommonFailureBlock:^BOOL(CJResponseModel * _Nonnull responseModel) {
            // 检查是否是共同错误并在此对共同错误做处理，如statusCode == -5 为异地登录(可为ni,非nil时一般返回值为NO)
            if (responseModel.statusCode == 5) { //执行退出登录
                //[CJToast shortShowMessage:@"账号异地登录"];
                //[[CJDemoUserManager sharedInstance] logout:YES completed:nil];
                return YES;
            } else {
                return NO;
            }
            
        } completeBlock:completeBlock];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSURLRequest *request = task.originalRequest;
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        CJRequestLogType logType = CJRequestLogTypeConsoleLog;
        CJFailureRequestInfo *failureRequestInfo = [CJFailureRequestInfo errorNetworkLogWithType:logType Url:Url params:allParams request:request error:error URLResponse:response];
        failureRequestInfo.isRequestFailure = YES;
        
        [CJResponseHelper __dealFailureNetworkInfo:failureRequestInfo
                      getFailureResponseModelBlock:^CJResponseModel * _Nullable(NSError * _Nullable error, NSString * _Nullable errorMessage) {
            if (errorMessage == nil || errorMessage.length == 0) {
                errorMessage = NSLocalizedString(@"网络链接失败，请检查您的网络链接", nil);
            }
            CJResponseModel *responseModel = [[CJResponseModel alloc] init];
            responseModel.statusCode = -1;
            responseModel.message = errorMessage;
            responseModel.result = nil;
            
            return responseModel;
            
        } completeBlock:completeBlock];
    }];
    
    return URLSessionDataTask;
}

- (AFHTTPSessionManager *)__simulateUploadHTTPSessionManager
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer  = requestSerializer;
    
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                 @"text/plain",
                                                 @"text/html",
                                                 @"application/json",
                                                 @"application/json;charset=utf-8", nil];
    manager.responseSerializer = responseSerializer;
    
    
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 20.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    return manager;
}


#pragma mark - localApi

- (nullable NSURLSessionDataTask *)local1_uploadModel:(__kindof NSObject<CJUploadModelProtocol> *)model
                                           progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                      completeBlock:(void (^)(CJResponeFailureType failureType, id responseModel))completeBlock
{
    NSString *apiSuffix = [model apiSuffix];
    [CJSimulateLocalUtil localSimulateApi:apiSuffix completeBlock:^(NSDictionary *responseDictionary) {
        BOOL isCacheData = NO;
        CJResponseModel *responseModel = self.getSuccessResponseModelBlock(responseDictionary, isCacheData);
        
        if (completeBlock) {
            completeBlock(CJResponeFailureTypeUncheck, responseModel);
        }
    }];
    return nil;
}


@end
