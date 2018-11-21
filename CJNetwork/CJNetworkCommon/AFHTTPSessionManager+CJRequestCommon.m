//
//  AFHTTPSessionManager+CJRequestCommon.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2017/6/13.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "AFHTTPSessionManager+CJRequestCommon.h"
#import <objc/runtime.h>
#import "CJNetworkCacheUtil.h"

@interface AFURLSessionManager () {
    
}
#pragma mark - 并发数控制
@property (nonatomic, strong) dispatch_semaphore_t cjKeeperSignal;
@property (nonatomic, assign) long cjKeeperSignalCount;
@property (nonatomic, assign) BOOL shouldControlConcurrence;    /**< 是否应该控制并发数(默认NO) */
@property (nonatomic, assign) NSInteger concurrenceCount;       /**< 有控制并发数时候的请求并发数 */

#pragma mark - 拦截操作(一般只会用于需要获取dns的网络中)
@property (nonatomic, copy) NSString *cjKeeperUrl;  /**< 需要拦截的Url，其他请求需要等到该Url请求结束后才能继续 */

@end

@implementation AFHTTPSessionManager (CJRequestCommon)

#pragma mark - 并发数控制
// cjKeeperSignal
- (dispatch_semaphore_t)cjKeeperSignal {
    return objc_getAssociatedObject(self, @selector(cjKeeperSignal));
}

- (void)setCjKeeperSignal:(dispatch_semaphore_t)cjKeeperSignal {
    objc_setAssociatedObject(self, @selector(cjKeeperSignal), cjKeeperSignal, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// cjKeeperSignalCount
- (long)cjKeeperSignalCount {
    return [objc_getAssociatedObject(self, @selector(cjKeeperSignalCount)) longValue];
}

- (void)setCjKeeperSignalCount:(long)cjKeeperSignalCount {
    objc_setAssociatedObject(self, @selector(cjKeeperSignalCount), @(cjKeeperSignalCount), OBJC_ASSOCIATION_ASSIGN);
}

// shouldControlConcurrence
- (BOOL)shouldControlConcurrence {
    return [objc_getAssociatedObject(self, @selector(shouldControlConcurrence)) boolValue];
}

- (void)setShouldControlConcurrence:(BOOL)shouldControlConcurrence {
    objc_setAssociatedObject(self, @selector(shouldControlConcurrence), @(shouldControlConcurrence), OBJC_ASSOCIATION_ASSIGN);
}

// concurrenceCount
- (NSInteger)concurrenceCount {
    return [objc_getAssociatedObject(self, @selector(concurrenceCount)) integerValue];
}

- (void)setConcurrenceCount:(NSInteger)concurrenceCount {
    objc_setAssociatedObject(self, @selector(concurrenceCount), @(concurrenceCount), OBJC_ASSOCIATION_ASSIGN);
}

/// 设置并发数
- (void)setupConcurrenceCount:(NSInteger)concurrenceCount {
    NSAssert(concurrenceCount > 0, @"并发数必须大于0");
    
    self.shouldControlConcurrence = YES;
    self.concurrenceCount = concurrenceCount;
    
    if (self.cjKeeperSignal == nil) {
        self.cjKeeperSignal = dispatch_semaphore_create(concurrenceCount);
        self.cjKeeperSignalCount = concurrenceCount;
        
    } else {
        [self recoverConcurrenceCount];
    }
    
}

/// 恢复并发数(如果有些操作会更改到并发数，那么在该操作结束时候，需要调用此方法来恢复并发数)
- (void)recoverConcurrenceCount {
    if (!self.shouldControlConcurrence) {
        return;
    }
    
    if (self.cjKeeperSignalCount == self.concurrenceCount) {
        return;
    }
    
    if (self.cjKeeperSignalCount > self.concurrenceCount) { //并发数超过指定值，应该减少额外的信号量
        NSInteger shouldExtarReleaseSignalCount = self.cjKeeperSignalCount-self.concurrenceCount;
        for (NSInteger i = 0; i < shouldExtarReleaseSignalCount; i++) {
            self.cjKeeperSignalCount = dispatch_semaphore_wait(self.cjKeeperSignal, DISPATCH_TIME_FOREVER);
        }
        
    } else if (self.cjKeeperSignalCount < self.concurrenceCount) {//并发数小于指定值，应该增加额外的信号量
        NSInteger shouldExtarAddSignalCount = self.concurrenceCount-self.cjKeeperSignalCount;
        for (NSInteger i = 0; i < shouldExtarAddSignalCount; i++) {
            self.cjKeeperSignalCount = dispatch_semaphore_signal(self.cjKeeperSignal);
        }
    }
}

/// 网络请求开始前，对信号量做等待(减法)操作
- (void)__normalStartRequest {
    if (!self.shouldControlConcurrence) {
        return;
    }
    
    if (self.cjKeeperSignal) {
        dispatch_semaphore_wait(self.cjKeeperSignal, DISPATCH_TIME_FOREVER);
    }
}

/// 网络请求结束后，对信号量做增加操作
- (void)__normalEndRequest {
    if (!self.shouldControlConcurrence) {
        return;
    }
    
    if (self.cjKeeperSignal) {
        self.cjKeeperSignalCount = dispatch_semaphore_signal(self.cjKeeperSignal);
    }
}

- (void)__specialStartRequestWithKeeper {
    if (!self.shouldControlConcurrence) {
        return;
    }
    
    [self setupConcurrenceCount:1];
}

- (void)__specialEndRequestWithKeeper {
    if (!self.shouldControlConcurrence) {
        return;
    }
    
    [self recoverConcurrenceCount];
}


#pragma mark - 网络操作
/// 在请求前根据设置做相应处理
- (BOOL)__didEventBeforeStartRequestWithUrl:(nullable NSString *)Url
                                     params:(nullable NSDictionary *)params
                               settingModel:(CJRequestSettingModel *)settingModel
                                    success:(nullable void (^)(CJSuccessRequestInfo * _Nullable successRequestInfo))success
{
    [self __didConcurrenceControlWithStartRequestUrl:Url];
    
    CJRequestCacheStrategy cacheStrategy = settingModel.cacheStrategy;
    BOOL beforeStartRequestWillShowCache = YES; //在开始请求之前是否会先用缓存数据做一次快速显示
    BOOL shouldStartRequestNetworkData = YES;   //是否应该请求网络，如果最后不需要以实际的网络值显示，且能获取到缓存值，则不用进行请求
    if (cacheStrategy == CJRequestCacheStrategyEndWithCacheIfExist) {
        //成功/失败的时候，如果有缓存，则不用再去取网络错误值
        beforeStartRequestWillShowCache = YES;
        shouldStartRequestNetworkData = NO;
        
    } else if (cacheStrategy == CJRequestCacheStrategyUseCacheToTransition) {
        //成功/失败的时候，如果有缓存，使用缓存过去，最终以网络数据显示
        beforeStartRequestWillShowCache = YES;
        shouldStartRequestNetworkData = YES;
        
    } else { //CJRequestCacheStrategyNoneCache
        //NSLog(@"提示：这里之前不使用缓存，也就无法读取缓存，提示网络不给力");
        beforeStartRequestWillShowCache = NO;
        shouldStartRequestNetworkData = YES;
    }
    
    if (beforeStartRequestWillShowCache) {
        id responseObject = [CJNetworkCacheUtil requestCacheDataByUrl:Url params:params];
        if (responseObject) {
            [self __didGetCacheSuccessWithResponseObject:responseObject forUrl:Url params:params settingModel:settingModel success:success];
        } else { //获取缓存失败一定要进行请求，且一旦进行请求，最后肯定是以网络请求数据作为最后的显示，要不你请求干嘛
            shouldStartRequestNetworkData = YES;
        }
    }
    
    if (shouldStartRequestNetworkData == NO) {
        [self __didConcurrenceControlWithEndRequestUrl:Url]; // 网络请求结束后，并发量操作
    }
    
    return shouldStartRequestNetworkData;
}

///得到缓存数据时候执行的方法
- (void)__didGetCacheSuccessWithResponseObject:(nullable id)responseObject
                            forUrl:(nullable NSString *)Url
                            params:(nullable id)params
                      settingModel:(CJRequestSettingModel *)settingModel
                           success:(nullable void (^)(CJSuccessRequestInfo * _Nullable successRequestInfo))success
{
    NSURLRequest *request = nil;
    CJRequestLogType logType = settingModel.logType;
    
    CJSuccessRequestInfo *successRequestInfo = [CJSuccessRequestInfo successNetworkLogWithType:logType Url:Url params:params request:request responseObject:responseObject];
    successRequestInfo.isCacheData = YES;
    if (success) {
        success(successRequestInfo);
    }
}

///网络请求获取到数据时候执行的方法(responseObject必须是解密后的数据)
- (void)__didRequestSuccessForTask:(NSURLSessionDataTask * _Nonnull)task
                withResponseObject:(nullable id)responseObject
                       isCacheData:(BOOL)isCacheData
                            forUrl:(nullable NSString *)Url
                            params:(nullable id)params
                      settingModel:(CJRequestSettingModel *)settingModel
                           success:(nullable void (^)(CJSuccessRequestInfo * _Nullable successRequestInfo))success
{
    CJRequestCacheStrategy cacheStrategy = settingModel.cacheStrategy;
    if (cacheStrategy != CJRequestCacheStrategyNoneCache) {  //是否需要本地缓存现在请求下来的网络数据
        [CJNetworkCacheUtil cacheResponseObject:responseObject forUrl:Url params:params cacheTimeInterval:settingModel.cacheTimeInterval];
    }
    
    NSURLRequest *request = task.originalRequest;
    CJRequestLogType logType = settingModel.logType;
    
    CJSuccessRequestInfo *successRequestInfo = [CJSuccessRequestInfo successNetworkLogWithType:logType Url:Url params:params request:request responseObject:responseObject];
    successRequestInfo.isCacheData = isCacheData;
    if (success) {
        success(successRequestInfo);
    }
    
    [self __didConcurrenceControlWithEndRequestUrl:Url]; // 网络请求结束后，并发量操作
}

///网络请求不到数据的时候（无网 或者 有网但服务器异常等无数据时候）执行的方法
- (void)__didRequestFailureForTask:(NSURLSessionDataTask * _Nonnull)task
                 withResponseError:(NSError * _Nullable)error
                            forUrl:(nullable NSString *)Url
                            params:(nullable id)params
                      settingModel:(CJRequestSettingModel *)settingModel
                           failure:(nullable void (^)(CJFailureRequestInfo * _Nullable failureRequestInfo))failure
{
    NSURLRequest *request = task.originalRequest;
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
    CJRequestLogType logType = settingModel.logType;
    CJFailureRequestInfo *failureRequestInfo = [CJFailureRequestInfo errorNetworkLogWithType:logType Url:Url params:params request:request error:error URLResponse:response];
    failureRequestInfo.isRequestFailure = YES;
    if (failure) {
        failure(failureRequestInfo);
    }
    
    [self __didConcurrenceControlWithEndRequestUrl:Url]; // 网络请求结束后，并发量操作
}

#pragma mark - 拦截操作(一般只会用于需要获取dns的网络中)
// cjKeeperUrl
- (NSString *)cjKeeperUrl {
    return objc_getAssociatedObject(self, @selector(cjKeeperUrl));
}

- (void)setCjKeeperUrl:(NSString *)cjKeeperUrl {
    objc_setAssociatedObject(self, @selector(cjKeeperUrl), cjKeeperUrl, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

/// 设置拦截的操作
- (void)setupKeeperUrl:(NSString *)Url {
    self.cjKeeperUrl = Url;
}

/// 网络请求开始前，对信号量做等待(减法)操作
- (void)__didConcurrenceControlWithStartRequestUrl:(NSString *)Url {
    if ([Url isEqualToString:self.cjKeeperUrl]) {
        [self __specialStartRequestWithKeeper];
    } else {
        [self __normalStartRequest];
    }
}

/// 网络请求结束后，对信号量做增加操作
- (void)__didConcurrenceControlWithEndRequestUrl:(NSString *)Url {
    if ([Url isEqualToString:self.cjKeeperUrl]) {
        [self __specialEndRequestWithKeeper];
    } else {
        [self __normalEndRequest];
    }
}

/**
 *  开始拦截，使得允许通过的请求数目为allowRequestCount
 *
 *  @param allowRequestCount    允许通过的请求数目
 */
- (void)startKeeperWithAllowRequestCount:(NSInteger)allowRequestCount {
    if (self.cjKeeperSignal == nil) {
        self.cjKeeperSignal = dispatch_semaphore_create(allowRequestCount);
        self.cjKeeperSignalCount = allowRequestCount;
    } else {
        NSInteger shouldExtarReleaseSignalCount = self.cjKeeperSignalCount-allowRequestCount;//应该额外取消的信号量
        if (shouldExtarReleaseSignalCount > 0) {
            for (NSInteger i = 0; i < shouldExtarReleaseSignalCount; i++) {
                self.cjKeeperSignalCount = dispatch_semaphore_wait(self.cjKeeperSignal, DISPATCH_TIME_FOREVER);
            }
        }
    }
}

/**
 *  停止拦截，同时使得允许通过的请求数目为allowRequestCount(即并发数)
 *
 *  @param allowRequestCount    允许通过的请求数目
 */
- (void)stopKeeperWithAllowRequestCount:(NSInteger)allowRequestCount {
    if (self.cjKeeperSignal) {
        // 网络请求结束后，对信号量cjKeeperSignal增加1
        for (NSInteger i = 0; i < allowRequestCount; i++) {
            self.cjKeeperSignalCount = dispatch_semaphore_signal(self.cjKeeperSignal);
        }
    }
}

@end
