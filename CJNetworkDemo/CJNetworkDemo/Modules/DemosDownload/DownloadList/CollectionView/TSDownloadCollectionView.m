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

#import "TSDownloadCollectionViewCell.h"

@interface TSDownloadCollectionView ()<UICollectionViewDataSource> {
    
}
@property (nonatomic, strong, readonly) CQTSRipeBaseCollectionViewDelegate *ripeCollectionViewDelegate;   /**< collectionView的delegate */
@property (nullable, nonatomic, copy, readonly) void(^didSelectItemAtIndexHandle)(NSInteger index); /**< 点击item的回调 */

@end


@implementation TSDownloadCollectionView

#pragma mark - Init
/*
 *  初始化 CollectionView
 *
 *  @param didSelectItemAtIndexHandle   点击item的回调
 *
 *  @return CollectionView
 */
- (instancetype)initWithDidSelectItemAtIndexHandle:(void(^)(CQTSLocImageDataModel *downloadModel))didSelectItemAtIndexHandle
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self = [super initWithFrame:CGRectZero collectionViewLayout:layout];
    if (self) {
        __weak typeof(self) weakSelf = self;
        
        _ripeCollectionViewDelegate = [[CQTSRipeBaseCollectionViewDelegate alloc] initWithPerMaxCount:2 widthHeightRatio: 1.0 didSelectItemHandle:^(UICollectionView * _Nonnull bCollectionView, NSIndexPath * _Nonnull bIndexPath) {
            CQTSLocImageDataModel *downloadModel = [weakSelf dataModelAtIndexPath:bIndexPath];
            !didSelectItemAtIndexHandle ?: didSelectItemAtIndexHandle(downloadModel);
        }];
        self.delegate = self.ripeCollectionViewDelegate;
        
        
        [self registerClass:[TSDownloadCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        self.dataSource = self;
        
        CQDMSectionDataModel *sectionDataModel = [[CQDMSectionDataModel alloc] init];
        sectionDataModel.theme = [NSString stringWithFormat:@"section %d", 0];
        sectionDataModel.values = [[NSMutableArray alloc] init];
        self.sectionDataModels = @[sectionDataModel];
        
        [self addVideoByVideoId:@"7465611957203160340"];
    }
    return self;
}

- (void)addVideoByVideoId:(NSString *)videoId {
//    NSString *cover = [CQVideoUrlAnalyze_Tiktok getVideoInfoFor:CQAnalyzeVideoUrlTypeImageCover videoId:videoId];
    
    NSString *videoOriginal = [CQVideoUrlAnalyze_Tiktok getVideoInfoFor:CQAnalyzeVideoUrlTypeVideoOriginal videoId:videoId];
    NSString *videoWithoutWatermark = [CQVideoUrlAnalyze_Tiktok getVideoInfoFor:CQAnalyzeVideoUrlTypeVideoWithoutWatermark videoId:videoId];
    NSString *videoWithoutWatermarkHD = [CQVideoUrlAnalyze_Tiktok getVideoInfoFor:CQAnalyzeVideoUrlTypeVideoWithoutWatermarkHD videoId:videoId];
    
    
    NSMutableArray<CQTSLocImageDataModel *> *dataModels = [[NSMutableArray alloc] init];
    {
        CQTSLocImageDataModel *dataModel = [[CQTSLocImageDataModel alloc] init];
        dataModel.name = [NSString stringWithFormat:@"videoOriginal %@", videoId];
        dataModel.imageName = videoOriginal;
        [dataModels addObject:dataModel];
    }
    {
        CQTSLocImageDataModel *dataModel = [[CQTSLocImageDataModel alloc] init];
        dataModel.name = [NSString stringWithFormat:@"videoWithoutWatermark %@", videoId];
        dataModel.imageName = videoWithoutWatermark;
        [dataModels addObject:dataModel];
    }
    {
        CQTSLocImageDataModel *dataModel = [[CQTSLocImageDataModel alloc] init];
        dataModel.name = [NSString stringWithFormat:@"videoWithoutWatermarkHD %@", videoId];
        dataModel.imageName = videoWithoutWatermarkHD;
        [dataModels addObject:dataModel];
    }
    
    [self.sectionDataModels.firstObject.values addObjectsFromArray:dataModels];
    [self reloadData];
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
- (CQTSLocImageDataModel *)dataModelAtIndexPath:(NSIndexPath *)indexPath {
    CQDMSectionDataModel *sectionDataModel = [self.sectionDataModels objectAtIndex:indexPath.section];
    NSArray *dataModels = sectionDataModel.values;
    CQTSLocImageDataModel *moduleModel = [dataModels objectAtIndex:indexPath.row];
    
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
    CQTSLocImageDataModel *downloadModel = [self dataModelAtIndexPath:indexPath];
    
    TSDownloadCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
//            cell.previewImageView.image = [UIImage imageWithContentsOfFile:downloadModel.imageName]; // 视频的预览图
    cell.downloadView.downloadUrl = downloadModel.imageName;
    cell.downloadView.downloadUrlLabel.text = downloadModel.name;

    return cell;
}

@end
