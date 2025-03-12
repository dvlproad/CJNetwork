//
//  CQVerticalCenterTextView.h
//  TSTextInputDemo
//
//  Created by qian on 2020/12/16.
//

#import "CJVerticalCenterTextView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CQVerticalCenterTextView : CJVerticalCenterTextView {
    
}

//#pragma mark - Init
//- (instancetype)initWithVerticalAlignment:(CJVerticalAlignment)verticalAlignment NS_DESIGNATED_INITIALIZER;
//+ (instancetype)new NS_UNAVAILABLE;
//- (instancetype)init NS_UNAVAILABLE;
//- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
//- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

#pragma mark - Get Method
/// 获取真正的有效文本
- (NSString *)getRealText;
- (NSString *)text NS_UNAVAILABLE;


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
                            textDidChangeBlock:(void(^ _Nullable)(NSString *newText, NSString * _Nullable remainNubmerText, BOOL shouldUpdateHeight, CGFloat currentTextViewHeight))textDidChangeBlock;

- (void)setDelegate:(nullable id<UITextFieldDelegate>)delegate NS_UNAVAILABLE; // (使用此类时候，禁止再进行delegate的设置)

@end

NS_ASSUME_NONNULL_END
