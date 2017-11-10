//
//  MQLResumeManager.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2017/3/30.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MQLResumeManager : NSObject

/**
 *  创建断点续传管理对象，启动下载请求
 *
 *  @param url          文件资源地址
 *  @param targetPath   文件存放路径
 *  @param success      文件下载成功的回调块
 *  @param failure      文件下载失败的回调块
 *  @param progress     文件下载进度的回调块
 *
 *  @return 断点续传管理对象
 *
 */
+ (MQLResumeManager*)resumeManagerWithURL:(NSURL*)url
                               targetPath:(NSString *)targetPath
                                  success:(void (^)())success
                                  failure:(void (^)(NSError *error))failure
                                 progress:(void (^)(long long totalReceivedContentLength, long long totalContentLength))progress;

/**
 *  启动断点续传下载请求
 */
- (void)start;

/**
 *  取消断点续传下载请求
 */
- (void)cancel;

/**
 *  获取文件大小
 *  @param path 文件路径
 *  @return 文件大小
 *
 */
- (long long)fileSizeForPath:(NSString *)path;


@end
