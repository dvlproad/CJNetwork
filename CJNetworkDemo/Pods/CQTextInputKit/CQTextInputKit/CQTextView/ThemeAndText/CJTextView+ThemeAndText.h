//
//  CJTextView+ThemeAndText.h
//  CQTextInputKit
//
//  Created by ciyouzen on 2018/9/3.
//  Copyright © 2017年 dvlproad. All rights reserved.
//
//  设置主题样式

#import <CJBaseUIKit/CJTextView.h>

NS_ASSUME_NONNULL_BEGIN

@interface CJTextView (ThemeAndText)

/// 白色文字的文本框
- (CJTextView *)makeTheme_WhiteText_toBG;

/// 黑色文字的文本框
- (CJTextView *)makeTheme_BlackText_toBG;

@end

NS_ASSUME_NONNULL_END
