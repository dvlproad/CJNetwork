//
//  CQIndicatorHUDUtil.m
//  AppCommonUICollect
//
//  Created by ciyouzen on 2018/9/20.
//  Copyright © 2018年 dvlproad. All rights reserved.
//

#import "CQIndicatorHUDUtil.h"
#import <CJPopupAnimation/UIView+CJToastInView.h>

@interface CQIndicatorHUDUtil ()

@end

@implementation CQIndicatorHUDUtil

/// 隐藏hud
+ (void)dismissLoadingHUD {
    CJIndicatorProgressHUDView *hudView = [CJIndicatorProgressHUDView sharedInstance];
    [hudView cj_toastHiddenWithAnimated:YES afterDelay:0];
}

#pragma mark - Loading HUD
+ (void)showLoadingHUD:(NSString *)message {
    CJIndicatorProgressHUDView *hudView = [CJIndicatorProgressHUDView sharedInstance];
    [hudView reloadWithLoadingAndMessage:message];
    
    
    CGSize hudViewSize = CGSizeMake(150, 150);
    [hudView cj_toastCenterInView:nil
                         withSize:hudViewSize
                     centerOffset:CGPointZero animated:YES];
}


#pragma mark - 有图片的HUD
+ (void)showSuccess:(NSString *)message {
    UIImage *successImage = [UIImage imageNamed:@"CQIndicatorHUDUtil.bundle/HUD_success"];
    [self showMessage:message image:successImage];
}

+ (void)showFailure:(NSString *)message {
    UIImage *errorImage = [UIImage imageNamed:@"CQIndicatorHUDUtil.bundle/HUD_error"];
    [self showMessage:message image:errorImage];
}

+ (void)showInfo:(NSString *)message {
    UIImage *infoImage = [UIImage imageNamed:@"CQIndicatorHUDUtil.bundle/HUD_info"];
    [self showMessage:message image:infoImage];
}

+ (void)showMessage:(NSString *)message image:(UIImage *)image {
    CJIndicatorProgressHUDView *hudView = [CJIndicatorProgressHUDView sharedInstance];
    [hudView reloadWithMessage:message image:image];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:hudView];
    

    CGSize hudViewSize = CGSizeMake(150, 150);
    [hudView cj_toastCenterInView:nil
                         withSize:hudViewSize
                     centerOffset:CGPointZero animated:YES];
}


#pragma mark - 获取与全局动画一致的ProgressHUD对象
/**
 *  获取与全局动画一致的新的的ProgressHUD对象
 */
+ (CJIndicatorProgressHUDView *)defaultLoadingHUD {
    CJIndicatorProgressHUDView *hudView = [[CJIndicatorProgressHUDView alloc] init];
    return hudView;
}

@end
