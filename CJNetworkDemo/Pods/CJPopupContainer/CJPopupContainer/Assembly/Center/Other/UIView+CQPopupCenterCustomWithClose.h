//
//  UIView+CQPopupCenterCustomWithClose.h
//  TSPopupDemo
//
//  Created by ciyouzen on 2019/10/22.
//  Copyright © 2019 dvlproad. All rights reserved.
//
//  中间自定义的视图 + 关闭按钮后的 视图弹出与关闭(常用于：从中间弹出说明列表视图)

#import <UIKit/UIKit.h>
@class CJCenterBlankView;

NS_ASSUME_NONNULL_BEGIN

@interface UIView (CQPopupCenterCustomWithClose)

+ (CJCenterBlankView *)cqCenterIKnowBlankViewWithCustomView:(UIView *)customView
                                        withClickIKnowBlock:(void(^)(void))clickIKnowBlock
                                            tapBlankDismiss:(void(^ _Nullable)(CJCenterBlankView *bSelf))tapBlankDismiss;

+ (CJCenterBlankView *)cqCenterCloseBlankViewWithCustomView:(UIView *)customView
                                            tapBlankDismiss:(void(^ _Nullable)(CJCenterBlankView *bSelf))tapBlankDismiss
                                              closeDismiss:(void(^ _Nullable)(CJCenterBlankView *blankView))closeDismiss;

@end

NS_ASSUME_NONNULL_END
