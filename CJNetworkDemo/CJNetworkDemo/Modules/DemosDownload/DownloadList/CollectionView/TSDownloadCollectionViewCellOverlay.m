//
//  TSDownloadCollectionViewCellOverlay.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2017/3/31.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "TSDownloadCollectionViewCellOverlay.h"
#import <CQVideoUrlAnalyze_Swift/CQVideoUrlAnalyze_Swift-Swift.h>
#import <CJNetwork_Swift/CJNetwork_Swift-Swift.h>
#import <CQDemoKit/CQTSSandboxPathUtil.h>

@interface TSDownloadCollectionViewCellOverlay ()

@property (nonatomic, strong) UIProgressView *progressView;  /** 进度UIProgressView */
@property (nonatomic, strong) UILabel *progressLabel;        /** 进度UILabel */
@property (nonatomic, strong) UIButton *downloadButton;      /** 下载按钮 */
@property (nonatomic, strong) UIButton *deleteButton;        /**< 删除按钮 */

//@property (nonatomic, strong) UILabel *downloadUrlLabel;     /** 下载文件的Url */

@property (nonatomic, copy) void (^stateChangeBlock)(CJFileDownloadState downloadState, NSString * _Nullable localAbsPath);

@end


@implementation TSDownloadCollectionViewCellOverlay

- (instancetype)initWithStateChangeBlock:(void (^)(CJFileDownloadState downloadState, NSString * _Nullable localAbsPath))stateChangeBlock {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.stateChangeBlock = stateChangeBlock;
        
        [self setupViews];
        
        [self commonInit];
    }
    return self;
}


- (void)commonInit {
//    self.downloadProgress = 0.0;
//    self.deleteButton.hidden = YES;
    [self.downloadButton addTarget:self action:@selector(downloadButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteButton addTarget:self action:@selector(deleteButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupViews {
    // 初始化下载进度
    UIView *parentView = self;
    
    // 创建并配置 UILabel
    self.progressLabel = [[UILabel alloc] init];
    self.progressLabel.text = @"0%";
    self.progressLabel.textAlignment = NSTextAlignmentCenter;
    [parentView addSubview:self.progressLabel];
    
    // 创建并配置 UIProgressView
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressView.progress = 0.0;
    [parentView addSubview:self.progressView];
    
    // 创建并配置 下载按钮
    self.downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.downloadButton setTitle:NSLocalizedStringFromTable(@"下载", @"LocalizableDownloader", nil) forState:UIControlStateNormal];
    [self.downloadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.downloadButton setBackgroundColor:[UIColor redColor]];
    [self.downloadButton addTarget:self action:@selector(downloadButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [parentView addSubview:self.downloadButton];
    
    // 创建并配置 删除按钮
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.deleteButton setTitle:NSLocalizedStringFromTable(@"删除", @"LocalizableDownloader", nil) forState:UIControlStateNormal];
    [self.deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.deleteButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [self.deleteButton setBackgroundColor:[UIColor orangeColor]];
    [self.deleteButton addTarget:self action:@selector(deleteButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [parentView addSubview:self.deleteButton];
    
    // 创建并配置 下载 URL 标签
    self.downloadUrlLabel = [[UILabel alloc] init];
    self.downloadUrlLabel.text = @"https://www.example.com/download/file.zip";  // 设置下载地址
    self.downloadUrlLabel.textAlignment = NSTextAlignmentLeft;
    self.downloadUrlLabel.numberOfLines = 0;
    self.downloadUrlLabel.font = [UIFont systemFontOfSize:10.0];
    [parentView addSubview:self.downloadUrlLabel];
    
    // 设置 Auto Layout 约束
    [self setupConstraints];
}

// 设置 Auto Layout 约束
- (void)setupConstraints {
    UIView *parentView = self;
    
    CGFloat headerPadding = 4.0;
    CGFloat bottomPadding = 4.0;
    CGFloat headerHeight = 30.0;
    CGFloat bottomHeight = 30.0;
    
    self.progressView.translatesAutoresizingMaskIntoConstraints = NO;
    self.progressLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.downloadButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.deleteButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.downloadUrlLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    // 删除按钮约束
    [NSLayoutConstraint activateConstraints:@[
        [self.deleteButton.topAnchor constraintEqualToAnchor:parentView.topAnchor constant:headerPadding],
        [self.deleteButton.trailingAnchor constraintEqualToAnchor:parentView.trailingAnchor constant:-10],
        [self.deleteButton.widthAnchor constraintEqualToConstant:60],
        [self.deleteButton.heightAnchor constraintEqualToConstant:headerHeight]
    ]];
        
    // 下载按钮约束
    [NSLayoutConstraint activateConstraints:@[
        [self.downloadButton.centerXAnchor constraintEqualToAnchor:parentView.centerXAnchor constant:0],
        [self.downloadButton.centerYAnchor constraintEqualToAnchor:parentView.centerYAnchor constant:-20],
        [self.downloadButton.widthAnchor constraintEqualToConstant:60],
        [self.downloadButton.heightAnchor constraintEqualToConstant:headerHeight]
    ]];
    
    // 进度标签约束
    [NSLayoutConstraint activateConstraints:@[
        [self.progressLabel.trailingAnchor constraintEqualToAnchor:parentView.trailingAnchor constant:-10],
        [self.progressLabel.widthAnchor constraintEqualToConstant:44],
        [self.progressLabel.topAnchor constraintEqualToAnchor:self.downloadButton.bottomAnchor constant:0],
        [self.progressLabel.heightAnchor constraintEqualToConstant:headerHeight]
    ]];
    
    // 进度条约束
    [NSLayoutConstraint activateConstraints:@[
        [self.progressView.leadingAnchor constraintEqualToAnchor:parentView.leadingAnchor constant:0],
        [self.progressView.trailingAnchor constraintEqualToAnchor:self.progressLabel.leadingAnchor constant:-20],
        [self.progressView.centerYAnchor constraintEqualToAnchor:self.progressLabel.centerYAnchor constant:0],
        [self.progressView.heightAnchor constraintEqualToConstant:2]
    ]];
    
    // 下载 URL 标签约束
    [NSLayoutConstraint activateConstraints:@[
        [self.downloadUrlLabel.bottomAnchor constraintEqualToAnchor:parentView.bottomAnchor constant:-bottomPadding],
        [self.downloadUrlLabel.heightAnchor constraintEqualToConstant:bottomHeight],
        [self.downloadUrlLabel.leadingAnchor constraintEqualToAnchor:parentView.leadingAnchor constant:20],
        [self.downloadUrlLabel.trailingAnchor constraintEqualToAnchor:parentView.trailingAnchor constant:-20]
    ]];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self initData];
}

#pragma mark Setter
- (void)setDownloadModel:(NSObject<CJDownloadRecordModelProtocol> *)downloadModel {
    _downloadModel = downloadModel;
    
    //self.downloadUrlLabel.text = downloadModel.name;
    
    [self __setupDownloadBlock];
}

#pragma mark 刷新数据
- (void)initData {
    // 获取当前下载状态
    CJFileDownloadState downloadState;
    CJFileDownloadMethod downloadMethod = [CQDownloadCacheUtil getDownloadMethodForRecord:self.downloadModel];
    if (downloadMethod == CJFileDownloadMethodProgress) {
        downloadState = [[HSDownloadManager sharedInstance] downloadStateForUrl:self.downloadModel];
        
        CGFloat progress = [CQDownloadCacheUtil progress:self.downloadModel];
        self.progressLabel.text = [NSString stringWithFormat:@"%.f%%", progress * 100];
        self.progressView.progress = progress;
        
    } else if (downloadMethod == CJFileDownloadMethodOneOff) {
        downloadState = [CQDownloadCacheUtil nototal_downloadState:self.downloadModel];
        
        
    } else {
        downloadState = CJFileDownloadStateUnknown;
    }
    
    [self __changeState:downloadState];
}

- (void)__changeState:(CJFileDownloadState)state {
    _currentDownloadState = state;
    
    NSString *title = [CJDownloadEnumUtil nextStateTextForState:state];
    [self.downloadButton setTitle:title forState:UIControlStateNormal];
    
    BOOL isCompleted = state == CJFileDownloadStateSuccess;
    self.deleteButton.hidden = state == CJFileDownloadStateReady;
    self.downloadButton.hidden = isCompleted;
    
    self.progressLabel.hidden = isCompleted || state == CJFileDownloadStateReady;
    self.progressView.hidden = isCompleted || state == CJFileDownloadStateReady;
    
    NSString *localAbsPath = [CQDownloadCacheUtil fileLocalAbsPathForUrl:self.downloadModel];
    self.stateChangeBlock(state, localAbsPath);
}


/** 下载文件 */
- (void)downloadButtonTapped:(UIButton *)button {
    [self startDownload];
}

- (void)__setupDownloadBlock {
    [self initData];
    
    CJFileDownloadMethod downloadMethod = [CQDownloadCacheUtil getDownloadMethodForRecord:self.downloadModel];
    if (downloadMethod == CJFileDownloadMethodProgress) {
        [[HSDownloadManager sharedInstance] setupUrl:self.downloadModel progressBlock:^(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *progressValue = [NSString stringWithFormat:@"%.f%%", progress * 100];
                NSString *message = [NSString stringWithFormat:@"3当前下载进度:=========%@", progressValue];
                [self __showResponseLogMessage:message];
                self.progressLabel.text = progressValue;
                self.progressView.progress = progress;
            });
        } state:^(CJFileDownloadState state, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self __changeState:state];
            });
        }];
    } else if (downloadMethod == CJFileDownloadMethodOneOff) {
        
    } else {
        NSAssert(downloadMethod == CJFileDownloadMethodUnknown, @"下载方式不能未知，不然 CJFileDownloadMethodProgress 时候的下载会引起点击获取视频后，跳转到已解析页面上的回调没刷新");
    }
}

- (void)startDownload {
    [[HSDownloadManager sharedInstance] downloadOrPause:self.downloadModel progressBlock:^(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *progressValue = [NSString stringWithFormat:@"%.f%%", progress * 100];
            NSString *message = [NSString stringWithFormat:@"2当前下载进度:=========%@", progressValue];
            [self __showResponseLogMessage:message];
            self.progressLabel.text = progressValue;
            self.progressView.progress = progress;
        });
    } state:^(CJFileDownloadState state, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self __changeState:state];
        });
    }];
}

- (void)local_analyzeTiktokShortenedUrl:(NSString *)shortenedUrl {
    shortenedUrl = _downloadModel.url;
    
    [TikTokService getActualVideoUrlFromShortenedUrl:shortenedUrl success:^(NSString * _Nonnull videoUrl) {
        dispatch_async(dispatch_get_main_queue(),^{
            [TikTokService downloadAccessRestrictedDataFromActualVideoUrl:videoUrl saveToLocalURLGetter:^NSURL * _Nonnull(NSString * _Nonnull videoFileExtension) {
                NSString *saveToAbsPath = self.downloadModel.saveToAbsPath;
                return [NSURL fileURLWithPath:saveToAbsPath];
                
            } success:^(NSURL * _Nonnull cacheURL) {
                NSString *message = [NSString stringWithFormat:@"解析并且下载成功:\n视频短链=%@\n视频地址=%@\n保存位置=%@", shortenedUrl, videoUrl, cacheURL.absoluteString];
                [self __showResponseLogMessage:message];
            } failure:^(NSError * _Nonnull error) {
                [self __showResponseLogMessage:error.localizedDescription];
            }];
        });
    } failure:^(NSError * _Nonnull error) {
        [self __showResponseLogMessage:error.localizedDescription];
    }];
}

/// 是否现在完成
- (BOOL)isDownloadComplete {
    return [CQDownloadCacheUtil isCompletion:self.downloadModel];
}


/** 删除文件 */
- (void)deleteButtonTapped:(UIButton *)sender {
    if (self.customDeleteHandler != nil) {
        self.customDeleteHandler();
        return;
    }
    
    
    [[HSDownloadManager sharedInstance] deleteFile:self.downloadModel];
    CGFloat progress = [CQDownloadCacheUtil progress:self.downloadModel];
    self.progressLabel.text = [NSString stringWithFormat:@"%.f%%", progress * 100];
    self.progressView.progress = progress;

    [self __changeState:CJFileDownloadStateReady];
}


/// 显示返回结果log
- (void)__showResponseLogMessage:(NSString *)message {
    //[CJUIKitToastUtil showMessage:message];
//    [CJLogViewWindow appendObject:message];
    NSLog(@"%@", message);
}


@end
