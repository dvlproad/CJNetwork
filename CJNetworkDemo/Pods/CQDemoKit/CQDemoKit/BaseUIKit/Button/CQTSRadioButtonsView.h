//
//  CQTSRadioButtonsView.h
//  CJUIKitDemo
//
//  Created by ciyouzen on 7/9/15.
//  Copyright (c) 2015 dvlproad. All rights reserved.
//
//  有状态的单选按钮组
//  CQTSRipeButtonCollectionView：更适合【多行或者多列】的单选按钮的组合。
//  CQTSRadioButtonsView：        更适合【单行或者单列】的单选按钮的组合。
//  常见使用场景：为了提供给某些例子需要有多种情况的测试时候，而快速构建的【按钮组合】

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>

NS_ASSUME_NONNULL_BEGIN

@interface CQTSRadioButtonsView : UIView {
    
}
#pragma mark - Init
/// 初始化 单行或单列的按钮组
///
/// @param titles                                              按钮的标题数组
/// @param axisType                                         按钮排列的方向（竖直/水平）
/// @param fixedSpacing                                 按钮之间的间距
/// @param didSelectItemAtIndexHandle  当前点击按钮的点击事件
///
/// @return 单选按钮组
- (instancetype)initWithTitles:(NSArray<NSString *> *)titles
                     alongAxis:(MASAxisType)axisType
                  fixedSpacing:(CGFloat)fixedSpacing
    didSelectItemAtIndexHandle:(void(^)(NSInteger index))didSelectItemAtIndexHandle NS_DESIGNATED_INITIALIZER;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

#pragma mark - Public Method
/// 主动选中某项（更新UI并触发回调）
- (void)didSelectItemAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
