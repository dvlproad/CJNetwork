//
//  UIView+CQBottomCustomWithClose.h
//  TSPopupDemo
//
//  Created by ciyouzen on 2019/8/27.
//  Copyright © 2019 dvlproad. All rights reserved.
//
//  自定义的视图 + 右上角关闭按钮后的 视图弹出与关闭(常用于：从底部弹出"使用规则"视图)

#import <UIKit/UIKit.h>
#import "CQBottomPanlineBlankView.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIView (CQBottomCustomWithClose)

+ (CQBottomPanlineBlankView *)cqBottomCloseBlankViewWithCustomView:(UIView *)customView
                                                   customViewHeight:(CGFloat)customViewHeight
                                                         closeBlock:(void(^ _Nullable)(CQBottomPanlineBlankView *bBlankView))closeBlock
                                                   tapBlankDismiss:(void(^ _Nullable)(CQBottomPanlineBlankView *bBlankView))tapBlankDismiss;

@end

NS_ASSUME_NONNULL_END
