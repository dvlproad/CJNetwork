//
//  CQDownloadCacheUtil.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2017/3/30.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "CQDownloadCacheUtil.h"

@implementation CQDownloadCacheUtil



#pragma mark - 下载记录的增删改查
/*
 *  添加记录
 *
 *  @param record   要添加的记录
 */
+ (void)addRecord:(__kindof NSObject<CJDownloadRecordModelProtocol> *)record withTotalLength:(NSInteger)totalLength {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:HSTotalLengthFullpath];
    if (dict == nil) dict = [NSMutableDictionary dictionary];
    dict[record.saveWithFileName] = @{
        @"kTotalLength": @(totalLength),
    };
    [dict writeToFile:HSTotalLengthFullpath atomically:YES];
}

/*
 *  删除指定记录
 *
 *  @param record   要删除的记录的文件名（目前以文件名为数据库中的主键）
 */
+ (void)deleteRecordByFileName:(NSString *)fileName {
    // 删除资源总长度
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:HSTotalLengthFullpath]) {
        NSMutableDictionary *allDict = [NSMutableDictionary dictionaryWithContentsOfFile:HSTotalLengthFullpath];
        [allDict removeObjectForKey:fileName];
        [allDict writeToFile:HSTotalLengthFullpath atomically:YES];
    }
}

/*
 *  删除所有记录
 */
+ (void)deleteAllRecord {
    // 直接删除整个文件，而不对文件内容一个删了
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:HSTotalLengthFullpath]) {
        [fileManager removeItemAtPath:HSTotalLengthFullpath error:nil];
    }
}

/*
 *  获取所有记录
 */
+ (NSDictionary *)getAllRecord {
    NSDictionary *allDict = [NSDictionary dictionaryWithContentsOfFile:HSTotalLengthFullpath];
    return allDict;
}


/*
 *  获取指定记录的大小（有些方式在请求的时候能通过 content-lenght 获取到文件大小）
 *
 *  @param record   要删除的记录的文件名（目前以文件名为数据库中的主键）
 */
+ (NSInteger)getTotalLength:(__kindof NSObject<CJDownloadRecordModelProtocol> *)url
{
    NSDictionary *allDict = [NSDictionary dictionaryWithContentsOfFile:HSTotalLengthFullpath];
    NSDictionary *dataDict = allDict[url.saveWithFileName];
    NSInteger totalLength = [dataDict[@"kTotalLength"] integerValue];
    return totalLength;
}




/*
 *  判断该文件是否下载完成
 *
 *  @param record   要判断的记录
 *
 *  @return 是否完成
 */
+ (BOOL)isCompletion:(__kindof NSObject<CJDownloadRecordModelProtocol> *)url
{
    if ([self getTotalLength:url] && url.hasDownloadedLength == [self getTotalLength:url]) {
        return YES;
    }
    return NO;
}

/*
 *  查询该资源的下载进度值
 *
 *  @param record   要查询的记录
 *
 *  @return 当前下载进度值
 */
+ (CGFloat)progress:(__kindof NSObject<CJDownloadRecordModelProtocol> *)url
{
    return [self getTotalLength:url] == 0 ? 0.0 : 1.0 * url.hasDownloadedLength /  [self getTotalLength:url];
}

/*
 *  已下载完成的资源的本地绝对路径
 *
 *  @param url 下载地址
 *
 *  @return 已下载完成的资源的本地绝对路径
 */
+ (NSString *)fileLocalAbsPathForUrl:(__kindof NSObject<CJDownloadRecordModelProtocol> *)url {
    NSString *filePath = url.saveToAbsPath;
    return filePath;
}

@end
