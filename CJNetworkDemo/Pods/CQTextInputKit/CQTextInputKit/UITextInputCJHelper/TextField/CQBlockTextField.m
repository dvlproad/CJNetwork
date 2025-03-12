//
//  CQBlockTextField.m
//  CJUIKitDemo
//
//  Created by ciyouzen on 2020/5/15.
//  Copyright © 2020 dvlproad. All rights reserved.
//

#import "CQBlockTextField.h"
#import <CJBaseUIKit/CJTextFieldDelegate.h>
#import "UITextViewCQHelper.h"
#import "UITextInputCursorCJHelper.h"
#import <CJBaseUIKit/UIColor+CJHex.h>

@interface CQBlockTextField () <UITextFieldDelegate> {
    
}
@property (nonatomic, strong) CJTextFieldDelegate *blockDelegate;
@property (nonatomic, copy) void (^textDidChangeBlock)(NSString *text);         /**< 文本改变的回调（只回调没有待定词的回调） */

@end



@implementation CQBlockTextField


#pragma mark - Init
/*
 *  初始化将delegete接口改为block的文本输入框视图(使用此类时候，禁止再进行delegate的设置)
 *  @brief  使用此类时候，禁止再进行delegate的设置
 *
 *  @param textDidChangeBlock       文本已经改变的通知事件
 *
 *  @return 将delegete接口改为block的文本输入框视图
 */
- (instancetype)initWithTextDidChangeBlock:(void (^ __nullable)(NSString *text))textDidChangeBlock
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _textDidChangeBlock = textDidChangeBlock;
        
        [self changeDelegateToBlock];
    }
    return self;
}


#pragma mark - Config
/*
 *  更新文本框的各种颜色
 *
 *  @param isOuter  是否是表完善资料里的文本框
 */
- (void)updateColorType:(BOOL)isOuter {
    if (isOuter) {
        // backgroundColor
        self.backgroundColor = CJColorFromHexString(@"#EEEEEF");
        // placeholderColor
        _placeholderColor = CJColorFromHexStringAndAlpha(@"#DBDBDD", 1.0);
        // textColor
        self.textColor = CJColorFromHexString(@"#0C101B");
        // cursorColor
        self.tintColor = CJColorFromHexString(@"#0C101B");
    } else {
        // backgroundColor
        self.backgroundColor = CJColorFromHexString(@"#54545E");
        // placeholderColor
        _placeholderColor = CJColorFromHexStringAndAlpha(@"#B6B7BA", 1.0);
        // textColor
        self.textColor = CJColorFromHexString(@"#FFFFFF");
        // cursorColor
        self.tintColor = CJColorFromHexString(@"#FFFFFF");
    }
}

- (void)setPlaceholder:(NSString *)placeholder {
    [super setPlaceholder:placeholder];
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    if (self.placeholderColor) {
        [attributes setObject:self.placeholderColor forKey:NSForegroundColorAttributeName];
    }
    if (self.font) {
        [attributes setObject:self.font forKey:NSFontAttributeName];
    }
//    NSDictionary *attributes = @{NSForegroundColorAttributeName:placeholderColor,
//                                 NSFontAttributeName:self.font,
//    };
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:placeholder attributes:attributes];
    self.attributedPlaceholder = attrString;
}

/// 将delegete接口改为block
- (void)changeDelegateToBlock {
    CJTextFieldDelegate *blockDelegate = [[CJTextFieldDelegate alloc] init];
    self.blockDelegate = blockDelegate;
    self.delegate = blockDelegate;
    
//    self.delegate = self; // 会有特殊bug:输入拼音后，点击上面的中文没走shouldChangeCharactersInRange

    //②直接添加监视
    [self addTarget:self action:@selector(__textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}


#pragma mark - Setup
/*
 *  设置最大长度，并在已封装shouldChange中增加额外的能否输入的判断（如输入手机号码的时候，希望会系统处理出的新文本判断，在新文本不合法的时候能有对应toast提示）
 *
 *  @param maxTextLength                最大长度（英文长度算1，中文长度算2）
 *  @param extraShouldChangeCheckBlock  增加的额外能否输入的判断（这里添加的block一般都不应该再做长度限制了）
 */
- (void)setupMaxTextLength:(NSInteger)maxTextLength addExtraShouldChangeCheckBlock:(BOOL (^ _Nullable)(NSString *newText))extraShouldChangeCheckBlock {
    [self.blockDelegate setupMaxTextLength:maxTextLength addExtraShouldChangeCheckBlock:extraShouldChangeCheckBlock];
}

#pragma mark - Getter
- (NSInteger)maxTextLength {
    return self.blockDelegate.maxTextLength;
}

#pragma mark - Private Method
/**
 *  文本内容改变的事件
 */
- (void)__textFieldDidChange:(UITextField *)textField {
    // 判断是否存在高亮字符，如果有，则不进行字数统计和字符串截断(注意1高亮的时候，长度计算以莫名其妙的规则计算，2shouldChangeCharactersInRange中无法获取第一个未选中的时机)
    UITextRange *selectedRange = textField.markedTextRange;
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    BOOL donotneedCustomDealText = position != nil; // 存在高亮即未选中文本的时候，不需要自己处理文本框内容
    if (donotneedCustomDealText ==  YES) {
        return;
    }
    
    // 过滤空格
    //NSLog(@"系统处理后得到的文本:%@", textField.text);
    NSString *oldText = self.blockDelegate.shouldChangeWithOldText; // 文本框中高亮和不高亮的文本
    NSRange range = self.blockDelegate.shouldChangeCharactersInRange;
    NSString *string = self.blockDelegate.shouldChangeWithReplacementString;
    NSInteger maxTextLength = self.blockDelegate.maxTextLength;
    UITextInputChangeResultModel *resultModel =
            [UITextViewCQHelper shouldChange_newTextFromOldText:oldText
                                  shouldChangeCharactersInRange:range
                                              replacementString:string maxTextLength:maxTextLength];
    
    NSString *newTextFromSystemDeal = [oldText stringByReplacingCharactersInRange:range withString:string];
    NSString *newTextFromCustomDeal = resultModel.hopeNewText;
    //BOOL isDifferentFromSystemDeal = resultModel.isDifferentFromSystemDeal;
    BOOL isDifferentFromSystemDeal = [newTextFromCustomDeal isEqualToString:newTextFromSystemDeal] == NO;
    if (isDifferentFromSystemDeal) {
        // 注意，此步非常重要。是为了对于那些系统能处理的，就不去自己再setText了，防止光标和range变化。可有异常
        //NSLog(@"自己处理希望得到的文本:%@", newTextFromCustomDeal);  // 有时候限制了最大长度，又在中间插入超多字符。会希望原有字符不变。只插入其他数值
        textField.text = newTextFromCustomDeal;   // 使用这个方法会使得光标变到末尾了,所以我们还需要更新光标位置
        NSString *lastReplacementString = resultModel.hopeReplacementString;
        NSInteger cursorLocation = range.location+lastReplacementString.length;
        [UITextInputCursorCJHelper setCursorLocationForTextField:textField atIndex:cursorLocation];
    }
    
    _lastSelectedText = textField.text;  // 只文本框中高亮的文本
    
    
    if (self.textDidChangeBlock) {
        self.textDidChangeBlock(textField.text);
    }
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
