//
//  CQShouldChangeBlockTextView.h
//  TSTextInputDemo
//
//  Created by qian on 2021/5/19.
//
//  在 shouldChange 的时候就执行检查的 textView

#import "CQBlockTextView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CQShouldChangeBlockTextView : CQBlockTextView

/*
 *  初始哈
 *
 *  @param frame            frame
 *  @param maxTextLength    最大长度
 *  @param toastBlock       toast方法
 */
- (instancetype)initWithFrame:(CGRect)frame
                maxTextLength:(NSInteger)maxTextLength
                   toastBlock:(void(^)(NSString *message))toastBlock;

@end

NS_ASSUME_NONNULL_END
