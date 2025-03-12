//
//  CQShouldChangeBlockTextView.m
//  TSTextInputDemo
//
//  Created by qian on 2021/5/19.
//

#import "CQShouldChangeBlockTextView.h"
#import "UITextViewCQHelper.h"

@interface CQShouldChangeBlockTextView () <UITextViewDelegate> {
    
}
@property (nonatomic, assign, readonly) NSInteger maxTextLength;
@property (nonatomic, copy, readonly) void(^toastBlock)(NSString *message);

@end




@implementation CQShouldChangeBlockTextView

/*
 *  初始哈
 *
 *  @param frame            frame
 *  @param maxTextLength    最大长度
 *  @param toastBlock       toast方法
 */
- (instancetype)initWithFrame:(CGRect)frame
                maxTextLength:(NSInteger)maxTextLength
                   toastBlock:(void(^)(NSString *message))toastBlock
{
    self = [super initWithFrame:frame];
    if (self) {
        _maxTextLength = maxTextLength;
        _toastBlock = toastBlock;
        self.delegate = self;
    }
    return self;
}

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//    UITextInputChangeResultModel *resultModel = [UITextViewCQHelper shouldChange_newTextFromOldText:textView.text shouldChangeCharactersInRange:range replacementString:text maxTextLength:self.maxTextLength];
//    [super setText:resultModel.hopeNewText];
//
//    return YES;
//}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\r\n"] ||
        [text isEqualToString:@"\n"] ||
        [text isEqualToString:@"\t"] ||
        [text isEqualToString:@" "]) {
        return NO;
    }
    NSString *strText = text;
    strText = [strText stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    strText = [strText stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    strText = [strText stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    strText = [strText stringByReplacingOccurrencesOfString:@" " withString:@""];

    NSString *lang = self.textInputMode.primaryLanguage;//获取键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]){//九宫格
        //拼音输入的时候 selectedRange 会有值 输入完成 selectedRange 会等于nil
        //所以在输入完再进行相关的逻辑操作
        UITextRange *selectedRange = [self markedTextRange];
        if (!selectedRange) {//拼音全部输入完成
            //写相关输入监听逻辑

        }else{//bar上的拼音监听

            if (text.length > 0) {
                NSString *beforeStr = [self.text stringByReplacingCharactersInRange:range withString:@""];
                NSString *selectStr = [self.text substringWithRange:range];
                NSString *inputStr = text;
                if (selectStr.length > 0 && ![selectStr isEqualToString:text]) {
                    if (beforeStr.length + text.length > self.maxTextLength) {
                        NSRange rangeNewText = [strText rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, self.maxTextLength - beforeStr.length)];
                        inputStr = [inputStr substringWithRange:rangeNewText];
                    }
                    
                    [self setText:[beforeStr stringByReplacingCharactersInRange:NSMakeRange(range.location, 0) withString:inputStr]];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        self.selectedRange =  NSMakeRange(range.location + inputStr.length, 0);
                    });
                    return NO;
                }
            }
            
            return YES;
        }
    }else{//英文情况下
        //写相关输入监听逻辑

    }

    return [self dealText:strText shouldChangeTextInRange:range replacementText:text];
}

- (BOOL)dealText:(NSString *)strText shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (self.text.length >= self.maxTextLength && strText.length > 0) {
        NSString *message = [NSString stringWithFormat:@"最多可输入%d个字",self.maxTextLength];
        !self.toastBlock ?: self.toastBlock(message);
        return NO;
    }
    
    NSString *newText = strText;
    if (self.text.length + strText.length > self.maxTextLength && strText.length > 0) {
//        if (self.text.length > self.maxTextLength && strText.length > 0) {
//            [CQToastUtil showMessage:[NSString stringWithFormat:@"最多可输入%d个字",self.maxTextLength]];
//            return NO;
//        }
        NSRange rangeNewText = [strText rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, self.maxTextLength - self.text.length)];
        newText = [strText substringWithRange:rangeNewText];
        NSString *message = [NSString stringWithFormat:@"最多可输入%d个字",self.maxTextLength];
        !self.toastBlock ?: self.toastBlock(message);
    }
    
    if ([newText isEqualToString:text]) {
        return YES;
    }
    
    NSString *normalString = [self.text stringByReplacingCharactersInRange:range withString:newText];

    if (normalString.length >= self.maxTextLength) {
        NSRange rangeMax = [normalString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, self.maxTextLength)];
        NSString * result = [normalString substringWithRange:rangeMax];
        normalString = result;
        [self setText:normalString];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.selectedRange =  NSMakeRange(range.location + newText.length, 0);
        });

//        self.text = normalString;
        return NO;
    }
    if (normalString.length) {
        self.text = normalString;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.selectedRange =  NSMakeRange(range.location + newText.length, 0);
        });

        return NO;
    }

    return YES;

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
