//
//  TSDownloadPlayViewController.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2016/3/26.
//  Copyright © 2016年 dvlproad. All rights reserved.
//
//  要解析的视频的播放界面

#import "TSDownloadPlayViewController.h"
#import <CQDemoKit/CQTSLocImagesUtil.h>
#import <CQDemoKit/CQTSButtonFactory.h>
#import "TSDownloadUtil.h"

#import "HSDownloadManager.h"

#import <Masonry/Masonry.h>


@interface TSDownloadPlayViewController () {
    
}
@property (nonatomic, copy) void(^deleteCompleteBlock)(void);

@property (nonatomic, strong) AVPlayerViewController *playerViewController; // 视频播放器
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) NSURL *videoURL;

@property (nonatomic, strong) UIView *navigationBarView; // 导航栏视图

@end


@implementation TSDownloadPlayViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithDownloadModel:(CQDownloadRecordModel *)downloadModel
                  deleteCompleteBlock:(void(^)(void))deleteCompleteBlock
{
    self = [super init];
    if (self) {
        _downloadModel = downloadModel;
        _deleteCompleteBlock = deleteCompleteBlock;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    // 设置导航栏
    [self setupNavigationBarAndButtons];
    
    // 初始化 UI 组件
    [self setupVideoThumbnail];
    
//    [self setupNoteTextView];
    
    NSString *localAbsPath = [CQDownloadCacheUtil fileLocalAbsPathForUrl:self.downloadModel];
    //NSURL *videoURL = [NSURL fileURLWithPath:localAbsPath];
    
    NSString *videoUrl = localAbsPath;
    NSURL *videoURL;
    if ([videoUrl hasPrefix:@"http"] || [videoUrl hasPrefix:@"https"]) {
        videoURL = [NSURL URLWithString:videoUrl];
    } else {
        videoURL = [NSURL fileURLWithPath:videoUrl];
    }
    self.videoURL = videoURL;
    /*
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:videoURL];
    [self.player replaceCurrentItemWithPlayerItem:playerItem];
    */
    self.player = [[AVPlayer alloc] initWithURL:self.videoURL]; // 避免多次初始化
    self.playerViewController.player = self.player;
    [self.player play];

}

#pragma mark - 设置导航栏
- (void)setupNavigationBarAndButtons {
    UIView *navigationBarView = [[UIView alloc] init];
    [self.view addSubview:navigationBarView];
    [navigationBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(0);
        } else {
            // Fallback on earlier versions
            // topLayoutGuide\bottomLayoutGuide iOS11已经被弃用
            make.top.equalTo(self.mas_topLayoutGuideBottom).offset(0);
        }
        make.height.mas_equalTo(44);
        make.left.right.mas_equalTo(self.view);
    }];
    self.navigationBarView = navigationBarView;
    
    // 返回按钮
    UIButton *backButton = [self navigationButtonWithtTitle:NSLocalizedStringFromTable(@"返回", @"LocalizableDownloader", nil)];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [navigationBarView addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(navigationBarView).offset(10);
        make.width.mas_equalTo(80);
        make.top.mas_equalTo(navigationBarView);
        make.height.mas_equalTo(44);
    }];
    
    
    // 标题
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((screenWidth - 100) / 2, 0, 100, 44)];
    titleLabel.text = @"";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [navigationBarView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(navigationBarView);
        make.top.mas_equalTo(navigationBarView);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(44);
    }];

    // 删除按钮
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //UIImage *deleteImage = [CQTSLocImagesUtil cjts_localImageAtIndex:4];
    [deleteButton setTitle:NSLocalizedStringFromTable(@"删除", @"LocalizableDownloader", nil) forState:UIControlStateNormal];
    deleteButton.frame = CGRectMake(screenWidth - 50, 0, 40, 44);
    deleteButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [deleteButton addTarget:self action:@selector(deleteVideo) forControlEvents:UIControlEventTouchUpInside];
    [navigationBarView addSubview:deleteButton];
    [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(navigationBarView).offset(-10);
        make.width.mas_equalTo(40);
        make.top.mas_equalTo(navigationBarView);
        make.height.mas_equalTo(44);
    }];
    self.deleteButton = deleteButton;
    

    CGFloat buttonSize = 50;
    __weak typeof(self)weakSelf = self;
    // 播放按钮
//    self.playButton = [CQTSButtonFactory themeBGButtonWithTitle:NSLocalizedStringFromTable(@"播放", @"LocalizableDownloader", nil) actionBlock:^(UIButton * _Nonnull bButton) {
//        [weakSelf playVideo];
//    }];
//    [self.videoThumbnailView addSubview:self.playButton];
//    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(self.videoThumbnailView).offset(-10);
//        make.centerY.mas_equalTo(self.videoThumbnailView).offset(-10);
//        make.width.mas_equalTo(buttonSize);
//        make.height.mas_equalTo(buttonSize);
//    }];
    
    // 分享按钮
    self.shareButton = [self navigationButtonWithtTitle:NSLocalizedStringFromTable(@"分享", @"LocalizableDownloader", nil)];
    [self.shareButton addTarget:self action:@selector(shareVideo) forControlEvents:UIControlEventTouchUpInside];
    [navigationBarView addSubview:self.shareButton];
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(deleteButton.mas_left).offset(-10);
        make.centerY.mas_equalTo(navigationBarView).offset(0);
        make.width.mas_equalTo(buttonSize);
        make.height.mas_equalTo(buttonSize);
    }];
    
    // 保存按钮
    self.saveButton = [self navigationButtonWithtTitle:NSLocalizedStringFromTable(@"保存", @"LocalizableDownloader", nil)];
    [self.saveButton addTarget:self action:@selector(saveVideo) forControlEvents:UIControlEventTouchUpInside];
    [navigationBarView addSubview:self.saveButton];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.shareButton.mas_left).offset(-10);
        make.centerY.mas_equalTo(navigationBarView).offset(0);
        make.width.mas_equalTo(buttonSize);
        make.height.mas_equalTo(buttonSize);
    }];
}

- (UIButton *)navigationButtonWithtTitle:(NSString *)title {
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setTitle:title forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal]; // 替换你的返回箭头图片
    backButton.titleLabel.font = [UIFont systemFontOfSize:16];
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    return backButton;
}


#pragma mark - 设置视频封面
- (void)setupVideoThumbnail {
    self.videoThumbnailView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 100, self.view.frame.size.width - 40, 420)];
    UIImage *placeholderImage = [CQTSLocImagesUtil cjts_localImageAtIndex:2];
    self.videoThumbnailView.image = placeholderImage; // 替换为视频封面
    self.videoThumbnailView.contentMode = UIViewContentModeScaleAspectFill;
    self.videoThumbnailView.userInteractionEnabled = YES;
    [self.view addSubview:self.videoThumbnailView];
    [self.videoThumbnailView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
//            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(10);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-10);
        } else {
            // Fallback on earlier versions
            // topLayoutGuide\bottomLayoutGuide iOS11已经被弃用
//            make.top.equalTo(self.mas_topLayoutGuideBottom).offset(10);
            make.bottom.equalTo(self.mas_bottomLayoutGuideTop).offset(-10);
        }
        make.top.mas_equalTo(self.navigationBarView.mas_bottom).offset(0);
        make.left.right.mas_equalTo(self.view);
    }];
    
    [self addPlayView];
}

- (void)addPlayView {
//    NSURL *videoURL = [NSURL URLWithString:videoUrl];
//    NSString *localAbsPath = [[HSDownloadManager sharedInstance] fileLocalAbsPathForUrl:self.downloadModel];
//    NSURL *videoURL = [NSURL fileURLWithPath:localAbsPath];
////    NSURL *videoURL = [NSURL URLWithString:@"https://www.tikwm.com/video/media/hdplay/7465611957203160340.mp4"];
//    self.videoURL = videoURL;
    
    // 1. 创建播放器
//    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:videoURL];
//    self.player = [AVPlayer playerWithPlayerItem:playerItem];
//    self.player = [AVPlayer playerWithURL:videoURL];

    // 2. 创建 `AVPlayerViewController`
    self.playerViewController = [[AVPlayerViewController alloc] init];
    self.playerViewController.showsPlaybackControls = YES; // 显示或隐藏播放控制条（可选）
    
    // 3. 设置 `playerViewController.view` 的大小
    self.playerViewController.view.frame = self.videoThumbnailView.bounds;
    self.playerViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // 4. 添加 `playerViewController.view` 到 `videoThumbnailView`
    [self.videoThumbnailView addSubview:self.playerViewController.view];

    // 5. 隐藏 `videoThumbnailView` 的默认封面图
    self.videoThumbnailView.backgroundColor = [UIColor clearColor];

    // 6. 自动播放视频
    [self.player seekToTime:kCMTimeZero];
    
    // 7. 监听播放完成通知，实现循环播放
    AVPlayerItem *playerItem = self.player.currentItem;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerDidFinishPlaying:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:playerItem];
    
    // 8. 添加点击手势
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playFullScreen)];
//    [self.videoThumbnailView addGestureRecognizer:tapGesture];
    
    [self.player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
            [self.player play];
        }
    }
}

// 播放完成后重新播放
- (void)playerDidFinishPlaying:(NSNotification *)notification {
    [self.player seekToTime:kCMTimeZero]; // 从头开始播放
    [self.player play];
}

// 点击进入全屏播放
- (void)playFullScreen {
    if (self.player.status == AVPlayerStatusReadyToPlay) {
//        if (self.player.rate == 0.0) {
//            [self.player play];  // 如果当前未播放，则播放
//        } else {
//            [self.player pause]; // 如果当前正在播放，则暂停
//        }
//        
//        // 确保 UI 线程更新
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.playerViewController.showsPlaybackControls = YES;
//        });
        
        // 进入全屏时，显示播放控件
//        AVPlayer *player = [AVPlayer playerWithURL:self.videoURL];
//        
//        AVPlayerViewController *fullScreenPlayerVC = [[AVPlayerViewController alloc] init];
//        fullScreenPlayerVC.player = player;
//        fullScreenPlayerVC.showsPlaybackControls = YES; // 进入全屏时显示控件
//        // 显示全屏播放器
//        [self presentViewController:fullScreenPlayerVC animated:YES completion:^{
//            [player play];  // 如果当前未播放，则播放
//        }];
    }
}


#pragma mark - 设置备注框
- (void)setupNoteTextView {
    self.noteTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.videoThumbnailView.frame) + 20, self.view.frame.size.width - 40, 80)];
    self.noteTextView.text = NSLocalizedStringFromTable(@"添加备注 +", @"LocalizableDownloader", nil);
    self.noteTextView.textColor = [UIColor lightGrayColor];
    self.noteTextView.layer.borderColor = [UIColor grayColor].CGColor;
    self.noteTextView.layer.borderWidth = 1.0;
    self.noteTextView.layer.cornerRadius = 5;
    [self.view addSubview:self.noteTextView];
}

#pragma mark - 播放视频
- (void)playVideo {
    self.fullScreenPlayerViewController = [[AVPlayerViewController alloc] init];
    self.fullScreenPlayerViewController.player = [AVPlayer playerWithURL:self.videoURL];
    [self presentViewController:self.fullScreenPlayerViewController animated:YES completion:^{
        [self.fullScreenPlayerViewController.player play];
    }];
}



#pragma mark - 分享视频
- (void)shareVideo {
//    NSString *videoUrl = self.downloadModel.url;
//    NSURL *videoURL = [NSURL URLWithString:videoUrl];
    NSString *localAbsPath = [CQDownloadCacheUtil fileLocalAbsPathForUrl:self.downloadModel];
    NSURL *videoURL = [NSURL fileURLWithPath:localAbsPath];
    
    NSArray *itemsToShare = @[videoURL];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    [self presentViewController:activityVC animated:YES completion:nil];
}

#pragma mark - 保存视频
- (void)saveVideo {
    [TSDownloadUtil saveInViewController:self forDownloadModel:self.downloadModel];
}

#pragma mark - 删除视频
- (void)deleteVideo {
    __weak typeof(self)weakSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedStringFromTable(@"删除视频", @"LocalizableDownloader", nil)
                                                                   message:NSLocalizedStringFromTable(@"确定要删除该视频吗？", @"LocalizableDownloader", nil)
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"删除", @"LocalizableDownloader", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //NSString *downloadUrl = self.downloadModel.imageName;
        //[[HSDownloadManager sharedInstance] deleteFile:downloadUrl]; // 视频本身不删除，万一下次也是下载这个呢？而且外部可能重复下载
        NSLog(@"视频已删除");
        [self dismissViewControllerAnimated:YES completion:^{
            !weakSelf.deleteCompleteBlock ?: weakSelf.deleteCompleteBlock();
        }];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"取消", @"LocalizableDownloader", nil) style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:confirmAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 返回上一级
- (void)backAction {
    [self.player pause];
    self.player = nil;    // 释放播放器，修复iOS18返回界面还在播放音频
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
