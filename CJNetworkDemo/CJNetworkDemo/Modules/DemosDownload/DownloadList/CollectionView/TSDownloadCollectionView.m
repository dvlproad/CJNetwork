//
//  TSDownloadCollectionView.m
//  CJUIKitDemo
//
//  Created by ciyouzen on 8/10/15.
//  Copyright (c) 2015 dvlproad. All rights reserved.
//

#import "TSDownloadCollectionView.h"
#import <CQDemoKit/CQTSRipeBaseCollectionViewDelegate.h>
#import <CQDemoKit/CQTSRipeSectionDataUtil.h>
#import <CQVideoUrlAnalyze_Swift/CQVideoUrlAnalyze_Swift-Swift.h>
#import <CQMdeiaVideoFrameKit/VideoFrameCQHelper.h>

#import "TSDownloadCollectionViewCell.h"
#import "TSDownloadVideoIdManager.h"

@interface TSDownloadCollectionView ()<UICollectionViewDataSource> {
    
}
@property (nonatomic, strong, readonly) CQTSRipeBaseCollectionViewDelegate *ripeCollectionViewDelegate;   /**< collectionView的delegate */
@property (nullable, nonatomic, copy, readonly) void(^didSelectItemHandle)(NSIndexPath *indexPath, CQDownloadRecordModel *downloadModel); /**< 点击item的回调 */
@property (nonatomic, copy) void(^cellOverlayCustomDeleteHandler)(NSIndexPath *indexPath); // cell上overlay视图里的删除按钮的自定义的删除事件（有时候下载数据不删除，但是关联的数据删除，其就不会展示）

@end


@implementation TSDownloadCollectionView

#pragma mark - Init
/*
 *  初始化 CollectionView
 *
 *  @param didSelectItemAtIndexHandle       下载完成时候点击item的回调
 *  @param cellOverlayCustomDeleteHandler   cell上overlay视图里的删除按钮的自定义的删除事件
 *
 *  @return CollectionView
 */
- (instancetype)initWithDidSelectItemAtIndexHandle:(void(^)(NSIndexPath *indexPath, CQDownloadRecordModel *downloadModel))didSelectItemAtIndexHandle
                cellOverlayCustomDeleteHandler:(void(^ _Nullable)(NSIndexPath *indexPath))cellOverlayCustomDeleteHandler
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self = [super initWithFrame:CGRectZero collectionViewLayout:layout];
    if (self) {
        __weak typeof(self) weakSelf = self;
        
        _didSelectItemHandle = didSelectItemAtIndexHandle;
        _cellOverlayCustomDeleteHandler = cellOverlayCustomDeleteHandler;
        _ripeCollectionViewDelegate = [[CQTSRipeBaseCollectionViewDelegate alloc] initWithPerMaxCount:2 widthHeightRatio: 140/220.0 didSelectItemHandle:^(UICollectionView * _Nonnull bCollectionView, NSIndexPath * _Nonnull bIndexPath) {
            CQDownloadRecordModel *downloadModel = [weakSelf dataModelAtIndexPath:bIndexPath];
            
            TSDownloadCollectionViewCell *cell = (TSDownloadCollectionViewCell *)[bCollectionView cellForItemAtIndexPath:bIndexPath];
            CJFileDownloadState currentDownloadState = [cell.downloadView currentDownloadState];
            switch (currentDownloadState) {
                case CJFileDownloadStateSuccess: {
                    !didSelectItemAtIndexHandle ?: didSelectItemAtIndexHandle(bIndexPath, downloadModel);
                    break;
                }
                case CJFileDownloadStateFailure: {
                    [cell.downloadView startDownload];
                    break;
                }
                case CJFileDownloadStateReady:
                case CJFileDownloadStatePause:
                {
                    [cell.downloadView startDownload];
                    break;
                }
                case CJFileDownloadStateDownloading: {
                    break;
                }
                default:
                    break;
            }
        }];
        self.delegate = self.ripeCollectionViewDelegate;
        
        
        [self registerClass:[TSDownloadCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        self.dataSource = self;
    }
    return self;
}

#pragma mark - Setter
- (void)setSectionDataModels:(NSArray<CQDMSectionDataModel *> *)sectionDataModels {
    _sectionDataModels = sectionDataModels;
    
    [self reloadData];
}

/*
 *  获取指定位置的dataModel
 *
 *  @return 指定位置的dataModel
 */
- (CQDownloadRecordModel *)dataModelAtIndexPath:(NSIndexPath *)indexPath {
    CQDMSectionDataModel *sectionDataModel = [self.sectionDataModels objectAtIndex:indexPath.section];
    NSArray *dataModels = sectionDataModel.values;
    CQDownloadRecordModel *moduleModel = [dataModels objectAtIndex:indexPath.row];
    
    return moduleModel;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.sectionDataModels.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    CQDMSectionDataModel *sectionDataModel = [self.sectionDataModels objectAtIndex:section];
    NSArray *dataModels = sectionDataModel.values;
    
    return dataModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CQDownloadRecordModel *downloadModel = [self dataModelAtIndexPath:indexPath];
    
    TSDownloadCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
//            cell.previewImageView.image = [UIImage imageWithContentsOfFile:downloadModel.imageName]; // 视频的预览图
    cell.downloadView.downloadModel = downloadModel;
    cell.downloadView.downloadUrlLabel.text = downloadModel.name;
    __weak typeof(self)weakSelf = self;
    cell.downloadView.customDeleteHandler = ^{
        weakSelf.cellOverlayCustomDeleteHandler(indexPath);
    };
    [cell.downloadView setupDownloadBlock];
    
    return cell;
}

@end
