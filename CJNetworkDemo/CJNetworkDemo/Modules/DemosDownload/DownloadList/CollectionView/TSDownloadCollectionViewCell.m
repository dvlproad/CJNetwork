//
//  TSDownloadCollectionViewCell.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2017/3/31.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "TSDownloadCollectionViewCell.h"
#import <CQDemoKit/CJUIKitToastUtil.h>
#import <CQDemoKit/CQTSPhotoUtil.h>

@interface TSDownloadCollectionViewCell ()

@end


@implementation TSDownloadCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self commonInit];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
        
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
//    __weak typeof(self) weakSelf = self;
//    _playerView.getVideoUrl = ^NSString *{
//        return [weakSelf.videoModel.videoFile.absoluteURL absoluteString];
//    };
}

- (void)setupViews {
    // 初始化下载进度
    UIView *parentView = self.contentView;
    
    parentView.layer.masksToBounds = YES;
    parentView.layer.cornerRadius = 5.0;
    parentView.backgroundColor = [UIColor lightGrayColor];
    
    [parentView addSubview:self.playerView];
    
    [parentView addSubview:self.previewImageView];
    
    
    self.downloadView = [[TSDownloadCollectionViewCellOverlay alloc] initWithStateChangeBlock:^(CJFileDownloadState downloadState, NSString * _Nullable localAbsPath) {
        if (downloadState == CJFileDownloadStateSuccess) {
            CQFileType fileType = [CQTSPhotoUtil fileTypeForFilePathOrUrl:localAbsPath];
            if (fileType == CQFileTypeVideo) {
                self.previewImageView.hidden = YES;
                self.playerView.getVideoPlayURL = ^NSURL *{
                    return [NSURL fileURLWithPath:localAbsPath];
                };
                [self.playerView playOrPause];
                [CJUIKitToastUtil showMessage:[NSString stringWithFormat:@"视频下载完成，存放于:%@", localAbsPath]];
            } else {
                self.previewImageView.hidden = NO;
                self.previewImageView.image = [UIImage imageWithContentsOfFile:localAbsPath];
                [CJUIKitToastUtil showMessage:[NSString stringWithFormat:@"图片下载完成，存放于:%@", localAbsPath]];
            }
        } else {
            self.previewImageView.hidden = NO;
            self.previewImageView.image = nil;
        }
    }];
    [parentView addSubview:self.downloadView];
    
    // 设置 Auto Layout 约束
    [self setupConstraints];
}

- (UIImageView *)previewImageView {
    if (!_previewImageView) {
        _previewImageView = [[UIImageView alloc] init];
        _previewImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _previewImageView;
}

- (CJAVPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [[CJAVPlayerView alloc] initWithFrame:CGRectZero];
        _playerView.backgroundColor = [UIColor redColor];
    }
    return _playerView;
}

// 设置 Auto Layout 约束
- (void)setupConstraints {
    UIView *parentView = self.contentView;
    
    self.playerView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.playerView.topAnchor constraintEqualToAnchor:parentView.topAnchor constant:0],
        [self.playerView.bottomAnchor constraintEqualToAnchor:parentView.bottomAnchor constant:0],
        [self.playerView.trailingAnchor constraintEqualToAnchor:parentView.trailingAnchor constant:0],
        [self.playerView.leadingAnchor constraintEqualToAnchor:parentView.leadingAnchor constant:0]
    ]];
    
    self.previewImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.previewImageView.topAnchor constraintEqualToAnchor:parentView.topAnchor constant:0],
        [self.previewImageView.bottomAnchor constraintEqualToAnchor:parentView.bottomAnchor constant:0],
        [self.previewImageView.trailingAnchor constraintEqualToAnchor:parentView.trailingAnchor constant:0],
        [self.previewImageView.leadingAnchor constraintEqualToAnchor:parentView.leadingAnchor constant:0]
    ]];
    
    self.downloadView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.downloadView.topAnchor constraintEqualToAnchor:parentView.topAnchor constant:0],
        [self.downloadView.bottomAnchor constraintEqualToAnchor:parentView.bottomAnchor constant:0],
        [self.downloadView.trailingAnchor constraintEqualToAnchor:parentView.trailingAnchor constant:0],
        [self.downloadView.leadingAnchor constraintEqualToAnchor:parentView.leadingAnchor constant:0]
    ]];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    // Configure the view for the selected state
}

@end
