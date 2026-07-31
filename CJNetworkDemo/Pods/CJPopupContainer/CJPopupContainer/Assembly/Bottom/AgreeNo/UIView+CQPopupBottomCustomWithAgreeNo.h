//
//  UIView+CQPopupBottomCustomWithAgreeNo.h
//  TSPopupDemo
//
//  Created by ciyouzen on 2021/9/26.
//
//  自定义的视图 + 同意/不同意按钮组 后的 视图弹出与关闭(常用于：从底部弹出隐私政策视图)

#import <UIKit/UIKit.h>
#import "CJBottomBlankView.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIView (CQPopupBottomCustomWithAgreeNo)

+ (CJBottomBlankView *)cqBottomAgreeNoBlankViewWithCustomView:(UIView *)customView
                                             customViewHeight:(CGFloat)customViewHeight
                                                  cancelBlock:(void(^)(CJBottomBlankView *bBlankView))cancelBlock
                                                      okBlock:(void(^)(CJBottomBlankView *bBlankView))okBlock;

@end

NS_ASSUME_NONNULL_END
