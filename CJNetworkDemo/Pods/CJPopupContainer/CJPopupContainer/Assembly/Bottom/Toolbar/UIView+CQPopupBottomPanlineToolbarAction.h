//
//  UIView+CQPopupBottomPanlineToolbarAction.h
//  AppCommonUICollect
//
//  Created by ciyouzen on 2019/8/13.
//  Copyright © 2019 dvlproad. All rights reserved.
//
//  一个包着①自身和②【公共的顶部的PanLine（可定义是否添加）】和③toolbar的【容器视图】来作为最终视图弹出
//  不适用于：还需要对弹出的视图再进行定制，如设置自定义的okTitle和在弹出视图为文本框的时候，根据输入文本长度，设置toolbar的title
//  如果还需要对弹出的视图再进行定制，请参照 UIView+CQPopupBottomCustomEditView.h 里的来写

#import <UIKit/UIKit.h>
#import "CQEffectAndCornerHelper.h"
#import "CQBottomBlankAndPanlinePopupEnum.h"
#import "CQBottomCustomWithToolbarViewEnum.h"
#import "CQBottomToolbarView.h"
#import "CQBottomPanlineBlankView.h"
#import "CQBottomPanlineAndToolbarBlankView.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIView (CQPopupBottomPanlineToolbarAction) {
    
}

#pragma mark - 从底部弹出当前视图的相关代码
/*
 *  将当前视图加上toolbar(没有确认按钮)显示到window底部
 *
 *  @param selfHeight                       本视图未加顶部下拉线和顶部工具栏时候的干净高度
            （即使本视图最终是由其他视图包着弹出,这里也只输入本视图被干净弹出的高度,实际最终的弹窗高度,内部会自动计算后以最终高度弹出)
 *  @param title                            弹出视图的上部toolbar中的title
 *  @param shouldAddPanAction               是否添加仿抖音评论的下拉拖动手势(附对于那些会弹出键盘的视图，一般设为NO，即不添加)
 *
 *  @return 构建好的包含panline+toolbar的 blankView
 */
- (CQBottomPanlineAndToolbarBlankView *)cqPopup_bottom_with_panline_toolbarWithoutOKWithHeight:(CGFloat)selfHeight
                                                                                   toolbarTitle:(NSString *)title
                                                                             shouldAddPanAction:(BOOL)shouldAddPanAction
                                                                             panCompleteDismiss:(void(^ _Nullable)(CQBottomPanlineAndToolbarBlankView *bBlankView))panCompleteDismiss
                                                                                tapBlankDismiss:(void(^ _Nullable)(CQBottomPanlineAndToolbarBlankView *bBlankView, BOOL bToolbarOKEnable))tapBlankDismiss;


/*
 *  将当前视图加上toolbar(有确认按钮)显示到window底部
 *
 *  @param selfHeight                       本视图未加顶部下拉线和顶部工具栏时候的干净高度
            （即使本视图最终是由其他视图包着弹出,这里也只输入本视图被干净弹出的高度,实际最终的弹窗高度,内部会自动计算后以最终高度弹出)
 *  @param bgType                           背景类型
 *  @param effectViewPart                   要添加模糊化的是视图的哪个部分
 *  @param effectStyle                  要添加的模糊效果是【什么类型】
 *  @param title                            弹出视图的上部toolbar中的title
 *  @param okHandle                         确认事件
 *  @param shouldAddPanAction               是否添加仿抖音评论的下拉拖动手势(附对于那些会弹出键盘的视图，一般设为NO，即不添加)
 *  @param tapBlankHandle                   点击空白区域执行的操作
 *
 *  @return 构建好的包含panline+toolbar的 blankView
 */
- (CQBottomPanlineAndToolbarBlankView *)cqPopup_bottom_with_panline_toolbarWithOKWithHeight:(CGFloat)selfHeight
                                                                                  selfBGType:(CQBottomPopupViewBGTheme)selfBGType
                                                                              effectViewPart:(CQBottomBlankAndPanlinePopupPart)effectViewPart
                                                                                 effectStyle:(CQEffectStyle)effectStyle
                                                                                toolbarTitle:(NSString *)toolbarTitle
                                                                             toolbarOKHandle:(void(^)(CQBottomPanlineAndToolbarBlankView *bBlankView, UIView *bSelfView))toolbarOKHandle
                                                                          shouldAddPanAction:(BOOL)shouldAddPanAction
                                                                              tapBlankHandle:(void(^ _Nullable)(CQBottomPanlineAndToolbarBlankView *bBlankView, UIView *bSelfView, BOOL toolbarOKEnable))tapBlankHandle
                                                                            panCompleteDismiss:(void(^ _Nullable)(CQBottomPanlineBlankView *bBlankView))panCompleteDismiss
                                                                                  cancelDismiss:(void(^ _Nullable)(CQBottomPanlineAndToolbarBlankView *bBlankView))cancelDismiss;


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
- (CQBottomToolbarView *)cqPopup_bottom_with_panline_toolbar_getToolbar;

// 最后的实际弹窗（目前的使用场景：弹出的视图中包含文本框，需要通过此属性来注册通知，从而在键盘弹出和不弹出时候显示在弹框中的不同位置）
- (UIView *)cqPopup_bottom_with_panline_toolbar_realPopupView;


#pragma mark - Update SelfHeight(比较少用)
/*
 *  更新popupView视图的高度，内部会同时更新realPopupView的高度（常使用带有输入文本框的弹出视图，随着输入内容的长度变化，高度会变化）
 *  @brief: 此方法的调用者为除toolbar外的那个popupView(非realPopupView)
 *
 *  @param selfHeight                   本视图未加顶部下拉线和顶部工具栏时候的干净高度
 （即使本视图最终是由其他视图包着弹出,这里也只输入本视图被干净弹出的高度,实际最终的弹窗高度,内部会自动计算后以最终高度弹出)
 */
- (void)cqPopup_bottom_with_panline_toolbar_updatePopupContentHeight:(CGFloat)selfHeight;

@end

NS_ASSUME_NONNULL_END
