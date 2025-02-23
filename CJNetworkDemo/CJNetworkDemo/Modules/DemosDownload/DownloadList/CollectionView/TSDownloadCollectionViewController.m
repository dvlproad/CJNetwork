//
//  TSDownloadCollectionViewController.m
//  TSDemo_Demo
//
//  Created by ciyouzen on 2017/2/25.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "TSDownloadCollectionViewController.h"
#import <CQDemoKit/CQTSLocImagesUtil.h>
#import <CQDemoKit/CJUIKitToastUtil.h>
#import "CQDemoPhotoUtil.h"

#import "TSDownloadCollectionView.h"
#import "HSDownloadManager.h"

@interface TSDownloadCollectionViewController () {
    
}
@property (nonatomic, strong) TSDownloadCollectionView *collectionView;

@end

@implementation TSDownloadCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSLocalizedString(@"测试CQTSRipeCollectionView", nil);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(deleteAllFiles)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[CQTSLocImagesUtil cjts_localImageAtIndex:2]];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.mas_topLayoutGuide);
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuide);
    }];
    
    TSDownloadCollectionView *collectionView = [[TSDownloadCollectionView alloc] initWithDidSelectItemAtIndexHandle:^(CQTSLocImageDataModel * _Nonnull downloadModel) {
        //[CJUIKitToastUtil showMessage:[NSString stringWithFormat:@"点击了 %@", downloadModel.name]];
        
        NSString *downloadUrl = downloadModel.imageName;
        NSString *localAbsPath = [[HSDownloadManager sharedInstance] fileLocalAbsPathForUrl:downloadUrl];
        NSURL *mediaLocalURL = [NSURL fileURLWithPath:localAbsPath];
        [CQDemoPhotoUtil saveImageToPhotoAlbum:mediaLocalURL success:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [CJUIKitToastUtil showMessage:@"保存成功"];
            });
        } failure:^(NSString * _Nonnull errorMessage) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [CJUIKitToastUtil showMessage:errorMessage];
            });
        }];
    }];
    collectionView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
    [self.view addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        if #available(iOS 11.0, *) {
//            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
//            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-10)
//        } else {
//            // Fallback on earlier versions
//            // topLayoutGuide\bottomLayoutGuide iOS11已经被弃用
//            make.top.equalTo(topLayoutGuide.snp.bottom).offset(10)
//            make.bottom.equalTo(bottomLayoutGuide.snp.top).offset(-10)
//        }
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(10);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-10);
        } else {
            // Fallback on earlier versions
            // topLayoutGuide\bottomLayoutGuide iOS11已经被弃用
            make.top.equalTo(self.mas_topLayoutGuideBottom).offset(10);
            make.bottom.equalTo(self.mas_bottomLayoutGuideTop).offset(-10);
        }
        make.left.mas_equalTo(self.view).mas_offset(10);
        make.centerX.mas_equalTo(self.view);
    }];
    self.collectionView = collectionView;
}

- (void)deleteAllFiles {
    [[HSDownloadManager sharedInstance] deleteAllFile];
    [self.collectionView reloadData];
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
