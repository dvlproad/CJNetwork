//
//  CQTSRipeButtonCollectionView.m
//  CJUIKitDemo
//
//  Created by ciyouzen on 8/10/15.
//  Copyright (c) 2015 dvlproad. All rights reserved.
//

#import "CQTSRipeButtonCollectionView.h"
#import <CQDemoKit/CQTSRipeBaseCollectionViewDelegate.h>
#import <CQDemoKit/CQTSRipeBaseCollectionViewDataSource.h>
#import <CQDemoKit/CQTSRipeButtonCollectionViewCell.h>

@interface CQTSRipeButtonCollectionView ()<UICollectionViewDelegate> {
    
}
@property (nonatomic, strong) NSMutableArray<NSString *> *buttonTitles;
@property (nullable, nonatomic, copy, readonly) void(^didSelectItemAtIndexHandle)(NSInteger index); /**< 点击item的回调 */

@property (nonatomic, strong, readonly) CQTSRipeBaseCollectionViewDelegate *ripeCollectionViewDelegate;   /**< collectionView的delegate */
@property (nonatomic, strong, readonly) CQTSRipeBaseCollectionViewDataSource *ripeCollectionViewDataSource;   /**< collectionView的dataSource */

@end


@implementation CQTSRipeButtonCollectionView
/*
#pragma mark - RadioButton
/// 单行的 单选按钮组合
+ (instancetype)rowRadioButtonsWithHorizontalMargin:(CGFloat)horizontalMargin
                                             height:(CGFloat)height
                                             titles:(NSArray<NSString *> *)buttonTitles
                         didSelectItemAtIndexHandle:(void(^)(NSInteger index))didSelectItemAtIndexHandle
{
    CGFloat width = UIScreen.mainScreen.bounds.size.width - 2*horizontalMargin;
    return [[CQTSRipeButtonCollectionView alloc] initWithTitles:buttonTitles width:width height:height scrollDirection:UICollectionViewScrollDirectionVertical didSelectItemAtIndexHandle:didSelectItemAtIndexHandle];
}

/// 单列的 单选按钮组合
+ (instancetype)columnRadioButtonsWithWidth:(CGFloat)width
                                     height:(CGFloat)height
                                     titles:(NSArray<NSString *> *)buttonTitles
                 didSelectItemAtIndexHandle:(void(^)(NSInteger index))didSelectItemAtIndexHandle
{
    return [[CQTSRipeButtonCollectionView alloc] initWithTitles:buttonTitles width:width height:height scrollDirection:UICollectionViewScrollDirectionHorizontal didSelectItemAtIndexHandle:didSelectItemAtIndexHandle];
}


/// 初始化 单行或单列的按钮组
///
/// @param buttonTitles                 按钮的标题数组
/// @param width                        视图的宽度
/// @param height                       视图的高度
/// @param scrollDirection              集合视图的滚动方向
/// @param didSelectItemAtIndexHandle   点击item的回调
///
/// @return CollectionView
- (instancetype)initWithTitles:(NSArray<NSString *> *)buttonTitles
                         width:(CGFloat)width
                        height:(CGFloat)height
               scrollDirection:(UICollectionViewScrollDirection)scrollDirection
    didSelectItemAtIndexHandle:(void(^)(NSInteger index))didSelectItemAtIndexHandle
{
    // 计算 itemSize
    CGFloat collectionViewCellWidth = 0;
    CGFloat collectionViewCellHeight = 0;
    BOOL isScrollHorizontal = scrollDirection == UICollectionViewScrollDirectionHorizontal;
    if (isScrollHorizontal) {   // 按水平方向滚动时，按个数计算cell的高
        NSInteger perColumnMaxRowCount = buttonTitles.count;
        
        UIEdgeInsets sectionInset = UIEdgeInsetsZero;
        CGFloat rowSpacing = 0;
        
        CGFloat validHeight = height - sectionInset.top - sectionInset.bottom - rowSpacing*(perColumnMaxRowCount-1);
        collectionViewCellHeight = floorf(validHeight/perColumnMaxRowCount);
        collectionViewCellWidth = width;
        
    } else {                    // 按竖直方向滚动时，按个数计算cell的宽
        NSInteger perRowMaxColumnCount = buttonTitles.count;
        
        UIEdgeInsets sectionInset = UIEdgeInsetsZero;
        CGFloat columnSpacing = 0;
        
        CGFloat validWith = width - sectionInset.left - sectionInset.right - columnSpacing*(perRowMaxColumnCount-1);
        collectionViewCellWidth = floorf(validWith/perRowMaxColumnCount);
        collectionViewCellHeight = height;
    }
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = scrollDirection;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = CGSizeMake(collectionViewCellWidth, collectionViewCellHeight);
    
    layout.scrollDirection = scrollDirection;
    self = [super initWithFrame:CGRectZero collectionViewLayout:layout];
    if (self) {
        _didSelectItemAtIndexHandle = didSelectItemAtIndexHandle;
        self.delegate = self;
        
        [self _setupDataSourceWithTitle:buttonTitles];
        
        //self.contentInset = UIEdgeInsetsMake(-10, 0, 0, 0);  // 抵消顶部间距
        self.scrollEnabled = NO;
    }
    return self;
}

#pragma mark - UICollectionViewDelegate
////“点到”item时候执行的时间(allowsMultipleSelection为默认的NO的时候，只有选中，而为YES的时候有选中和取消选中两种操作)
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.didSelectItemAtIndexHandle != nil) {
        self.didSelectItemAtIndexHandle(indexPath.item);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}
*/

#pragma mark - Init
/*
 *  初始化 指定行数或列数的CollectionView
 *
 *  @param buttonTitles                 按钮的标题数组
 *  @param perMaxCount                  当滚动方向为①水平时,每列显示几个；②竖直时,每行显示几个；
 *  @param widthHeightRatio             宽高比（一般为1.0）
 *  @param scrollDirection              集合视图的滚动方向
 *  @param didSelectItemAtIndexHandle   点击item的回调
 *
 *  @return CollectionView
 */
- (instancetype)initWithTitles:(NSArray<NSString *> *)buttonTitles
                   perMaxCount:(NSInteger)perMaxCount
              widthHeightRatio:(CGFloat)widthHeightRatio
               scrollDirection:(UICollectionViewScrollDirection)scrollDirection
    didSelectItemAtIndexHandle:(void(^)(NSInteger index))didSelectItemAtIndexHandle
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = scrollDirection;
    self = [super initWithFrame:CGRectZero collectionViewLayout:layout];
    if (self) {
        _ripeCollectionViewDelegate = [[CQTSRipeBaseCollectionViewDelegate alloc] initWithPerMaxCount:perMaxCount widthHeightRatio:widthHeightRatio didSelectItemHandle:^(UICollectionView * _Nonnull bCollectionView, NSIndexPath * _Nonnull bIndexPath) {
            !didSelectItemAtIndexHandle ?: didSelectItemAtIndexHandle(bIndexPath.item);
        }];
        self.delegate = self.ripeCollectionViewDelegate;
        
        
        [self _setupDataSourceWithTitle:buttonTitles];
        
    }
    return self;
}

- (void)_setupDataSourceWithTitle:(NSArray<NSString *> *)buttonTitles {
        __weak typeof(self) weakSelf = self;
    
        CQDMSectionDataModel *sectionDataModel = [[CQDMSectionDataModel alloc] init];
        sectionDataModel.theme = @"单选按钮的组合";
        sectionDataModel.values = [NSMutableArray arrayWithArray:buttonTitles];
        NSMutableArray<CQDMSectionDataModel *> *sectionDataModels = [NSMutableArray arrayWithArray:@[sectionDataModel]];
        _ripeCollectionViewDataSource = [[CQTSRipeBaseCollectionViewDataSource alloc] initWithSectionDataModels:sectionDataModels registerHandler:^{
            [weakSelf registerClass:[CQTSRipeButtonCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
            
        } cellForItemAtIndexPath:^UICollectionViewCell * _Nonnull(UICollectionView * _Nonnull bCollectionView, NSIndexPath * _Nonnull bIndexPath, id bDataModel) {
            NSString *dataModel = (NSString *)bDataModel;
            CQTSRipeButtonCollectionViewCell *cell = [bCollectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:bIndexPath];
            
            NSString *title = dataModel;
            cell.text = title;
            //cell.text = [NSString stringWithFormat:@"%zd", bIndexPath.item];
            
            !weakSelf.cellConfigBlock ?: weakSelf.cellConfigBlock(cell);
            
            return cell;
        }];
        self.dataSource = self.ripeCollectionViewDataSource;
}

#pragma mark - Public Method
- (void)didSelectItemAtIndex:(NSInteger)index {
    if (index < 0 || index >= [self numberOfItemsInSection:0]) return;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [self selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    !self.didSelectItemAtIndexHandle ?: self.didSelectItemAtIndexHandle(index);
}

@end
