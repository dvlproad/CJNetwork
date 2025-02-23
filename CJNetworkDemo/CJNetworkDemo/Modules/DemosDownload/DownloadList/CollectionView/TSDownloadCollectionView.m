//
//  TSDownloadCollectionView.m
//  CJUIKitDemo
//
//  Created by ciyouzen on 8/10/15.
//  Copyright (c) 2015 dvlproad. All rights reserved.
//

#import "TSDownloadCollectionView.h"
#import "CQTSRipeBaseCollectionViewDelegate.h"
#import "TSDownloadCollectionViewDataSource.h"

#import "TSDownloadCollectionViewCell.h"

@interface TSDownloadCollectionView () {
    
}
@property (nonatomic, strong) NSMutableArray<NSString *> *buttonTitles;
@property (nullable, nonatomic, copy, readonly) void(^didSelectItemAtIndexHandle)(NSInteger index); /**< 点击item的回调 */

@property (nonatomic, strong, readonly) CQTSRipeBaseCollectionViewDelegate *ripeCollectionViewDelegate;   /**< collectionView的delegate */
@property (nonatomic, strong, readonly) TSDownloadCollectionViewDataSource *ripeCollectionViewDataSource;   /**< collectionView的dataSource */

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
        
        _ripeCollectionViewDataSource = [[TSDownloadCollectionViewDataSource alloc] initWithSectionRowCounts:@[@(10)] selectedIndexPaths:nil registerHandler:^{
            [weakSelf registerClass:[TSDownloadCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
            
        } cellForItemAtIndexPath:^UICollectionViewCell * _Nonnull(UICollectionView * _Nonnull bCollectionView, NSIndexPath * _Nonnull bIndexPath, CQTSLocImageDataModel * _Nonnull downloadModel) {
            TSDownloadCollectionViewCell *cell = [bCollectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:bIndexPath];
            
            
            cell.downloadView.downloadUrl = downloadModel.imageName;
            cell.downloadView.downloadUrlLabel.text = downloadModel.name;
            
            
            !weakSelf.cellConfigBlock ?: weakSelf.cellConfigBlock(cell);
            
            return cell;
        }];
        
        _ripeCollectionViewDelegate = [[CQTSRipeBaseCollectionViewDelegate alloc] initWithPerMaxCount:2 didSelectItemHandle:^(UICollectionView * _Nonnull bCollectionView, NSIndexPath * _Nonnull bIndexPath) {
            CQTSLocImageDataModel *downloadModel = [weakSelf.ripeCollectionViewDataSource dataModelAtIndexPath:bIndexPath];
            !didSelectItemAtIndexHandle ?: didSelectItemAtIndexHandle(downloadModel);
        }];
        
        self.dataSource = self.ripeCollectionViewDataSource;
        self.delegate = self.ripeCollectionViewDelegate;
    }
    return self;
}


@end
