//
//  DownloadTableViewCell.m
//  CJNetworkDemo
//
//  Created by dvlproad on 2017/3/31.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "DownloadTableViewCell.h"

@interface DownloadTableViewCell ()

@property (nonatomic, weak) IBOutlet UILabel *progressLabel;        /** 进度UILabel */
@property (nonatomic, weak) IBOutlet UIProgressView *progressView;  /** 进度UIProgressView */
@property (nonatomic, weak) IBOutlet UIButton *downloadButton;      /** 下载按钮 */
@property (nonatomic, weak) IBOutlet UIButton *deleteButton;        /**< 删除按钮 */

@end


@implementation DownloadTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self commonInit];
}

- (void)commonInit {
    [self.downloadButton addTarget:self action:@selector(downloadFile:) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteButton addTarget:self action:@selector(deleteFile:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self refreshDataWithState:DownloadStateSuspended];
}

#pragma mark 刷新数据
- (void)refreshDataWithState:(DownloadState)state
{
    self.progressLabel.text = [NSString stringWithFormat:@"%.f%%", [[HSDownloadManager sharedInstance] progress:self.downloadUrl] * 100];
    self.progressView.progress = [[HSDownloadManager sharedInstance] progress:self.downloadUrl];
    [self.downloadButton setTitle:[self getTitleWithDownloadState:state] forState:UIControlStateNormal];
    NSLog(@"-----%f", [[HSDownloadManager sharedInstance] progress:self.downloadUrl]);
}


/** 下载文件 */
- (void)downloadFile:(UIButton *)button {
    [[HSDownloadManager sharedInstance] download:self.downloadUrl progressBlock:^(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.progressLabel.text = [NSString stringWithFormat:@"%.f%%", progress * 100];
            self.progressView.progress = progress;
        });
    } state:^(DownloadState state) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [button setTitle:[self getTitleWithDownloadState:state] forState:UIControlStateNormal];
        });
    }];
}


/** 删除文件 */
- (void)deleteFile:(UIButton *)sender {
    [[HSDownloadManager sharedInstance] deleteFile:self.downloadUrl];
    
    self.progressLabel.text = [NSString stringWithFormat:@"%.f%%", [[HSDownloadManager sharedInstance] progress:self.downloadUrl] * 100];
    self.progressView.progress = [[HSDownloadManager sharedInstance] progress:self.downloadUrl];
    [self.downloadButton setTitle:[self getTitleWithDownloadState:DownloadStateSuspended] forState:UIControlStateNormal];
}


#pragma mark 按钮状态
- (NSString *)getTitleWithDownloadState:(DownloadState)state
{
    switch (state) {
        case DownloadStateDownloading:
            return @"暂停";
        case DownloadStateSuspended:
        case DownloadStateFailed:
            return @"开始";
        case DownloadStateCompleted:
            return @"完成";
        default:
            break;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
