//
//  UIView+CQPopupBottomSelf.h
//  CJPopupContainer
//
//  Created by ciyouzen on 2019/10/22.
//

#import <UIKit/UIKit.h>
#import <CJPopupContainer/CJBottomBlankView.h>
#import <CJPopupContainer/CQEffectEnum.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (CQPopupBottomSelf)

/*
 *  组装：底部弹窗（将自定义视图直接作为 popupView）
 *
 *  @param popupView            弹出视图的内容视图
 *  @param popupViewHeight      弹出视图的高度
 *  @param effectStyle          要添加的模糊效果是【什么类型】
 *  @param shouldEnableTapBlank 是否允许点击空白区域（常设为YES，来实现点击空白区域来隐藏弹窗的功能）
 *  @param tapBlankComplete     当允许点击空白区域时候的执行事件(为nil时，点击会自动隐藏；非nil时候需要自己调用隐藏)
 *  @param shouldAddPanAction   是否添加仿抖音评论的下拉拖动手势(附对于那些会弹出键盘的视图，一般设为NO，即不添加)
 *  @param panCompleteDismissBlock  拖动结束需要执行dimiss的回调(shouldAddPanAction为NO的时候，此值无效，相当于设为nil)
 *
 *  @return 组装好的底部空白视图
 */
+ (CJBottomBlankView *)cqBottomBlankViewWithPopupView:(UIView *)popupView
                                     popupViewHeight:(CGFloat)popupViewHeight
                                        effectStyle:(CQEffectStyle)effectStyle
                               shouldEnableTapBlank:(BOOL)shouldEnableTapBlank
                                  tapBlankComplete:(void(^ _Nullable)(CJBottomBlankView *bBlankView))tapBlankComplete
                               shouldAddPanAction:(BOOL)shouldAddPanAction
                          panCompleteDismissBlock:(void(^ _Nullable)(CJBottomBlankView *bBlankView))panCompleteDismissBlock;

@end

NS_ASSUME_NONNULL_END
