//
//  TSDownloadCollectionViewDataSource.m
//  CJComplexUIKitDemo
//
//  Created by ciyouzen on 2017/2/25.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "TSDownloadCollectionViewDataSource.h"
#import "UIImageView+CQTSBaseUtil.h"
#import "CQTSLocImagesUtil.h"

@interface TSDownloadCollectionViewDataSource () {
    
}

@property (nonatomic, copy, readonly) UICollectionViewCell *(^cellForItemAtIndexPathBlock)(UICollectionView *bCollectionView, NSIndexPath *bIndexPath, CQTSLocImageDataModel *dataModel); /**< 绘制指定indexPath的cell */

@end


@implementation TSDownloadCollectionViewDataSource

#pragma mark - Init
/*
 *  初始化 CollectionView 的 dataSource
 *
 *  @param sectionRowCounts             每个section的rowCount个数(数组有多少个就多少个section，数组里的元素值为该section的row行数)
 *  @param selectedIndexPaths           选中的indexPath数组
 *  @param registerHandler              集合视图cell等的注册
 *  @param cellForItemAtIndexPath       获取指定indexPath的cell
 *
 *  @return CollectionView 的 dataSource
 */
- (instancetype)initWithSectionRowCounts:(NSArray<NSNumber *> *)sectionRowCounts
                      selectedIndexPaths:(nullable NSArray<NSIndexPath *> *)selectedIndexPaths
                         registerHandler:(void(^)(void))registerHandler
                  cellForItemAtIndexPath:(UICollectionViewCell *(^)(UICollectionView *bCollectionView, NSIndexPath *bIndexPath, CQTSLocImageDataModel *dataModel))cellForItemAtIndexPath
{
    NSMutableArray<CQDMSectionDataModel *> *sectionDataModels = [[NSMutableArray alloc] init];
    for (int section = 0; section < sectionRowCounts.count; section++) {
        NSNumber *nRowCount = [sectionRowCounts objectAtIndex:section];
        NSInteger iRowCount = [nRowCount integerValue];
        
        CQDMSectionDataModel *sectionDataModel = [[CQDMSectionDataModel alloc] init];
        sectionDataModel.theme = [NSString stringWithFormat:@"section %d", section];
        sectionDataModel.values = [CQTSLocImagesUtil dataModelsWithCount:iRowCount randomOrder:NO changeImageNameToNetworkUrl:YES];
        for (int item = 0; item < iRowCount; item++) {
            CQTSLocImageDataModel *module = [sectionDataModel.values objectAtIndex:item];
            NSString *originalName = module.name;
            module.name = [NSString stringWithFormat:@"%d-%@", section, originalName];
            
            BOOL isSelected = [selectedIndexPaths containsObject:[NSIndexPath indexPathForItem:item inSection:section]];
            module.selected = isSelected;
        }
        [sectionDataModels addObject:sectionDataModel];
    }

    self = [self initWithSectionDataModels:sectionDataModels registerHandler:registerHandler cellForItemAtIndexPath:cellForItemAtIndexPath];
    if (self) {
        
    }
    return self;
}

/*
 *  初始化 CollectionView 的 dataSource
 *
 *  @param sectionDataModels            每个section的数据(section中的数据元素必须是 CQDMModuleModel )
 *  @param registerHandler              集合视图cell等的注册
 *  @param cellForItemAtIndexPath       获取指定indexPath的cell
 *
 *  @return CollectionView 的 dataSource
 */
- (instancetype)initWithSectionDataModels:(NSArray<CQDMSectionDataModel *> *)sectionDataModels
                          registerHandler:(void(^)(void))registerHandler
                   cellForItemAtIndexPath:(UICollectionViewCell *(^)(UICollectionView *bCollectionView, NSIndexPath *bIndexPath, CQTSLocImageDataModel *dataModel))cellForItemAtIndexPath
{
    self = [super init];
    if (self) {
        _sectionDataModels = sectionDataModels;
        
        registerHandler();
        _cellForItemAtIndexPathBlock = cellForItemAtIndexPath;
    }
    return self;
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
    CQTSLocImageDataModel *moduleModel = [self dataModelAtIndexPath:indexPath];
    
    UICollectionViewCell *cell = self.cellForItemAtIndexPathBlock(collectionView, indexPath, moduleModel);

    return cell;
}


@end
