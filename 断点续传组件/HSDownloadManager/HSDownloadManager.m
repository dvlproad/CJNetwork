//
//  HSDownloadManager.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2017/3/30.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "HSDownloadManager.h"

@interface HSDownloadManager() <NSCopying, NSURLSessionDelegate>

@property (nonatomic, strong) NSMutableDictionary *tasks;/** 保存所有任务(注：用下载地址md5后作为key) */
@property (nonatomic, strong) NSMutableDictionary *sessionModels;   /** 保存所有下载相关信息 */

@end


@implementation HSDownloadManager

static HSDownloadManager *_downloadManager;

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _downloadManager = [[self alloc] init];
    });
    
    return _downloadManager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _downloadManager = [super allocWithZone:zone];
    });
    
    return _downloadManager;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone
{
    return _downloadManager;
}

#pragma mark - 下载方法
- (NSMutableDictionary *)tasks
{
    if (!_tasks) {
        _tasks = [NSMutableDictionary dictionary];
    }
    return _tasks;
}

- (NSMutableDictionary *)sessionModels
{
    if (!_sessionModels) {
        _sessionModels = [NSMutableDictionary dictionary];
    }
    return _sessionModels;
}

/**
 *  创建缓存目录文件
 */
- (void)createCacheDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:HSCachesDirectory]) {
        [fileManager createDirectoryAtPath:HSCachesDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
    }
}

/*
 *  更改url的各种回调（场景：在输入界面开启了下载，但回调信息需要用在列表上）
 *
 *  @param url           下载地址
 *  @param progressBlock 回调下载进度
 *  @param stateBlock    下载状态
 */
- (void)setupUrl:(__kindof NSObject<CJDownloadRecordModelProtocol> *)url progressBlock:(void(^)(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress))progressBlock state:(void(^)(CJFileDownloadState state, NSError * _Nullable error))stateBlock
{
    HSSessionModel *sessionModel = [self getSessionModelFromUrl:url];
    
    sessionModel.progressBlock = progressBlock;
    sessionModel.stateBlock = stateBlock;
}

/**
 *  开启或暂停任务下载资源
 */
- (void)downloadOrPause:(__kindof NSObject<CJDownloadRecordModelProtocol> *)url progressBlock:(void(^)(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress))progressBlock state:(void(^)(CJFileDownloadState state, NSError * _Nullable error))stateBlock
{
    if (!url) {
        NSLog(@"要下载的文件地址不能为空");
        return;
    }
    
    if ([CQDownloadCacheUtil isCompletion:url]) {
        stateBlock(CJFileDownloadStateSuccess, nil);
        NSLog(@"----该资源已下载完成");
        return;
    }
    
    // 暂停
    NSString *fileName = url.saveWithFileName;
    if ([self.tasks valueForKey:fileName]) {
        [self handle:url]; // 如果是之前的任务，则执行继续或暂停
        
        return;
    }
    
    // 创建缓存目录文件
    [self createCacheDirectory];
    
   NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
    
    // 创建流
    NSOutputStream *stream = [NSOutputStream outputStreamToFileAtPath:url.saveToAbsPath append:YES];
    
    // 创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url.url]];
    
    // 设置请求头
    NSString *range = [NSString stringWithFormat:@"bytes=%zd-", url.hasDownloadedLength];
    [request setValue:range forHTTPHeaderField:@"Range"];
    
    // 创建一个Data任务
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request];
    NSUInteger taskIdentifier = arc4random() % ((arc4random() % 10000 + arc4random() % 10000));
    [task setValue:@(taskIdentifier) forKeyPath:@"taskIdentifier"];

    // 保存任务
    [self.tasks setValue:task forKey:fileName];

    HSSessionModel *sessionModel = [[HSSessionModel alloc] init];
    sessionModel.url = url;
    sessionModel.progressBlock = progressBlock;
    sessionModel.stateBlock = stateBlock;
    sessionModel.stream = stream;
    [self.sessionModels setValue:sessionModel forKey:@(task.taskIdentifier).stringValue];
    
    [self start:url];
}


- (void)handle:(__kindof NSObject<CJDownloadRecordModelProtocol> *)url
{
    NSURLSessionDataTask *task = [self getTask:url];
    if (task.state == NSURLSessionTaskStateRunning) {
        [self pause:url];
    } else {
        [self start:url];
    }
}

/**
 *  开始下载
 */
- (void)start:(__kindof NSObject<CJDownloadRecordModelProtocol> *)url
{
    NSURLSessionDataTask *task = [self getTask:url];
    [task resume];

    HSSessionModel *sessionModel = [self getSessionModel:task.taskIdentifier];
    [sessionModel updateDownloadState:CJFileDownloadStateDownloading error:nil];
}

/**
 *  暂停下载
 */
- (void)pause:(__kindof NSObject<CJDownloadRecordModelProtocol> *)url
{
    NSURLSessionDataTask *task = [self getTask:url];
    [task suspend];

    HSSessionModel *sessionModel = [self getSessionModel:task.taskIdentifier];
    [sessionModel updateDownloadState:CJFileDownloadStatePause error:nil];
}

/**
 *  根据url获得对应的下载任务
 */
- (NSURLSessionDataTask *)getTask:(__kindof NSObject<CJDownloadRecordModelProtocol> *)url
{
    return (NSURLSessionDataTask *)[self.tasks valueForKey:url.saveWithFileName];
}

/**
 *  根据url获取对应的下载信息模型
 */
- (HSSessionModel *)getSessionModel:(NSUInteger)taskIdentifier
{
    return (HSSessionModel *)[self.sessionModels valueForKey:@(taskIdentifier).stringValue];
}

/**
 *  根据url获得对应的下载任务
 */
- (HSSessionModel *)getSessionModelFromUrl:(__kindof NSObject<CJDownloadRecordModelProtocol> *)url {
    NSURLSessionDataTask *task = [self getTask:url];
    return [self getSessionModel:task.taskIdentifier];
}

/**
 *  判断该文件的下载状态
 */
- (CJFileDownloadState)downloadStateForUrl:(__kindof NSObject<CJDownloadRecordModelProtocol> *)url {
    HSSessionModel *sessionModel = [self getSessionModelFromUrl:url];
    if (sessionModel != nil) {
        return sessionModel.downloadState;
    } else {
        // 下载完成的就不在task里了，就只能通过 progress 来判断了
        CGFloat progress = [CQDownloadCacheUtil progress:url];
        if (progress == 1.0) {
            return CJFileDownloadStateSuccess;
        } else if (progress > 0.0) {
            return CJFileDownloadStatePause;
        } else {
            return CJFileDownloadStateReady;
        }
    }
}

#pragma mark - 删除
/**
 *  删除该资源
 */
- (void)deleteFile:(__kindof NSObject<CJDownloadRecordModelProtocol> *)url
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = url.saveToAbsPath;
    NSString *fileName = url.saveWithFileName;
    if ([fileManager fileExistsAtPath:filePath]) {
        // 删除沙盒中的资源
        [fileManager removeItemAtPath:filePath error:nil];
        // 删除任务
        [self.tasks removeObjectForKey:fileName];
        [self.sessionModels removeObjectForKey:@([self getTask:url].taskIdentifier).stringValue];
        // 删除资源总长度
        [CQDownloadCacheUtil deleteRecordByFileName:fileName];
    }
}


/**
 *  清空所有下载资源
 */
- (void)deleteAllFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:HSCachesDirectory]) {
        // 删除沙盒中所有资源
        [fileManager removeItemAtPath:HSCachesDirectory error:nil];
        // 删除任务
        [[self.tasks allValues] makeObjectsPerformSelector:@selector(cancel)];
        [self.tasks removeAllObjects];
        
        for (HSSessionModel *sessionModel in [self.sessionModels allValues]) {
            [sessionModel.stream close];
        }
        [self.sessionModels removeAllObjects];
        
        // 删除资源总长度
        [CQDownloadCacheUtil deleteAllRecord];
    }
}



#pragma mark - 代理
#pragma mark NSURLSessionDataDelegate
/**
 * 接收到响应
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSHTTPURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    
    HSSessionModel *sessionModel = [self getSessionModel:dataTask.taskIdentifier];
    
    // 打开流
    [sessionModel.stream open];
    
    // 获得服务器这次请求 返回数据的总长度
    NSString *contentLengthStr = response.allHeaderFields[@"Content-Length"];
    if (contentLengthStr == nil) {
        NSLog(@"No Content-Length header returned from the server.");
        // 在这里处理没有 Content-Length 的情况
        completionHandler(NSURLSessionResponseCancel);
        return;
    }
    NSUInteger receivedSize = sessionModel.url.hasDownloadedLength;
    NSInteger totalLength = [contentLengthStr integerValue] + receivedSize;
    sessionModel.totalLength = totalLength;
    
    // 存储总长度
    [CQDownloadCacheUtil process_updateRecord:sessionModel.url withTotalLength:totalLength]; // 请记得有先调用 process_addRecord
    
    // 接收这个请求，允许接收服务器的数据
    completionHandler(NSURLSessionResponseAllow);
}



/**
 * 接收到服务器返回的数据
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    HSSessionModel *sessionModel = [self getSessionModel:dataTask.taskIdentifier];
    
    // 写入数据
    [sessionModel.stream write:data.bytes maxLength:data.length];
    
    // 下载进度
    NSUInteger receivedSize = sessionModel.url.hasDownloadedLength;
    NSUInteger expectedSize = sessionModel.totalLength;
   
    CGFloat progress = 1.0 * receivedSize / expectedSize;

    sessionModel.progressBlock(receivedSize, expectedSize, progress);
}

/**
 * 请求完毕（成功|失败）
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    HSSessionModel *sessionModel = [self getSessionModel:task.taskIdentifier];
    if (!sessionModel) {
        return;
    }
    
    if ([CQDownloadCacheUtil isCompletion:sessionModel.url]) {
        [sessionModel updateDownloadState:CJFileDownloadStateSuccess error:nil];    //下载完成
    } else if (error){
        [sessionModel updateDownloadState:CJFileDownloadStateFailure error:error];   //下载失败
    }
    
    // 关闭流
    [sessionModel.stream close];
    sessionModel.stream = nil;
    
    // 清除任务
    [self.tasks removeObjectForKey:sessionModel.url.saveWithFileName];
    [self.sessionModels removeObjectForKey:@(task.taskIdentifier).stringValue];
}

@end
