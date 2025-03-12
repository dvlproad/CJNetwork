//
//  UITextField+CQThemeAndText.m
//  CQTextInputKit
//
//  Created by ciyouzen on 2018/9/3.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "UITextField+CQThemeAndText.h"
#import <CJBaseUIKit/UIColor+CJHex.h>

@implementation UITextField (CQThemeAndText)

#pragma mark - 完善信息的输入框
- (UITextField *)makeTheme_Blue_toBG:(BOOL)isBiao
                         placeholder:(NSString *)placeholder
{
    UIColor *placeholderColor = nil;
    if (isBiao) {
        // backgroundColor
        self.backgroundColor = CJColorFromHexString(@"#EEEEEF");
        // placeholderColor
        placeholderColor = [UIColor lightGrayColor];
        // textColor
        self.textColor = CJColorFromHexString(@"#0C101B");
        
    } else {
        // backgroundColor
        self.backgroundColor = CJColorFromHexString(@"#36363E");
        // placeholderColor
         placeholderColor = CJColorFromHexStringAndAlpha(@"#FFFFFF", 0.2);
        // textColor
        self.textColor = CJColorFromHexString(@"#FFFFFF");
    }
    
    NSDictionary *attributes = @{NSForegroundColorAttributeName:placeholderColor,
                                 NSFontAttributeName:self.font,
    };
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:placeholder attributes:attributes];
    self.attributedPlaceholder = attrString;
    
    return self;
}


@end
