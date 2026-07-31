//
//  UIView+CJToastAnimation.h
//  CJPopupAction
//
//  Created by ciyouzen on 15/11/12.
//  Copyright (c) 2015年 dvlproad. All rights reserved.
//
//  Toast动画：将视图居中显示，支持动画和延迟隐藏，无遮罩

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (CJToastAnimation)

/// 将当前视图Toast到superView中央（自动addSubview）
/// @param superView 显示到哪个视图中央（nil则使用keyWindow）
/// @param size toast视图的大小
/// @param centerOffset toast视图的中心与superView中心的偏移量
/// @param animated 是否要动画
- (void)cj_toastCenterInView:(nullable UIView *)superView
                    withSize:(CGSize)size
                centerOffset:(CGPoint)centerOffset
                    animated:(BOOL)animated;

/// 隐藏弹出的toast视图
/// @param animated 是否要动画
/// @param delay 多少秒后执行隐藏
- (void)cj_toastHiddenWithAnimated:(BOOL)animated afterDelay:(NSTimeInterval)delay;

@end

NS_ASSUME_NONNULL_END
