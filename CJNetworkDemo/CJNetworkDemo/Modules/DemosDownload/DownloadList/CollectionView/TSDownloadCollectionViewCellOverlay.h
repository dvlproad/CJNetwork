//
//  TSDownloadCollectionViewCellOverlay.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2017/3/31.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSDownloadManager.h"
#import "CQDownloadRecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TSDownloadCollectionViewCellOverlay: UIView {
    
}
@property (nonatomic, copy) NSObject<CJDownloadRecordModelProtocol> *downloadUrl;
@property (nonatomic, strong) UILabel *downloadUrlLabel;     /** 下载文件的Url */

@property (nonatomic, assign, readonly) CJFileDownloadState currentDownloadState;

@property (nonatomic, copy) void(^ _Nullable customDeleteHandler)(void); // 自定义的删除事件（有时候下载数据不删除，但是关联的数据删除，其就不会展示）

#pragma mark - Init
/*
 *  初始化文件上传时候的上传模型
 *
 *  @param stateChangeBlock     文件状态发生变化的事件（完成则有localAbsPath才能显示内容、未完成则不显示）
 */
- (instancetype)initWithStateChangeBlock:(void (^)(CJFileDownloadState downloadState, NSString * _Nullable localAbsPath))stateChangeBlock NS_DESIGNATED_INITIALIZER;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil NS_UNAVAILABLE;

#pragma mark - Event
- (void)startDownload;
- (void)setupDownloadBlock;

@end

NS_ASSUME_NONNULL_END
