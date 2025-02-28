//
//  TSDownloadCollectionView.h
//  CJUIKitDemo
//
//  Created by ciyouzen on 8/10/15.
//  Copyright (c) 2015 dvlproad. All rights reserved.
//
//  为了快速构建完整 Demo 工程提供的成熟的CollectionView(已含内容和事件)
//  为了提供给某些例子需要有多种情况的测试时候，而快速构建的【单排或单列的按钮组合CollectionView】

#import <UIKit/UIKit.h>
#import <CQDemoKit/CQDMSectionDataModel+CJDealTextModel.h>
#import <CQDemoKit/CQTSLocImageDataModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface TSDownloadCollectionView : UICollectionView {
    
}
@property (nullable, nonatomic, copy) void(^cellConfigBlock)(UICollectionViewCell *bCell); /**< cell的UI定制（有时候需要cell和其所在列表的背景色为透明） */
@property (nonatomic, strong) NSArray<CQDMSectionDataModel *> *sectionDataModels;    /**< 每个section的数据 */

#pragma mark - Init
/*
 *  初始化 CollectionView
 *
 *  @param didSelectItemAtIndexHandle   点击item的回调
 *
 *  @return CollectionView
 */
- (instancetype)initWithDidSelectItemAtIndexHandle:(void(^)(CQTSLocImageDataModel *downloadModel))didSelectItemAtIndexHandle NS_DESIGNATED_INITIALIZER;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

/* 初始化示例
NSArray<NSString *> *buttonTitles = @[@"按钮01", @"按钮02", @"按钮03", @"按钮04", @"按钮05", @"按钮06", @"按钮07", @"按钮08", @"按钮09", @"按钮10"];
TSDownloadCollectionView *collectionView = [[TSDownloadCollectionView alloc] initWithTitles:buttonTitles scrollDirection:UICollectionViewScrollDirectionHorizontal didSelectItemAtIndexHandle:^(NSInteger index) {
    NSString *title = buttonTitles[index];
    NSLog(@"点击了“%@”", title);
}];
collectionView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
collectionView.cellConfigBlock = ^(UICollectionViewCell * _Nonnull bCell) {
    bCell.contentView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    bCell.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
};
*/

@end

NS_ASSUME_NONNULL_END
