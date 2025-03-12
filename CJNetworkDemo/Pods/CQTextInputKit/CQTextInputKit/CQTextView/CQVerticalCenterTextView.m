//
//  CQVerticalCenterTextView.m
//  TSTextInputDemo
//
//  Created by qian on 2020/12/16.
//

#import "CQVerticalCenterTextView.h"
#import "UITextView+CJBlock.h"
#import "NSString+CJTextLength.h"
#import "CQSubStringUtil.h"

#import "UITextInputCursorCJHelper.h"
#import <CJBaseUIKit/UIColor+CJHex.h>

@interface CQVerticalCenterTextView () {
    
}
//文字输入
@property (nonatomic, copy) void(^textDidChangeBlock)(NSString *text);

@end

@implementation CQVerticalCenterTextView

//#pragma mark - Init
//- (instancetype)initWithVerticalAlignment:(CJVerticalAlignment)verticalAlignment {
//    self = [super initWithFrame:CGRectZero];
//    if (self) {
//        self.verticalAlignment = verticalAlignment;
//    }
//    
//    return self;
//}

#pragma mark - Get Method
/// 获取真正的有效文本
- (NSString *)getRealText {
    //NSString *systemText = [super text];
    NSString *customText = [super cjLastSelectedText];
    return customText;
}

#pragma mark - Event
/*
 *  将delegete接口改为block
 *
 *  @param maxTextLength            最大长度（英文长度算1，中文长度算2）
 *  @param inputTextCheckHandle     此次想要输入的文本能否真正输入的判断（如\n回车，为nil的时候，输入\n会执行resignFirstResponder）
 *  @param shouldChangeTextBlock    是否允许更新为newText的判断
 *  @param textDidChangeBlock       文本改变完之后的回调(最新文本，剩余字数，当前高度)
 */
- (void)changeDelegateToBlockWithMaxTextLength:(NSInteger)maxTextLength
                          inputTextCheckHandle:(BOOL(^ _Nullable)(NSString *bInputText))inputTextCheckHandle
                         shouldChangeTextBlock:(BOOL(^ _Nullable)(NSString *newText))shouldChangeTextBlock
                            textDidChangeBlock:(void(^ _Nullable)(NSString *newText, NSString * _Nullable remainNubmerText, BOOL shouldUpdateHeight, CGFloat currentTextViewHeight))textDidChangeBlock
{
    [self cjChangeDelegateToBlockWithMaxTextLength:maxTextLength inputTextCheckHandle:inputTextCheckHandle addExtraShouldChangeCheckBlock:shouldChangeTextBlock];
    
    __weak typeof(self)weakSelf = self;
    [self configDidChangeHappenHandle:^(UITextView *bTextView) {
        // 避免循环引用
        [weakSelf cjUpdateTextIfNeedByDelegateWithLengthCalculationBlock:^NSInteger(NSString * _Nonnull calculationString) {
            NSInteger calculationStringLength = calculationString.cj_length;
            return calculationStringLength;
        } substringToIndexBlock:^NSString * _Nonnull(NSString * _Nonnull bString, NSInteger bIndex) {
            NSString *indexSubstring = [CQSubStringUtil substringToIndex:bIndex forEmojiString:bString];
            return indexSubstring;
        }];
    } didChangeCompleteBlock:^(NSString *text, BOOL shouldUpdateHeight, CGFloat currentTextViewHeight) {
//        if (maxTextLength == 0) { // 如果不需要限制最大长度
//            !textDidChangeBlock ?: textDidChangeBlock(text, nil, currentTextViewHeight);
//            return;
//        } else {
//            NSInteger tempTextLength = text.cj_length;
//            if (tempTextLength > maxTextLength) { // 有限制，且超多限制，则截取内容长度
//                text = [text substringToIndex:maxTextLength];
//            }
//        }
        NSInteger textLength = text.cj_length;
        NSInteger remainTextLength = (maxTextLength - textLength)/2;
        NSString *remainNubmerText = @"";
        if (remainTextLength <= 5) {
            remainTextLength = MAX(0, remainTextLength);
            remainNubmerText = [NSString stringWithFormat:@"(剩余%zd字)", remainTextLength];
        }
        
        !textDidChangeBlock ?: textDidChangeBlock(text, remainNubmerText, shouldUpdateHeight, currentTextViewHeight);
    }];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
