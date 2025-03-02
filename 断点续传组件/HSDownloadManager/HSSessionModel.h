//
//  HSNSURLSession.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2017/3/30.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CQTSBaseDownloadViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HSSessionModel : NSObject {
    
}

/** 流 */
@property (nonatomic, strong) NSOutputStream *stream;

/** 下载地址 */
@property (nonatomic, copy) NSString *url;

/** 获得服务器这次请求 返回数据的总长度 */
@property (nonatomic, assign) NSInteger totalLength;

/** 下载进度 */
@property (nonatomic, copy) void(^progressBlock)(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress);


/** 下载状态 */
@property (nonatomic, assign, readonly) CJFileDownloadState downloadState;
@property (nonatomic, copy) void(^stateBlock)(CJFileDownloadState state, NSError * _Nullable error);

//void updateDownloadState(CJFileDownloadState downloadState, NSError * _Nullable error);
- (void)updateDownloadState:(CJFileDownloadState)downloadState error:(NSError * _Nullable)error;

@end

NS_ASSUME_NONNULL_END
