//
//  CQScheduleTextField.m
//  CJUIKitDemo
//
//  Created by ciyouzen on 2020/5/15.
//  Copyright © 2020 dvlproad. All rights reserved.
//

#import "CQScheduleTextField.h"
#import <CJBaseUIKit/UIColor+CJHex.h>
//#import "CQScheduleLineCollectionView.h"

@interface CQScheduleTextField () <UITextFieldDelegate> {
    
}
//@property (nonatomic, strong) CQScheduleLineCollectionView *collectionView; /**< 输入进度视图 */

@property (nonatomic, assign, readonly) CGFloat kernValue;                      /**< 字符间距 */

@end

@implementation CQScheduleTextField

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
                   textDidChangeBlock:(void (^ __nullable)(NSString *text))textDidChangeBlock
{
    self = [super initWithTextDidChangeBlock:^(NSString * _Nonnull text) {
        [self __updateText:text];
        
        if (textDidChangeBlock) {
            textDidChangeBlock(text);
        }
    }];
    if (self) {
        _kernValue = 0;
        
        [self setupMaxTextLength:maxTextLength addExtraShouldChangeCheckBlock:shouldChangeCheckBlock];
        
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = [UIColor clearColor];
    self.textColor = CJColorFromHexString(@"#0C101B");
    self.font = [UIFont fontWithName:@"SFUIText-Medium" size:36];
    self.textAlignment = NSTextAlignmentCenter;
    
//    CQScheduleLineCollectionView *collectionView = [[CQScheduleLineCollectionView alloc] initWithTotalLineCount:self.maxTextLength];
//    [self addSubview:collectionView];
//    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(self).mas_offset(0);
//        make.height.mas_equalTo(2);
//        make.left.right.mas_equalTo(self);
//    }];
//    self.collectionView = collectionView;
}

#pragma mark - Setter
- (void)setText:(NSString *)text {
    [super setText:text];
    [self __updateText:text]; //新增此行代码为 修复初始设置text时候，没有进行富文本处理的问题
}



#pragma mark - Event
/*
 *  更新字符串在指定显示区域内显示时候的字符间距
 *
 *  @param textContentSize      文本显示的区域大小(已扣去leftView,rightView)
 */
- (void)updateKernValueInTextContentSize:(CGSize)textContentSize
{
    NSMutableString *referencedText = [[NSMutableString alloc] init];
    for (NSInteger i = 0; i < self.maxTextLength; i++) {
        [referencedText appendString:@"8"];
    }
    
    CGFloat kernValue = [self _kernValueInTextContentSize:textContentSize
                                       withReferencedText:referencedText
                                                     font:self.font];
    _kernValue = kernValue;
}

#pragma mark - Pirvate Method UI
- (void)__updateText:(NSString *)text {
    NSDictionary *attributes = @{NSFontAttributeName: self.font,
                                 NSKernAttributeName:[NSNumber numberWithFloat:self.kernValue],  //这里修改字符间距
                                };
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
    self.attributedText = attributedString;
    
//    [self.collectionView reloadDataWithCurrentLength:text.length];
}

#pragma mark - Pirvate Method 计算
/*
 *  根据参考文本及其字体大小，计算其在指定显示区域内字符间距
 *
 *  @param textContentSize      参考文本显示的区域大小(已扣去leftView,rightView)
 *  @param referencedText       参考文本
 *  @param font                 参考文本的字体
 *
 *  @return 字符间距
 */
- (CGFloat)_kernValueInTextContentSize:(CGSize)textContentSize
                    withReferencedText:(NSString *)referencedText
                                  font:(UIFont *)font
{
    CGFloat maxTextHeight = textContentSize.height;
    
    CGFloat textWidth = [self __getTextWidthForText:referencedText withFont:font infiniteWidthAndMaxHeight:maxTextHeight];
    
    CGFloat maxTextWidth = textContentSize.width;
    CGFloat remainingWidth = maxTextWidth - textWidth;
    CGFloat kernValue = remainingWidth/referencedText.length;
    
    return kernValue;
}

/// 获取指定文本的宽度
- (CGFloat)__getTextWidthForText:(NSString *)text
                        withFont:(UIFont *)font
       infiniteWidthAndMaxHeight:(CGFloat)maxTextHeight
{
    // 设置文字属性 要和label的一致
    NSDictionary *attrs = @{NSFontAttributeName :font};
    CGSize maxSize = CGSizeMake(MAXFLOAT, maxTextHeight);
    
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
    // 计算文字占据的宽高
    CGSize size = [text boundingRectWithSize:maxSize options:options attributes:attrs context:nil].size;
    
    // 当你是把获得的高度来布局控件的View的高度的时候.size转化为ceilf(size.height)。
    return  ceilf(size.width);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
