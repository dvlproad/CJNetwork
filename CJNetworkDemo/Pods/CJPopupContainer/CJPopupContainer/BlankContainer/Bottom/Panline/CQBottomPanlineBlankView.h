//
//  CQBottomPanlineBlankView.h
//  CJBlankPresenter
//
//  Created by ciyouzen on 2021/10/13.
//
//  带下拉线的底部弹窗（blankView），初始化方法以 CQBottomCustomWithPanlineView 为 popupView，层级关系：
//
//  CQBottomPanlineBlankView          ← 本类：blankView（背景遮罩 + 点击消失 + 拖拽关闭）
//    └── CQBottomCustomWithPanlineView   ← popupView（组装 customView + 下拉线）
//          ├── CQPanLineView             ← 顶部下拉线（SubView/）
//          └── customView                ← 用户自定义内容

#import "CJBottomBlankView.h"
#import "CQEffectEnum.h"

#import "CQBottomBlankAndPanlinePopupEnum.h"

NS_ASSUME_NONNULL_BEGIN

@interface CQBottomPanlineBlankView : CJBottomBlankView {
    
}

#pragma mark - Init
/*
 *  初始化包含popupView的【底部完整弹出框视图】
 *
 *  @param showPanLine                      是否显示下拉线
 *  @param customViewWithoutPanline         下拉线视图除外的其他视图
 *  @param customViewWithoutPanlineHeight   下拉线视图除外的其他视图的高度
 *  @param tapBlankHandle                   点击视图的回调（每一个弹窗的背景点击回调都不一样）
 *  @param panCompleteDismissBlock          拖动结束需要执行dimiss的回调(showPanLine为NO的时候，此值无效，相当于设为nil)
 *
 *  @return 包含popupView的【底部完整弹出框视图】
 */
- (instancetype)initWithShowPanLine:(BOOL)showPanLine
           customViewWithoutPanline:(UIView *)customViewWithoutPanline
     customViewWithoutPanlineHeight:(CGFloat)customViewWithoutPanlineHeight
            panCompleteDismissBlock:(void(^ _Nullable)(CQBottomPanlineBlankView *bBlankView))panCompleteDismissBlock
                     tapBlankHandle:(void(^ _Nullable)(CQBottomPanlineBlankView *bBlankView))tapBlankHandle NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithPopupView:(UIView *)popupView
                  popupViewHeight:(CGFloat)popupViewHeight
                   tapBlankHandle:(void(^ _Nullable)(CJBasePopupBlankView *bSelf))tapBlankHandle NS_UNAVAILABLE;


#pragma mark - Get Method
/// 通过 customViewWithoutPanline 获取到其所在的 blankView ，常用于customViewWithoutPanline的点击需要让 blankView 执行隐藏等动作时候使用
+ (CJBottomBlankView *)blankViewFromCustomViewWithoutPanline:(UIView *)customViewWithoutPanline;
+ (CJBottomBlankView *)blankViewFromPopupView:(UIView *)popupView NS_UNAVAILABLE;

#pragma mark - 设置模糊化和圆角化
/*
 *  对弹出视图进行【模糊指定区域】和【圆角化指定区域】
 *
 *  @param effectViewPart       要添加模糊化的是视图的哪个部分
 *  @param effectStyle          要添加的模糊效果是【什么类型】
 *  @param cornerViewPart       圆角化（注:如果圆角的区域刚好等于被进行模糊的区域，则模糊的区域也要圆角）
 */
- (void)effectAndCornerWithEffectViewPart:(CQBottomBlankAndPanlinePopupPart)effectViewPart
                              effectStyle:(CQEffectStyle)effectStyle
                           cornerViewPart:(CQBottomBlankAndPanlinePopupPart)cornerViewPart;

@end

NS_ASSUME_NONNULL_END
