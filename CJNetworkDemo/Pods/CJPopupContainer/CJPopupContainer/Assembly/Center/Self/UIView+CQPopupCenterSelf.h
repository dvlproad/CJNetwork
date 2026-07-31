//
//  UIView+CQPopupCenterSelf.h
//  CJPopupContainer
//
//  Created by ciyouzen on 2019/10/22.
//

#import <UIKit/UIKit.h>
#import <CJPopupContainer/CJCenterBlankView.h>
#import <CJPopupContainer/CQEffectEnum.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (CQPopupCenterSelf)

/*
 *  组装：居中弹窗（将自定义视图直接作为 popupView）
 *
 *  @param popupView            弹出视图的内容视图
 *  @param popupViewSize        弹出视图的大小
 *  @param popupCenterOffset    弹窗弹出位置的中心与window中心的偏移量
 *  @param effectStyle          要添加的模糊效果是【什么类型】
 *  @param tapBlankDismiss      点击背景的回调（为nil时不做任何操作，如需点击隐藏请自行调用 blankView 的 hideBlankView）
 *
 *  @return 组装好的居中空白视图
 */
+ (CJCenterBlankView *)cqCenterBlankViewWithPopupView:(UIView *)popupView
                                      popupViewSize:(CGSize)popupViewSize
                                  popupCenterOffset:(CGPoint)popupCenterOffset
                                       effectStyle:(CQEffectStyle)effectStyle
                                    tapBlankDismiss:(void(^ _Nullable)(CJCenterBlankView *bSelf))tapBlankDismiss;

@end

NS_ASSUME_NONNULL_END
