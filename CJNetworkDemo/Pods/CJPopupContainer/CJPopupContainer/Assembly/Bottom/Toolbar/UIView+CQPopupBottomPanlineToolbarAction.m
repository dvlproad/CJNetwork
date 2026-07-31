//
//  UIView+CQPopupBottomPanlineToolbarAction.m
//  AppCommonUICollect
//
//  Created by ciyouzen on 2019/8/13.
//  Copyright © 2019 dvlproad. All rights reserved.
//

#import "UIView+CQPopupBottomPanlineToolbarAction.h"

#import "CQBottomPanlineBlankView.h"
#import "CQBottomCustomWithPanlineView.h"
#import "CJBottomBlankView.h"

#import "CQBottomCustomWithToolbarView.h"





@implementation UIView (CQPopupBottomPanlineToolbarAction)


#pragma mark - 从底部弹出当前视图的相关代码
- (CQBottomPanlineAndToolbarBlankView *)cqPopup_bottom_with_panline_toolbarWithoutOKWithHeight:(CGFloat)selfHeight
                                                                                   toolbarTitle:(NSString *)title
                                                                             shouldAddPanAction:(BOOL)shouldAddPanAction
                                                                             panCompleteDismiss:(void(^ _Nullable)(CQBottomPanlineAndToolbarBlankView *bBlankView))panCompleteDismiss
                                                                                tapBlankDismiss:(void(^ _Nullable)(CQBottomPanlineAndToolbarBlankView *bBlankView, BOOL bToolbarOKEnable))tapBlankDismiss
{
    CQBottomPanlineAndToolbarBlankView *blankView = [[CQBottomPanlineAndToolbarBlankView alloc] initWithShowPanLine:shouldAddPanAction customViewWithoutPanlineAndToolbar:self customViewWithoutPanlineAndToolbarHeight:selfHeight panCompleteDismissBlock:^(CQBottomPanlineBlankView *bBlankView) {
        !panCompleteDismiss ?: panCompleteDismiss(bBlankView);
    } tapBlankHandle:^(CQBottomPanlineBlankView *bBlankView, BOOL bToolbarOKEnable) {
        !tapBlankDismiss ?: tapBlankDismiss(bBlankView, bToolbarOKEnable);
    }];
    
    CQBottomCustomWithToolbarView *customViewWithToolbar = blankView.customViewWithToolbar;
    [customViewWithToolbar updateBgType:CQBottomPopupViewBGThemeNone];
    CQBottomToolbarView *toolbar = customViewWithToolbar.toolbar;
    [toolbar configToolTitle:title];
    
    CQBottomBlankAndPanlinePopupPart effectType = CQBottomBlankAndPanlinePopupPartBlankView;
    CQEffectStyle effectStyle = CQEffectStyleBlurDark;
    CQBottomBlankAndPanlinePopupPart cornerViewPart = CQBottomBlankAndPanlinePopupPartPopupViewWithoutPanLine;
    [blankView effectAndCornerWithEffectViewPart:effectType effectStyle:effectStyle cornerViewPart:cornerViewPart];
    
    return blankView;
}

- (CQBottomPanlineAndToolbarBlankView *)cqPopup_bottom_with_panline_toolbarWithOKWithHeight:(CGFloat)selfHeight
                                      selfBGType:(CQBottomPopupViewBGTheme)selfBGType
                                  effectViewPart:(CQBottomBlankAndPanlinePopupPart)effectViewPart
                                     effectStyle:(CQEffectStyle)effectStyle
                                    toolbarTitle:(NSString *)toolbarTitle
                                 toolbarOKHandle:(void(^)(CQBottomPanlineAndToolbarBlankView *bBlankView, UIView *bSelfView))toolbarOKHandle
                              shouldAddPanAction:(BOOL)shouldAddPanAction
                                  tapBlankHandle:(void(^ _Nullable)(CQBottomPanlineAndToolbarBlankView *bBlankView, UIView *bSelfView, BOOL toolbarOKEnable))tapBlankHandle
                              panCompleteDismiss:(void(^ _Nullable)(CQBottomPanlineBlankView *bBlankView))panCompleteDismiss
                                   cancelDismiss:(void(^ _Nullable)(CQBottomPanlineAndToolbarBlankView *bBlankView))cancelDismiss
{
    __weak typeof(self)weakSelf = self;
    
    CQBottomPanlineAndToolbarBlankView *blankView = [[CQBottomPanlineAndToolbarBlankView alloc] initWithShowPanLine:shouldAddPanAction customViewWithoutPanlineAndToolbar:self customViewWithoutPanlineAndToolbarHeight:selfHeight panCompleteDismissBlock:^(CQBottomPanlineBlankView * _Nonnull bBlankView) {
        !panCompleteDismiss ?: panCompleteDismiss(bBlankView);
    } tapBlankHandle:^(CQBottomPanlineBlankView * _Nonnull bBlankView, BOOL bToolbarOKEnable) {
        !tapBlankHandle ?: tapBlankHandle(bBlankView, weakSelf, bToolbarOKEnable);
    }];
    
    CQBottomCustomWithToolbarView *customViewWithToolbar = blankView.customViewWithToolbar;
    [customViewWithToolbar updateBgType:selfBGType];
    CQBottomToolbarView *toolbar = customViewWithToolbar.toolbar;
    [toolbar configToolTitle:toolbarTitle];
    [toolbar configCancelButtonTitle:NSLocalizedString(@"取消", nil) cancelButtonHandle:^{
        !cancelDismiss ?: cancelDismiss(blankView);
    }];
    [toolbar configOKButtonTitle:NSLocalizedString(@"完成", nil) okButtonHandle:^{
        !toolbarOKHandle ?: toolbarOKHandle(blankView, weakSelf);
    }];
    
    [blankView effectAndCornerWithEffectViewPart:effectViewPart
                                     effectStyle:effectStyle
                                  cornerViewPart:CQBottomBlankAndPanlinePopupPartNone];
    
    return blankView;
}

#pragma mark - Get View(比较少用)
/*
 *  获取包含着本视图的弹出视图中的toolbar
 *
 *  使用场景：
    1、更新视图的工具栏上的标题（常见场景：①输入文字时候，显示剩余几个字；②地点选择时候，实时更新对应的地点文本）
    2、更新视图的工具栏上的确认按钮文本（默认是"完成"，需要更新的话，要调用此方法）
    3、更新视图的工具栏上的确认按钮的enable（场景：输入文字时候，有输入文字允许点击完成，没输入不允许点击完成）
 *
 */
- (CQBottomToolbarView *)cqPopup_bottom_with_panline_toolbar_getToolbar {
    CJBottomBlankView *blankView = [CQBottomPanlineAndToolbarBlankView blankViewFromCustomViewWithoutPanlineAndToolbar:self];
    CQBottomCustomWithPanlineView *popupView = blankView.popupView;
    CQBottomCustomWithToolbarView *customViewWithToolbar = popupView.customView;
    CQBottomToolbarView *toolbar = customViewWithToolbar.toolbar;
    return toolbar;
}

// 最后的实际弹窗（目前的使用场景：弹出的视图中包含文本框，需要通过此属性来注册通知，从而在键盘弹出和不弹出时候显示在弹框中的不同位置）
- (UIView *)cqPopup_bottom_with_panline_toolbar_realPopupView {
    CJBottomBlankView *blankView = [CQBottomPanlineAndToolbarBlankView blankViewFromCustomViewWithoutPanlineAndToolbar:self];
    CQBottomCustomWithPanlineView *popupView = blankView.popupView;
    return popupView;
}


#pragma mark - Update SelfHeight(比较少用)
/*
 *  更新popupView视图的高度，内部会同时更新realPopupView的高度（常使用带有输入文本框的弹出视图，随着输入内容的长度变化，高度会变化）
 *  @brief: 此方法的调用者为除toolbar外的那个popupView(非realPopupView)
 *
 *  @param selfHeight                   本视图未加顶部下拉线和顶部工具栏时候的干净高度
 （即使本视图最终是由其他视图包着弹出,这里也只输入本视图被干净弹出的高度,实际最终的弹窗高度,内部会自动计算后以最终高度弹出)
 */
- (void)cqPopup_bottom_with_panline_toolbar_updatePopupContentHeight:(CGFloat)selfHeight {
    CJBottomBlankView *blankView = [CQBottomPanlineAndToolbarBlankView blankViewFromCustomViewWithoutPanlineAndToolbar:self];
    CQBottomCustomWithPanlineView *popupView = blankView.popupView;
    
    CQBottomCustomWithToolbarView *customViewWithToolbar = popupView.customView;
    CGFloat customViewWithToolbarHeight = [CQBottomCustomWithToolbarView contentViewHeightWithCustomViewHeight:selfHeight];
    
    CGFloat popupViewHeight = [popupView viewHeightWithCustomViewHeight:customViewWithToolbarHeight];
    
    [blankView updatePopupViewHeight:popupViewHeight];
}

@end
