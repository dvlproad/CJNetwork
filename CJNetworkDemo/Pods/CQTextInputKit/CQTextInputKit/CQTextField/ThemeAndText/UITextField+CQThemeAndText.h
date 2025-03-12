//
//  UITextField+CQThemeAndText.h
//  CQTextInputKit
//
//  Created by ciyouzen on 2018/9/3.
//  Copyright © 2017年 dvlproad. All rights reserved.
//
//  设置主题样式

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (CQThemeAndText)

#pragma mark - 完善信息的输入框
- (UITextField *)makeTheme_Blue_toBG:(BOOL)isBiao
                         placeholder:(NSString *)placeholder;

@end

NS_ASSUME_NONNULL_END
