//
//  CQIndicatorHUDUtil.h
//  AppCommonUICollect
//
//  Created by ciyouzen on 2018/9/20.
//  Copyright © 2018年 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CJOverlayView/CJIndicatorProgressHUDView.h>

@interface CQIndicatorHUDUtil : UIView

/// 隐藏hud
+ (void)dismissLoadingHUD;

#pragma mark - Loading HUD
+ (void)showLoadingHUD:(NSString *)message;


#pragma mark - 有图片的HUD
+ (void)showSuccess:(NSString *)message;
+ (void)showFailure:(NSString *)message;
+ (void)showInfo:(NSString *)message;

+ (void)showMessage:(NSString *)message image:(UIImage *)image;


#pragma mark - 获取与全局动画一致的ProgressHUD对象
/**
 *  获取与全局动画一致的新的的ProgressHUD对象
 */
+ (CJIndicatorProgressHUDView *)defaultLoadingHUD;

@end
