//
//  CJTextView+ThemeAndText.m
//  CQTextInputKit
//
//  Created by ciyouzen on 2018/9/3.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "CJTextView+ThemeAndText.h"
#import <CJBaseUIKit/UIColor+CJHex.h>

@implementation CJTextView (ThemeAndText)

/// 白色文字的文本框
- (CJTextView *)makeTheme_WhiteText_toBG {
    self.backgroundColor = [UIColor clearColor];    // 背景颜色
#if CQTestInputText==1
    self.backgroundColor = [UIColor redColor];
#endif
    self.placeholderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2]; // 占位符颜色
    self.tintColor = [UIColor whiteColor];  // 光标颜色
    self.textColor = [UIColor whiteColor];  // 文本颜色
    
    return self;
}

/// 黑色文字的文本框
- (CJTextView *)makeTheme_BlackText_toBG {
    self.backgroundColor = [UIColor clearColor];                                // 背景颜色
#if CQTestInputText==1
    self.backgroundColor = [UIColor redColor];
#endif
    self.placeholderColor = CJColorFromHexStringAndAlpha(@"#EEEEEF", 1.0);      // 占位符颜色
    self.tintColor = CJColorFromHexString(@"#0C101B");                          // 光标颜色
    self.textColor = CJColorFromHexString(@"#0C101B");                          // 文本颜色
    
    return self;
}

@end
