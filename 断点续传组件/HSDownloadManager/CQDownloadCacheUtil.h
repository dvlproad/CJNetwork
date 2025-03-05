//
//  CQDownloadCacheUtil.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2017/3/30.
//  Copyright © 2017年 dvlproad. All rights reserved.
//
//  将下载记录的处理提取为 CQDownloadCacheUtil ，以备后续处理不同下载方式的下载记录

#import <UIKit/UIKit.h>
#import "CQDownloadRecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CQDownloadCacheUtil : NSObject



#pragma mark - 下载记录的增删改查
/*
 *  删除指定记录
 *
 *  @param record   要删除的记录的文件名（目前以文件名为数据库中的主键）
 */
+ (void)deleteRecordByFileName:(NSString *)fileName;

/*
 *  删除所有记录
 */
+ (void)deleteAllRecord;

/*
 *  获取所有记录
 */
+ (NSDictionary *)getAllRecord;

/*
 *  获取指定记录使用的下载方式
 *
 *  @param record   要查询的记录
 */
+ (CJFileDownloadMethod)getDownloadMethodForRecord:(__kindof NSObject<CJDownloadRecordModelProtocol> *)record;



#pragma mark - 无 Content-Length 则没有下载进度，即下载是一次性下载的
/*
 *  添加记录
 *
 *  @param record   要添加的记录
 */
+ (void)nototal_addRecord:(__kindof NSObject<CJDownloadRecordModelProtocol> *)record withDownloadState:(CJFileDownloadState)downloadState;

/*
 *  判断该文件的下载状态
 *
 *  @param record   要判断的记录
 *
 *  @return 下载状态
 */
+ (CJFileDownloadState)nototal_downloadState:(__kindof NSObject<CJDownloadRecordModelProtocol> *)url;


#pragma mark - 有 Content-Length 才有下载进度
/*
 *  添加记录
 *
 *  @param record   要添加的记录
 */
+ (void)addRecord:(__kindof NSObject<CJDownloadRecordModelProtocol> *)record withTotalLength:(NSInteger)totalLength;

/*
 *  获取指定记录的大小（有些方式在请求的时候能通过 content-lenght 获取到文件大小）
 *
 *  @param record   要删除的记录的文件名（目前以文件名为数据库中的主键）
 */
+ (NSInteger)getTotalLength:(__kindof NSObject<CJDownloadRecordModelProtocol> *)url;

/*
 *  判断该文件是否下载完成
 *
 *  @param record   要判断的记录
 *
 *  @return 是否完成
 */
+ (BOOL)isCompletion:(__kindof NSObject<CJDownloadRecordModelProtocol> *)url;

/*
 *  查询该资源的下载进度值
 *
 *  @param record   要查询的记录
 *
 *  @return 当前下载进度值
 */
+ (CGFloat)progress:(__kindof NSObject<CJDownloadRecordModelProtocol> *)url;

/*
 *  已下载完成的资源的本地绝对路径
 *
 *  @param url 下载地址
 *
 *  @return 已下载完成的资源的本地绝对路径
 */
+ (NSString *)fileLocalAbsPathForUrl:(__kindof NSObject<CJDownloadRecordModelProtocol> *)url;



@end

NS_ASSUME_NONNULL_END
