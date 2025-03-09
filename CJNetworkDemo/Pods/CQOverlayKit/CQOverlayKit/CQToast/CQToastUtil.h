//
//  CQToastUtil.h
//  AppCommonUICollect
//
//  Created by ciyouzen on 2018/9/20.
//  Copyright © 2018年 dvlproad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CQToastUtil : NSObject

+ (void)showHasSensitiveText;
+ (void)showNetworkError;

///显示只有文字的提示
+ (void)showMessage:(nullable NSString *)message;
+ (void)showMessage:(nullable NSString *)message inView:(UIView *)view;

///显示含图片的错误提示
+ (void)showErrorMessage:(NSString *)errorMessage;

///显示 "errorToast" 的 alertView
+ (void)showErrorToastAlertViewTitle:(NSString *)title;


/*
*  在指定的view上显示文字，并在delay秒后自动消失
*
*  @param message          要显示的信息
*  @param view             信息要显示的位置
*  @param delay            多少秒后自动消失
*/
+ (void)showMessage:(nullable NSString *)message
             inView:(nullable UIView *)superView
     hideAfterDelay:(NSTimeInterval)delay;

@end

NS_ASSUME_NONNULL_END
