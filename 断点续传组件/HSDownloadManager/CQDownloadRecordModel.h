//
//  CQDownloadRecordModel.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2017/3/30.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CJDownloadEnumUtil.h"

// 缓存主目录
#define HSCachesDirectory [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"HSCache"]

// 存储文件总长度的文件路径（caches）
#define HSTotalLengthFullpath [HSCachesDirectory stringByAppendingPathComponent:@"totalLength.plist"]



NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CJFileDownloadMethod) {
    CJFileDownloadMethodUnknown = 0,
    CJFileDownloadMethodProgress = 1,       // 有进度（有 Content-Length 的时候）
    CJFileDownloadMethodOneOff = 2,         // 一次性下载完（没有 Content-Length 的时候）
};

@protocol CJDownloadRecordModelProtocol <NSObject, NSCoding>

@required
@property (nonatomic, copy) NSString *url;;                                 /**< 下载地址 */
@property (nonatomic, assign) CJFileDownloadState downloadState;  /**< 下载状态 */
@property (nonatomic, assign) CJFileDownloadMethod downloadMethod;  /**< 下载方法 */

//#pragma mark - 状态变化
//@property (nullable, nonatomic, copy) void (^uploadProgress)(NSProgress * _Nonnull progress);

/// 以什么文件名保存
@required
- (NSString *)saveWithFileName;

// 文件的存放路径（caches）
@required
- (NSString *)saveToAbsPath;

// 文件的已下载长度
@required
- (NSInteger)hasDownloadedLength;

@end


@interface CQDownloadRecordModel : NSObject<CJDownloadRecordModelProtocol> {
    
}
@property (nonatomic, copy, readonly) NSString *createId; // 唯一标识，使用场景多次重复下载的区分
@property (nonatomic, copy) NSString *name;


//@property (nonatomic, copy) void(^stateBlock)(CJFileDownloadState state, NSError * _Nullable error);
//
////void updateDownloadState(CJFileDownloadState downloadState, NSError * _Nullable error);
//- (void)updateDownloadState:(CJFileDownloadState)downloadState error:(NSError * _Nullable)error;

#pragma mark - 自定义初始化
// 自定义初始化方法
//- (instancetype)initWithURL:(NSString *)url NS_DESIGNATED_INITIALIZER;
//+ (instancetype)new NS_UNAVAILABLE;
//- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
