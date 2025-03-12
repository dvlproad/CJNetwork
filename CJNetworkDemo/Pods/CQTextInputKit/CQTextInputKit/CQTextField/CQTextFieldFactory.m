//
//  CQTextFieldFactory.m
//  CJUIKitDemo
//
//  Created by ciyouzen on 2018/9/3.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "CQTextFieldFactory.h"
#import <CJBaseUIKit/UITextField+CJPadding.h>

@implementation CQTextFieldFactory

#pragma mark - 手机号码输入的文本框
/*
 *  手机号码输入的文本框
 *
 *  @param textFieldSize            文本整体的区域大小(含leftView,rightView等)，用于之后计算文本框内字符的间距
 *  @param vaildChangeBlock         输入内容是否有效的回调(常用于：该按钮前面的图标的有效状态是否亮起，如用户名框,密码框)
 *  @param inputErrorBlock          输入错误的回调
 *  @param inputCompleteBlock       输入结束的回调
 *
 *  @return 有进度的文本输入框视图
 */
+ (CQScheduleTextField *)phoneTextFieldWithSize:(CGSize)textFieldSize
                               vaildChangeBlock:(void (^ __nullable)(BOOL phoneValid))vaildChangeBlock
                                inputErrorBlock:(void (^ __nullable)(NSString *errorMessage))inputErrorBlock
                             inputCompleteBlock:(void (^ __nullable)(NSString *phone))inputCompleteBlock
{
    CQScheduleTextField *phoneTextField = [[CQScheduleTextField alloc] initWithMaxTextLength:11 shouldChangeCheckBlock:^BOOL(NSString * _Nonnull newText) {
        BOOL shouldChange = [self phoneCheckInput:newText];
        if (shouldChange) {
            BOOL phoneVaild = [self phoneCheckValid:newText];
            !vaildChangeBlock ?: vaildChangeBlock(phoneVaild);
        } else {
            !inputErrorBlock ?: inputErrorBlock(@"手机号码：请输入数字");
        }
        return shouldChange;
    } textDidChangeBlock:^(NSString * _Nonnull text) {
        if (text.length == 11) {
            BOOL phoneVaild = [self phoneCheckValid:text];
            if (phoneVaild) {
                !inputCompleteBlock ?: inputCompleteBlock(text);
            } else {
                !inputErrorBlock ?: inputErrorBlock(@"请输入正确的手机号码");
            }
        }
    }];
    phoneTextField.font = [UIFont fontWithName:@"SFUIText-Medium" size:36];
    phoneTextField.keyboardType = UIKeyboardTypePhonePad;
    phoneTextField.textAlignment = NSTextAlignmentLeft;
    
    //添加左视图
    UILabel *regionLabel = [UILabel new];
    regionLabel.font = [UIFont fontWithName:@"SFUIText-Semibold" size:16];
    regionLabel.textColor = CJColorFromHexString(@"#0C101B");
    regionLabel.text = @"+86";
    regionLabel.textAlignment = NSTextAlignmentLeft;
    regionLabel.frame = CGRectMake(0, 0, 53, 60);
    phoneTextField.leftViewLeftOffset = 0;
    phoneTextField.leftViewRightOffset= 20;
    phoneTextField.leftView = regionLabel;
    phoneTextField.leftViewMode = UITextFieldViewModeAlways;
    
    CGFloat textContentWidth = textFieldSize.width - 0 - 53 - 20 - 10; // 给光标留个10距离
    CGFloat textContentHeight = textFieldSize.height;
    CGSize textContentSize = CGSizeMake(textContentWidth, textContentHeight);
    [phoneTextField updateKernValueInTextContentSize:textContentSize];
    
    return phoneTextField;
}

/// phone 输入性检查(输入时候使用)
+ (BOOL)phoneCheckInput:(NSString *)phone {
    NSString *newText = phone;
    
    if(newText.length == 0) {   // allow clear, when input
        return YES;
    }
    
    // 手机号码:新的整体都是数字，且<=11位才允许变更
    NSScanner *scan = [NSScanner scannerWithString:newText];
    int val;
    BOOL isInt = [scan scanInt:&val] && [scan isAtEnd];
    BOOL phoneInputAllow = isInt && newText.length <= 11;
    if (phoneInputAllow) { // 允许输入手机号码,但不代表此时号码就是有效,如完整位数要求
        return YES;
    } else {
        return NO;
    }
}

/// phone 有效性检查(输入有效性通过后)
+ (BOOL)phoneCheckValid:(NSString *)phone {
//    //NSString *phoneRegex = @"^[1][34578][0-9]{9}$";
//    NSString *phoneRegex = @"^1[0-9]{10}$";
//    NSPredicate *phonePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
//    BOOL phoneValid = [phonePredicate evaluateWithObject:phone];
//    return phoneValid;
    
    
    // 移动号段正则表达式
    NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(17[0-9])|(18[2-4,7-8]))\\d{8}$";
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
    BOOL isMatch1 = [pred1 evaluateWithObject:phone];
    
    // 联通号段正则表达式
    NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(17[0-9])|(18[5,6]))\\d{8}$";
    NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
    BOOL isMatch2 = [pred2 evaluateWithObject:phone];
    
    // 电信号段正则表达式
    NSString *CT_NUM = @"^((133)|(153)|(17[0-9])|(18[0,1,9]))\\d{8}$";
    NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
    BOOL isMatch3 = [pred3 evaluateWithObject:phone];
    
    
    NSString *NEW_NUM = @"^((144)|(191)|(199)|(198)|(166))\\d{8}$";
    NSPredicate *pred4 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", NEW_NUM];
    BOOL isMatch4 = [pred4 evaluateWithObject:phone];


    BOOL phoneValid = isMatch1 || isMatch2 || isMatch3 || isMatch4;

    return phoneValid;
}


#pragma mark - 手机验证码输入的文本框
/*
 *  手机验证码输入的文本框
 *
 *  @param textFieldSize            文本整体的区域大小(含leftView,rightView等)，用于之后计算文本框内字符的间距
 *  @param vaildChangeBlock         输入内容是否有效的回调(常用于：该按钮前面的图标的有效状态是否亮起，如用户名框,密码框)
 *  @param inputErrorBlock          输入错误的回调
 *  @param inputCompleteBlock       输入结束的回调
 *
 *  @return 有进度的文本输入框视图
 */
+ (CQScheduleTextField *)codeTextFieldWithSize:(CGSize)textFieldSize
                               vaildChangeBlock:(void (^ __nullable)(BOOL codeValid))vaildChangeBlock
                                inputErrorBlock:(void (^ __nullable)(NSString *errorMessage))inputErrorBlock
                             inputCompleteBlock:(void (^ __nullable)(NSString *code))inputCompleteBlock
{
    NSInteger maxTextLength = 4;
    CQScheduleTextField *codeTextField = [[CQScheduleTextField alloc] initWithMaxTextLength:maxTextLength shouldChangeCheckBlock:^BOOL(NSString * _Nonnull newText) {
        BOOL shouldChange = [self authCodeCheckInput:newText];
        if (shouldChange) {
            BOOL codeValid = [self authCodeCheckValid:newText];
            !vaildChangeBlock ?: vaildChangeBlock(codeValid);
        } else {
            !inputErrorBlock ?: inputErrorBlock(@"手机验证码：请输入数字");
        }
        return shouldChange;
    } textDidChangeBlock:^(NSString * _Nonnull text) {
        if (text.length == maxTextLength) {
            BOOL codeValid = [self authCodeCheckValid:text];
            if (codeValid) {
                !inputCompleteBlock ?: inputCompleteBlock(text);
            } else {
                !inputErrorBlock ?: inputErrorBlock(@"请输入正确的手机验证码格式");
            }
        }
    }];
    codeTextField.keyboardType = UIKeyboardTypePhonePad;
    
    CGFloat textContentWidth = textFieldSize.width - 0 - 0 - 0 - 10; // 给光标留个10距离
    CGFloat textContentHeight = textFieldSize.height;
    CGSize textContentSize = CGSizeMake(textContentWidth, textContentHeight);
    [codeTextField updateKernValueInTextContentSize:textContentSize];
    
    return codeTextField;
}


/// authCode 输入性检查(输入时候使用)
+ (BOOL)authCodeCheckInput:(NSString *)authCode {
    NSString *newText = authCode;
    if (newText.length == 0) {  //输入过程中允许清空操作
        return YES;
    }
    
    // 验证码:新的整体都是数字，且<=4位才允许变更
    NSScanner *scan = [NSScanner scannerWithString:newText];
    int val;
    BOOL isInt = [scan scanInt:&val] && [scan isAtEnd];
    if (isInt && newText.length <= 6) {
        return YES;
    } else {
        return NO;
    }
}

/// authCode 有效性检查(输入有效性通过后)
+ (BOOL)authCodeCheckValid:(NSString *)authCode {
    return authCode.length == 4;
}


#pragma mark - 基本的文本框
/// 不含左右视图的通用文本框(如"验证码"、"邀请码"等文本框)
+ (CJTextField *)commonTextField {
    CJTextField *textField = [[CJTextField alloc] initWithFrame:CGRectZero];
    textField.backgroundColor = [UIColor whiteColor];
    textField.textAlignment = NSTextAlignmentLeft;
    textField.font = [UIFont systemFontOfSize:14];
    textField.layer.borderColor = CJColorFromHexString(@"#dadada").CGColor;
    textField.layer.borderWidth = 0.5;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [textField cj_addLeftOffset:10];
    
    return textField;
}

///含左侧图片的textField，并支持通过leftButtonSelected属性切换图片变化 (使用场景：登录等)
+ (CJTextField *)textFieldWithNormalImage:(UIImage *)normalImage
                            selectedImage:(UIImage *)selectedImage
{
    CGSize imageSize = CGSizeMake(14, 15);
    CJTextField *textField = [[CJTextField alloc] initWithFrame:CGRectZero];
    textField.backgroundColor = CJColorFromHexString(@"#ffffff");
    textField.layer.cornerRadius = 6;
    textField.layer.borderWidth = 0.6;
    textField.layer.borderColor = CJColorFromHexString(@"#d2d2d2").CGColor;
    
    [textField addLeftImageWithNormalImage:normalImage selectedImage:selectedImage imageSize:imageSize];
    textField.leftViewLeftOffset = 15;
    textField.leftViewRightOffset = 15;
    
    return textField;
}

///含 左侧label 的textField(使用场景：忘记密码、修改密码等)
+ (CJTextField *)textFieldWithLeftLabelText:(NSString *)leftLabelText {
    CJTextField *textField = [[CJTextField alloc] initWithFrame:CGRectZero];
    textField.backgroundColor = CJColorFromHexString(@"#ffffff");
    
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectZero];

    CGFloat screenWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    CGFloat lableWidth = screenWidth < 375 ? 90 : 100;
    CGFloat fontSize = screenWidth < 375 ? 15.5 : 17;

    leftLabel.frame = CGRectMake(0, 0, lableWidth, 44);
    //leftLabel.backgroundColor = [UIColor greenColor];
    leftLabel.textAlignment = NSTextAlignmentLeft;
    leftLabel.textColor = CJColorFromHexString(@"#333333");
    leftLabel.font = [UIFont systemFontOfSize:fontSize];
    leftLabel.text = leftLabelText;
    
    textField.leftView = leftLabel;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftViewLeftOffset = 12;
    textField.leftViewRightOffset = 12;
    textField.font = [UIFont systemFontOfSize:fontSize];
    
    [textField addUnderLineWithHeight:0.5 color:CJColorFromHexString(@"#d1d3d4") leftMargin:10 rightMargin:0];
    return textField;
}

///含 左侧label 和 右侧button 的textField(使用场景：获取验证码等)
+ (CJTextField *)textFieldWithLeftLabelText:(NSString *)leftLabelText rightButton:(UIButton *)rightButton {
    CJTextField *textField = [self textFieldWithLeftLabelText:leftLabelText];
    rightButton.frame = CGRectMake(0, 0, 90, 35);
    
    textField.rightView = rightButton;
    textField.rightViewMode = UITextFieldViewModeAlways;
    textField.rightViewLeftOffset = 12;
    textField.rightViewRightOffset = 12;

    return textField;
}

/// 选择文本框
+ (CJTextField *)chooseTextFieldWithDefaultTitle:(NSString *)defalutTitle defalutValue:(NSString *)defalutValue rightImage:(UIImage *)rightImage {
    CJTextField *regionTextField = [[CJTextField alloc] initWithFrame:CGRectZero];
    regionTextField.font = [UIFont systemFontOfSize:14];
    regionTextField.textColor = CJColorFromHexString(@"#1a1a1a");
    regionTextField.text = defalutValue;
    regionTextField.backgroundColor = [UIColor whiteColor];
    
    //添加左视图
    UILabel *regionLabel = [UILabel new];
    regionLabel.font = [UIFont systemFontOfSize:14];
    regionLabel.textColor = CJColorFromHexString(@"#bcbcbc");
    regionLabel.text = defalutTitle;
    regionLabel.textAlignment = NSTextAlignmentLeft;
    regionLabel.frame = CGRectMake(0, 0, 100, 38);
    regionTextField.leftViewLeftOffset = 10;
    regionTextField.leftView = regionLabel;
    regionTextField.leftViewMode = UITextFieldViewModeAlways;
    
    //添加右视图
    UIImageView *downArrowImageView = [[UIImageView alloc] initWithImage:rightImage];
    downArrowImageView.frame = CGRectMake(0, 0, 9, 5);
    regionTextField.rightViewRightOffset = 17;
    regionTextField.rightView = downArrowImageView;
    regionTextField.rightViewMode = UITextFieldViewModeAlways;
    
    return regionTextField;
}

/// 可右侧操作的文本框(如手机号文本框上的"获取验证码")
+ (CJTextField *)textFieldWithRightView:(UIView *)rightView {
    CJTextField *phoneTextField = [CQTextFieldFactory commonTextField];
    
    //phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    [rightView setFrame:CGRectMake(0, 0, 90, 30)];
    phoneTextField.rightView = rightView;
    phoneTextField.rightViewMode = UITextFieldViewModeAlways;
    phoneTextField.rightViewRightOffset = 10;
    
    return phoneTextField;
}

@end
