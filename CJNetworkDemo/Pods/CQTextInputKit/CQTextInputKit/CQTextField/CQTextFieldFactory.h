//
//  CQTextFieldFactory.h
//  CJUIKitDemo
//
//  Created by ciyouzen on 2018/9/3.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CJBaseUIKit/CJTextField.h>
#import <CJBaseUIKit/UIColor+CJHex.h>
#import "CQScheduleTextField.h"

NS_ASSUME_NONNULL_BEGIN

@interface CQTextFieldFactory : NSObject

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
                             inputCompleteBlock:(void (^ __nullable)(NSString *phone))inputCompleteBlock;

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
                             inputCompleteBlock:(void (^ __nullable)(NSString *code))inputCompleteBlock;

/// 不含左右视图的通用文本框(如"验证码"、"邀请码"等文本框)
+ (CJTextField *)commonTextField;

///含左侧图片的textField，并支持通过leftButtonSelected属性切换图片变化 (使用场景：登录等)
+ (CJTextField *)textFieldWithNormalImage:(UIImage *)normalImage
                            selectedImage:(UIImage *)selectedImage;

///含 左侧label 的textField(使用场景：忘记密码、修改密码等)
+ (CJTextField *)textFieldWithLeftLabelText:(NSString *)leftLabelText;


///含 左侧label 和 右侧button 的textField(使用场景：获取验证码等)
+ (CJTextField *)textFieldWithLeftLabelText:(NSString *)leftLabelText rightButton:(UIButton *)rightButton;

/// 选择文本框(如选择手机号的区域)
+ (CJTextField *)chooseTextFieldWithDefaultTitle:(NSString *)defalutTitle defalutValue:(NSString *)defalutValue rightImage:(UIImage *)rightImage;

/// 可右侧操作的文本框(如手机号文本框上的"获取验证码")
+ (CJTextField *)textFieldWithRightView:(UIView *)rightView;

@end

NS_ASSUME_NONNULL_END
