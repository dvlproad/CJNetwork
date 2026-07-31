//
//  CJBottomAgreeNoPopupView.m
//  TSPopupDemo
//
//  Created by ciyouzen on 2019/10/22.
//  Copyright © 2019 dvlproad. All rights reserved.
//

#import "CJBottomAgreeNoPopupView.h"
#import <Masonry/Masonry.h>
#import <CJBaseUIKit/UIColor+CJHex.h>
#import <CJBaseUIKit/UIButton+CJMoreProperty.h>

@interface CJBottomAgreeNoPopupView () {
    
}
@property (nonatomic, strong) UIView *popupContentView;         /**< 弹窗主视图(位于关闭按钮上方的那个内容视图) */
@property (nonatomic, strong) UIButton *cancelButton;           /**< 取消按钮 */
@property (nonatomic, strong) UIButton *okButton;               /**< 确认按钮 */
@property (nonatomic, copy, readonly) void(^cancelBlock)(CJBottomAgreeNoPopupView *bPopupView);  /**< 取消事件(默认为nil,如果非nil,则需要自己控制隐藏弹窗操作) */
@property (nonatomic, copy, readonly) void(^okBlock)(CJBottomAgreeNoPopupView *bPopupView);  /**< 确认事件(默认为nil,如果非nil,则需要自己控制隐藏弹窗操作) */

@end


@implementation CJBottomAgreeNoPopupView

#pragma mark - Init
/*
 *  初始化弹窗视图
 *
 *  @param popupContentView         弹窗主视图(位于关闭按钮上方的那个内容视图)
 *  @param cancelBlock              取消事件(默认为nil,如果非nil,则需要自己控制隐藏弹窗操作)
 *  @param okBlock                  确认事件(默认为nil,如果非nil,则需要自己控制隐藏弹窗操作)
 *
 *  @return 弹窗视图
 */
- (instancetype)initWithPopupContentView:(UIView *)popupContentView cancelBlock:(void(^ _Nullable)(CJBottomAgreeNoPopupView *bPopupView))cancelBlock okBlock:(void(^ _Nullable)(CJBottomAgreeNoPopupView *bPopupView))okBlock
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 30;
        self.layer.masksToBounds = YES;
        
        // 取消+确认按钮
        UIView *buttonsView =
        [[self class] twoButtonsWithCancelButtonTitle:NSLocalizedString(@"不同意", nil) okButtonTitle:NSLocalizedString(@"同意", nil) cancelHandle:^{
            [self __cancelAction];
        } okHandle:^{
            [self __okAction];
        }];
        [self addSubview:buttonsView];
        [buttonsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(50);
            make.left.mas_equalTo(0);
            make.centerX.mas_equalTo(0);
            make.bottom.mas_equalTo(self).mas_offset(-20);
        }];

        // 弹窗的内容部分
        [self addSubview:popupContentView];
        [popupContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self);
            make.top.mas_equalTo(self);
            make.bottom.mas_equalTo(buttonsView.mas_top).mas_offset(-20);
        }];
        self.popupContentView = popupContentView;
        
        _cancelBlock = cancelBlock;
        _okBlock = okBlock;
    }
    return self;
}


#pragma mark - Get Method
/*
 *  获取视图高度
 *
 *  @param popupContentViewHeight 初始化popupContentView传入的高度
 *
 *  @return 本视图的高度
 */
- (CGFloat)viewHeightWithContentHeight:(CGFloat)popupContentViewHeight {
    CGFloat popupViewHeight = popupContentViewHeight + 20 + 50 + 20;
    return popupViewHeight;
}

#pragma mark - Private Method
/// 取消按钮执行的事件
- (void)__cancelAction {
    !self.cancelBlock ?: self.cancelBlock(self);
}

/// 确认按钮执行的事件
- (void)__okAction {
    !self.okBlock ?: self.okBlock(self);
}

#pragma mark - Get
/*
 *  "Cancel" + "OK" 的 组合按钮
 *
 *  @param cancelButtonTitle    取消文案
 *  @param okButtonTitle        确认文案
 *  @param cancelHandle         取消事件
 *  @param okHandle             确认时间
 */
+ (UIView *)twoButtonsWithCancelButtonTitle:(NSString *)cancelButtonTitle
                              okButtonTitle:(NSString *)okButtonTitle
                               cancelHandle:(void(^)(void))cancelHandle
                                   okHandle:(void(^)(void))okHandle
{
    UIView *buttonsView = [[UIView alloc] init];
    
    // 关闭按钮
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.backgroundColor = CJColorFromHexStringAndAlpha(@"#EEEEEF", 1.0);
    cancelButton.layer.cornerRadius = 25;
    [cancelButton.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Semibold" size:16]];
    [cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
    [cancelButton setTitleColor:CJColorFromHexStringAndAlpha(@"#0C101B", 1.0) forState:UIControlStateNormal];
    //[cancelButton addTarget:self action:@selector(__cancelAction) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.cjTouchUpInsideBlock = ^(UIButton *button) {
        !cancelHandle ?: cancelHandle();
    };
    [buttonsView addSubview:cancelButton];
    
    UIButton *okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    okButton.backgroundColor = CJColorFromHexStringAndAlpha(@"#0C101B", 1.0);
    okButton.layer.cornerRadius = 25;
    [okButton.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Semibold" size:16]];
    [okButton setTitle:okButtonTitle forState:UIControlStateNormal];
    [okButton setTitleColor:CJColorFromHexStringAndAlpha(@"#FFFFFF", 1.0) forState:UIControlStateNormal];
    //[okButton addTarget:self action:@selector(__okAction) forControlEvents:UIControlEventTouchUpInside];
    okButton.cjTouchUpInsideBlock = ^(UIButton *button) {
        !okHandle ?: okHandle();
    };
    [buttonsView addSubview:okButton];
    
    NSArray<UIButton *> *bottomButtons = @[cancelButton, okButton];
    [bottomButtons mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(buttonsView);
    }];
    [bottomButtons mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:15 leadSpacing:32 tailSpacing:32];
    
    return buttonsView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
