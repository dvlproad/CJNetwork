//
//  CQTSRipeButtonCollectionView.h
//  CJUIKitDemo
//
//  Created by ciyouzen on 8/10/15.
//  Copyright (c) 2015 dvlproad. All rights reserved.
//
//  有状态的单选按钮组
//  CQTSRipeButtonCollectionView：更适合【多行或者多列】的单选按钮的组合。
//  CQTSRadioButtonsView：        更适合【单行或者单列】的单选按钮的组合。
//  常见使用场景：为了提供给某些例子需要有多种情况的测试时候，而快速构建的【按钮组合】
//
//  为了快速构建完整 Demo 工程提供的成熟的CollectionView(已含内容和事件)

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CQTSRipeButtonCollectionView : UICollectionView {
    
}
@property (nullable, nonatomic, copy) void(^cellConfigBlock)(UICollectionViewCell *bCell); /**< cell的UI定制（有时候需要cell和其所在列表的背景色为透明） */
/*
#pragma mark - RadioButton
/// 单行的 单选按钮组合
+ (instancetype)rowRadioButtonsWithHorizontalMargin:(CGFloat)horizontalMargin
                                             height:(CGFloat)height
                                             titles:(NSArray<NSString *> *)buttonTitles
                         didSelectItemAtIndexHandle:(void(^)(NSInteger index))didSelectItemAtIndexHandle;

/// 单列的 单选按钮组合
+ (instancetype)columnRadioButtonsWithWidth:(CGFloat)width
                                     height:(CGFloat)height
                                     titles:(NSArray<NSString *> *)buttonTitles
                 didSelectItemAtIndexHandle:(void(^)(NSInteger index))didSelectItemAtIndexHandle;
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
    didSelectItemAtIndexHandle:(void(^)(NSInteger index))didSelectItemAtIndexHandle;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

/* 初始化示例
NSArray<NSString *> *buttonTitles = @[@"按钮01", @"按钮02", @"按钮03", @"按钮04", @"按钮05", @"按钮06", @"按钮07", @"按钮08", @"按钮09", @"按钮10"];
CQTSRipeButtonCollectionView *collectionView = [[CQTSRipeButtonCollectionView alloc] initWithTitles:buttonTitles perMaxCount:1  widthHeightRatio:88/44.0 scrollDirection:UICollectionViewScrollDirectionHorizontal didSelectItemAtIndexHandle:^(NSInteger index) {
    NSString *title = buttonTitles[index];
    NSLog(@"点击了“%@”", title);
}];
collectionView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
collectionView.cellConfigBlock = ^(UICollectionViewCell * _Nonnull bCell) {
    bCell.contentView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    bCell.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
};
*/

#pragma mark - Public Method
/// 主动选中某项（更新UI并触发回调）
- (void)didSelectItemAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
