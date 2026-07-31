//
//  CQBottomPanlineAndToolbarBlankView.h
//  CJBlankPresenter
//
//  Created by ciyouzen on 2021/10/13.
//

#import "CQBottomPanlineBlankView.h"
#import "CQBottomCustomWithToolbarView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CQBottomPanlineAndToolbarBlankView : CQBottomPanlineBlankView {
    
}

#pragma mark - Init
/*
 *  初始化包含popupView的【底部完整弹出框视图】
 *
 *  @param showPanLine                      是否显示下拉线
 *  @param customViewWithoutPanline         下拉线panline视图和toolbar视图都除外的其他视图
 *  @param customViewWithoutPanlineHeight   下拉线panline视图和toolbar视图都除外的其他视图的高度
 *  @param tapBlankHandle                   点击视图的回调（每一个弹窗的背景点击回调都不一样）
 *  @param panCompleteDismissBlock          拖动结束需要执行dimiss的回调(showPanLine为NO的时候，此值无效，相当于设为nil)
 *
 *  @return 包含popupView的【底部完整弹出框视图】
 */
- (instancetype)initWithShowPanLine:(BOOL)showPanLine
 customViewWithoutPanlineAndToolbar:(UIView *)customViewWithoutPanlineAndToolbar
customViewWithoutPanlineAndToolbarHeight:(CGFloat)customViewWithoutPanlineAndToolbarHeight
            panCompleteDismissBlock:(void(^ _Nullable)(CQBottomPanlineBlankView *bBlankView))panCompleteDismissBlock
                     tapBlankHandle:(void(^ _Nullable)(CQBottomPanlineBlankView *bBlankView, BOOL bToolbarOKEnable))tapBlankHandle NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithShowPanLine:(BOOL)showPanLine
           customViewWithoutPanline:(UIView *)customViewWithoutPanline
     customViewWithoutPanlineHeight:(CGFloat)customViewWithoutPanlineHeight
            panCompleteDismissBlock:(void(^ _Nullable)(CQBottomPanlineBlankView *bBlankView))panCompleteDismissBlock
                     tapBlankHandle:(void(^ _Nullable)(CQBottomPanlineBlankView *bBlankView))tapBlankHandle NS_UNAVAILABLE;



#pragma mark - Get SubView
/// 获取包含着 自定义视图+toolbar视图 的视图整体（实际上就是扣除下拉线以外的视图）
- (CQBottomCustomWithToolbarView *)customViewWithToolbar;

#pragma mark - Get Method
/// 通过 customViewWithoutPanlineAndToolbar 获取到其所在的 blankView ，常用于 toolbar的点击需要让 blankView 执行隐藏等动作时候使用
+ (CQBottomPanlineAndToolbarBlankView *)blankViewFromCustomViewWithoutPanlineAndToolbar:(UIView *)customViewWithoutPanlineAndToolbar;
+ (CJBottomBlankView *)blankViewFromCustomViewWithoutPanline:(UIView *)customViewWithoutPanline NS_UNAVAILABLE;
+ (CJBottomBlankView *)blankViewFromPopupView:(UIView *)popupView NS_UNAVAILABLE;

#pragma mark - Update SelfHeight(比较少用)
/*
 *  更新popupView视图的高度
 *  使用场景：带有输入文本框的弹出视图，随着输入内容的长度变化，高度会变化）
 *
 *  @param customViewWithoutPanlineAndToolbarHeight     下拉线panline视图和toolbar视图都除外的其他视图的高度
 */
- (void)updateHeightWithWithoutPanlineAndToolbarHeight:(CGFloat)customViewWithoutPanlineAndToolbarHeight;

@end

NS_ASSUME_NONNULL_END
