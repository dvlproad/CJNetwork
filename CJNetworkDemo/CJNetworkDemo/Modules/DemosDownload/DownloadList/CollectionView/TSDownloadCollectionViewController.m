//
//  TSDownloadCollectionViewController.m
//  TSDemo_Demo
//
//  Created by ciyouzen on 2017/2/25.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "TSDownloadCollectionViewController.h"
#import <CQDemoKit/CJUIKitToastUtil.h>
#import <CQDemoKit/CJUIKitAlertUtil.h>


#import "TSDownloadPlayViewController.h"
#import "HSDownloadManager.h"
#import "TSDownloadVideoIdManager.h"

#import "TSDownloadUtil.h"

@interface TSDownloadCollectionViewController () {
    
}

@end

@implementation TSDownloadCollectionViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.collectionView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navigationItem.title = NSLocalizedString(@"TSDownloadCollectionViewController", nil);
    
    __weak typeof(self)weakSelf = self;
    
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[CQTSLocImagesUtil cjts_localImageAtIndex:2]];
//    [self.view addSubview:imageView];
//    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(self.view);
//        make.top.mas_equalTo(self.mas_topLayoutGuide);
//        make.bottom.mas_equalTo(self.mas_bottomLayoutGuide);
//    }];
//    
    TSDownloadCollectionView *collectionView = [[TSDownloadCollectionView alloc] initWithDidSelectItemAtIndexHandle:^(NSIndexPath *indexPath, CQDownloadRecordModel * _Nonnull downloadModel) {
        //[CJUIKitToastUtil showMessage:[NSString stringWithFormat:@"点击了 %@", downloadModel.name]];
        
        TSDownloadPlayViewController *viewController = [[TSDownloadPlayViewController alloc] initWithDownloadModel:downloadModel deleteCompleteBlock:^{
            [weakSelf deleteFileAtIndexPath:indexPath];
        }];
        viewController.modalPresentationStyle = UIModalPresentationFullScreen; // 设置全屏模式
        viewController.modalPresentationCapturesStatusBarAppearance = YES;
        [weakSelf presentViewController:viewController animated:YES completion:nil]; // 只有 present,系统的播放器上的按钮才能设置显示
    } cellOverlayCustomDeleteHandler:^(NSIndexPath * _Nonnull indexPath) {
        [weakSelf deleteFileAtIndexPath:indexPath];
    }];
    //collectionView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
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
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(0);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-0);
        } else {
            // Fallback on earlier versions
            // topLayoutGuide\bottomLayoutGuide iOS11已经被弃用
            make.top.equalTo(self.mas_topLayoutGuideBottom).offset(0);
            make.bottom.equalTo(self.mas_bottomLayoutGuideTop).offset(-0);
        }
        make.left.mas_equalTo(self.view).mas_offset(0);
        make.centerX.mas_equalTo(self.view);
    }];
    self.collectionView = collectionView;
    
    self.collectionView.sectionDataModels = [TSDownloadVideoIdManager.sharedInstance sectionDataModels];
    
    // 监听
    [self tryCheckDeleteAllButtonShow];
}

- (void)tryCheckDeleteAllButtonShow {
    NSMutableArray *dataModels = self.collectionView.sectionDataModels.firstObject.values;
    BOOL show = dataModels.count > 0;
    if (show) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(deleteAllFiles)];
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)deleteFileAtIndexPath:(NSIndexPath *)indexPath {
    [TSDownloadVideoIdManager.sharedInstance deleteFileAtIndexPath:indexPath];

    [self.collectionView reloadData];
    [self tryCheckDeleteAllButtonShow];
}

- (void)deleteAllFiles {
    [TSDownloadVideoIdManager.sharedInstance deleteAllFiles];
    
    [self.collectionView reloadData];
    [self tryCheckDeleteAllButtonShow];
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
