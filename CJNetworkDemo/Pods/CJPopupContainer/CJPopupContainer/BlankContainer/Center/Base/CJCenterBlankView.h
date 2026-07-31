//
//  CJCenterBlankView.h
//  CJUIKitDemo
//
//  Created by ciyouzen on 15/11/12.
//  Copyright (c) 2015年 dvlproad. All rights reserved.
//

#import "CJBasePopupBlankView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CJCenterBlankView : CJBasePopupBlankView {
    
}
@property (nonatomic, strong, readonly) UIView *popupView;      /**< 需要弹出的视图 */
@property (nonatomic, assign, readonly) CGSize popupViewSize;   /**< 需要弹出的视图的大小 */

#pragma mark - Init
/*
 *  初始化包含popupView的【底部完整弹出框视图】
 *
 *  @param popupView            弹出视图的内容视图
 *  @param popupViewSize        弹出视图的大小
 *  @param popupCenterOffset    弹窗弹出位置的中心与window中心的偏移量
 *  @param tapBlankHandle       点击视图的回调（每一个弹窗的背景点击回调都不一样）
 *
 *  @return 包含popupView的【底部完整弹出框视图】
 */
- (instancetype)initWithPopupView:(UIView *)popupView
                    popupViewSize:(CGSize)popupViewSize
                popupCenterOffset:(CGPoint)popupCenterOffset
                   tapBlankHandle:(void(^ _Nullable)(CJCenterBlankView *bSelf))tapBlankHandle NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithTapBlankHandle:(void(^ _Nullable)(CJBasePopupBlankView *bSelf))tapBlankHandle NS_UNAVAILABLE;


#pragma mark - Get Method
/// 通过 popupView 获取到其所在的 blankView ，常用于popupView的点击需要让 blankView 执行隐藏等动作时候使用
+ (CJCenterBlankView *)blankViewFromPopupView:(UIView *)popupView;

#pragma mark - updateConstraints
/*
 *  更新约束，根据是否显示popupView
 *
 *  @param show     是否显示popupView
 */
- (void)updateConstraintsForPopupViewWithShow:(BOOL)show;

/*
 *  更新弹出视图的内容视图的高度（场景：弹出视图popupView中含有可以随着输入的文本变化高度的文本框）
 *
 *  @param popupViewHeight      弹出视图的高度
 */
- (void)updatePopupViewHeight:(CGFloat)newPopupViewHeight;


@end

NS_ASSUME_NONNULL_END
