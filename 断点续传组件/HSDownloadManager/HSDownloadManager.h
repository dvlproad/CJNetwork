//
//  HSDownloadManager.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2017/3/30.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CQDownloadRecordModel.h"
#import "HSSessionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HSDownloadManager : NSObject

/**
 *  单例
 *
 *  @return 返回单例对象
 */
+ (instancetype)sharedInstance;

/*
 *  开启或暂停任务下载资源
 *
 *  @param record        下载地址
 *  @param progressBlock 回调下载进度
 *  @param stateBlock    下载状态
 */
- (void)downloadOrPause:(__kindof NSObject<CJDownloadRecordModelProtocol> *)record progressBlock:(void(^)(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress))progressBlock state:(void(^)(CJFileDownloadState state, NSError * _Nullable error))stateBlock;

/*
 *  更改url的各种回调（场景：在输入界面开启了下载，但回调信息需要用在列表上）
 *
 *  @param record        下载地址
 *  @param progressBlock 回调下载进度
 *  @param stateBlock    下载状态
 */
- (void)setupUrl:(__kindof NSObject<CJDownloadRecordModelProtocol> *)record progressBlock:(void(^)(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress))progressBlock state:(void(^)(CJFileDownloadState state, NSError * _Nullable error))stateBlock;

/**
 *  查询该资源的下载进度值
 *
 *  @param record 下载地址
 *
 *  @return 返回下载进度值
 */
- (CGFloat)progress:(__kindof NSObject<CJDownloadRecordModelProtocol> *)record;

/**
 *  获取该资源总大小
 *
 *  @param record 下载地址
 *
 *  @return 资源总大小
 */
- (NSInteger)fileTotalLength:(__kindof NSObject<CJDownloadRecordModelProtocol> *)record;

/**
 *  判断该文件的下载状态
 */
- (CJFileDownloadState)downloadStateForUrl:(__kindof NSObject<CJDownloadRecordModelProtocol> *)record;
/**
 *  判断该资源是否下载完成
 *
 *  @param record 下载地址
 *
 *  @return YES: 完成
 */
- (BOOL)isCompletion:(__kindof NSObject<CJDownloadRecordModelProtocol> *)record;

/**
 *  已下载完成的资源的本地绝对路径
 *
 *  @param url 下载地址
 *
 *  @return 已下载完成的资源的本地绝对路径
 */
- (NSString *)fileLocalAbsPathForUrl:(__kindof NSObject<CJDownloadRecordModelProtocol> *)url;

/**
 *  删除该资源
 *
 *  @param record 下载地址
 */
- (void)deleteFile:(__kindof NSObject<CJDownloadRecordModelProtocol> *)record;

/**
 *  清空所有下载资源
 */
- (void)deleteAllFile;

@end

NS_ASSUME_NONNULL_END
