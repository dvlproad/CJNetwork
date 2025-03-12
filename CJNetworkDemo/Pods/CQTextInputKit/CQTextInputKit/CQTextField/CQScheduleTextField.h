//
//  CQScheduleTextField.h
//  CJUIKitDemo
//
//  Created by ciyouzen on 2020/5/15.
//  Copyright © 2020 dvlproad. All rights reserved.
//
//  有输入进度的文本框

#import "CQBlockTextField.h"
#import <Masonry/Masonry.h>

NS_ASSUME_NONNULL_BEGIN

@interface CQScheduleTextField : CQBlockTextField {
    
}

#pragma mark - Init
/*
 *  初始化
 *
 *  @param maxTextLength            文本最大长度
 *  @param shouldChangeCheckBlock   文本是否可以改变成newText的判断(无限制则return YES)
 *  @param textDidChangeBlock       文本已经改变的通知事件
 *
 *  @return 有进度的文本输入框视图
 */
- (instancetype)initWithMaxTextLength:(NSInteger)maxTextLength
               shouldChangeCheckBlock:(BOOL (^)(NSString *newText))shouldChangeCheckBlock
                   textDidChangeBlock:(void (^ __nullable)(NSString *text))textDidChangeBlock;

#pragma mark - Event

/*
 *  更新字符串在指定显示区域内显示时候的字符间距
 *
 *  @param textContentSize      文本显示的区域大小(已扣去leftView,rightView)
 */
- (void)updateKernValueInTextContentSize:(CGSize)textContentSize;

@end

NS_ASSUME_NONNULL_END
