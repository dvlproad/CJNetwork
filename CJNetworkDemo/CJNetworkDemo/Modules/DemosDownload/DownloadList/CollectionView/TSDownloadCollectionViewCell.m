//
//  TSDownloadCollectionViewCell.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2017/3/31.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "TSDownloadCollectionViewCell.h"

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
    
}

- (void)setupViews {
    // 初始化下载进度
    UIView *parentView = self.contentView;
    
    parentView.layer.masksToBounds = YES;
    parentView.layer.cornerRadius = 5.0;
    parentView.backgroundColor = [UIColor lightGrayColor];
    
    self.previewImageView = [[UIImageView alloc] init];
    [parentView addSubview:self.previewImageView];
    
    self.downloadView = [[TSDownloadCollectionViewCellOverlay alloc] initWithStateChangeBlock:^(CJFileDownloadState downloadState, NSString * _Nullable localAbsPath) {
        if (downloadState == CJFileDownloadStateSuccess) {
            self.previewImageView.image = [UIImage imageWithContentsOfFile:localAbsPath];
        } else {
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

// 设置 Auto Layout 约束
- (void)setupConstraints {
    UIView *parentView = self.contentView;
    
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
