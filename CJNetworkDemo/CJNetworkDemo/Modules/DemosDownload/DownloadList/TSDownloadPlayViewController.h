//
//  TSDownloadPlayViewController.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2016/3/26.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "CJUIKitBaseHomeViewController.h"
#import <AVKit/AVKit.h>
#import "CQDownloadRecordModel.h"

@interface TSDownloadPlayViewController : CJUIKitBaseViewController {
    
}
@property (nonatomic, strong) UIImageView *videoThumbnailView; // 视频封面
@property (nonatomic, strong) UIButton *deleteButton;   // 删除按钮
@property (nonatomic, strong) UIButton *playButton; // 播放按钮
@property (nonatomic, strong) UIButton *shareButton; // 分享按钮
@property (nonatomic, strong) UIButton *saveButton; // 保存按钮
@property (nonatomic, strong) UITextView *noteTextView; // 备注输入框
@property (nonatomic, strong) AVPlayerViewController *fullScreenPlayerViewController; // 视频播放器

@property (nonatomic, strong) CQDownloadRecordModel *downloadModel;

- (instancetype)initWithDownloadModel:(CQDownloadRecordModel *)downloadModel deleteCompleteBlock:(void(^)(void))deleteCompleteBlock;


@end
