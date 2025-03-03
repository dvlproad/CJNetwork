//
//  TSDownloadTableViewCellOverlay.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2017/3/31.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "TSDownloadTableViewCellOverlay.h"

@interface TSDownloadTableViewCellOverlay ()

@property (nonatomic, strong) UIProgressView *progressView;  /** 进度UIProgressView */
@property (nonatomic, strong) UILabel *progressLabel;        /** 进度UILabel */
@property (nonatomic, strong) UIButton *downloadButton;      /** 下载按钮 */
@property (nonatomic, strong) UIButton *deleteButton;        /**< 删除按钮 */

//@property (nonatomic, strong) UILabel *downloadUrlLabel;     /** 下载文件的Url */

@property (nonatomic, copy) void (^stateChangeBlock)(CJFileDownloadState downloadState, NSString * _Nullable localAbsPath);

@end


@implementation TSDownloadTableViewCellOverlay

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
    [self.downloadButton setTitle:@"下载" forState:UIControlStateNormal];
    [self.downloadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.downloadButton setBackgroundColor:[UIColor redColor]];
    [self.downloadButton addTarget:self action:@selector(downloadButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [parentView addSubview:self.downloadButton];
    
    // 创建并配置 删除按钮
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.deleteButton setTitle:@"删除" forState:UIControlStateNormal];
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
        [self.downloadButton.trailingAnchor constraintEqualToAnchor:self.deleteButton.leadingAnchor constant:-10],
        [self.downloadButton.widthAnchor constraintEqualToConstant:60],
        [self.downloadButton.topAnchor constraintEqualToAnchor:self.deleteButton.topAnchor constant:0],
        [self.downloadButton.heightAnchor constraintEqualToConstant:headerHeight]
    ]];
    
    // 进度标签约束
    [NSLayoutConstraint activateConstraints:@[
        [self.progressLabel.trailingAnchor constraintEqualToAnchor:self.downloadButton.leadingAnchor constant:-10],
        [self.progressLabel.widthAnchor constraintEqualToConstant:44],
        [self.progressLabel.topAnchor constraintEqualToAnchor:self.downloadButton.topAnchor constant:0],
        [self.progressLabel.heightAnchor constraintEqualToConstant:headerHeight]
    ]];
    
    // 进度条约束
    [NSLayoutConstraint activateConstraints:@[
        [self.progressView.leadingAnchor constraintEqualToAnchor:parentView.leadingAnchor constant:20],
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
- (void)setDownloadUrl:(NSString *)downloadUrl {
    _downloadUrl = downloadUrl;
    
    [self initData];
}

#pragma mark 刷新数据
- (void)initData {
    CGFloat progress = [[HSDownloadManager sharedInstance] progress:self.downloadUrl];
    self.progressLabel.text = [NSString stringWithFormat:@"%.f%%", progress * 100];
    self.progressView.progress = progress;
    if (progress == 1.0) {
        [self __changeState:CJFileDownloadStateSuccess];
    } else if (progress > 0.0) {
        [self __changeState:CJFileDownloadStatePause];
    } else {
        [self __changeState:CJFileDownloadStateReady];
    }
}

- (void)__changeState:(CJFileDownloadState)state {
    NSString *title = [CJDownloadEnumUtil nextStateTextForState:state];
    [self.downloadButton setTitle:title forState:UIControlStateNormal];
    if (state == CJFileDownloadStateSuccess) {
        self.deleteButton.enabled = YES;
    } else {
        self.deleteButton.enabled = NO;
    }
    NSString *localAbsPath = [[HSDownloadManager sharedInstance] fileLocalAbsPathForUrl:self.downloadUrl];
    self.stateChangeBlock(state, localAbsPath);
}


/** 下载文件 */
- (void)downloadButtonTapped:(UIButton *)button {
    [[HSDownloadManager sharedInstance] downloadOrPause:self.downloadUrl progressBlock:^(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.progressLabel.text = [NSString stringWithFormat:@"%.f%%", progress * 100];
            self.progressView.progress = progress;
        });
    } state:^(CJFileDownloadState state, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self __changeState:state];
        });
    }];
}


/** 删除文件 */
- (void)deleteButtonTapped:(UIButton *)sender {
    [[HSDownloadManager sharedInstance] deleteFile:self.downloadUrl];
    
   
    CGFloat progress = [[HSDownloadManager sharedInstance] progress:self.downloadUrl];
    self.progressLabel.text = [NSString stringWithFormat:@"%.f%%", progress * 100];
    self.progressView.progress = progress;

    [self __changeState:CJFileDownloadStateReady];
}

@end
