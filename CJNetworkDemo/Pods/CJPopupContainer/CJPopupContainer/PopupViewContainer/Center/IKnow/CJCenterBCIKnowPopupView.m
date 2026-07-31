//
//  CJCenterBCIKnowPopupView.m
//  AppCommonUICollect
//
//  Created by ciyouzen on 2019/10/22.
//  Copyright © 2019 dvlproad. All rights reserved.
//

#import "CJCenterBCIKnowPopupView.h"
#import <Masonry/Masonry.h>
#import <CJBaseUIKit/UIButton+CJMoreProperty.h>

static NSBundle *CQResourceCenterPopup1Bundle(void) {
    static NSBundle *bundle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSBundle *podBundle = [NSBundle bundleForClass:[CJCenterBCIKnowPopupView class]];
        NSURL *url = [podBundle URLForResource:@"CJPopupContainer_PopupViewContainer_Center_IKnow" withExtension:@"bundle"];
        bundle = [NSBundle bundleWithURL:url];
    });
    return bundle;
}

@interface CJCenterBCIKnowPopupView () {
    
}
@property (nonatomic, strong) UIView *popupContentView; /**< 弹窗主视图(位于关闭按钮上方的那个内容视图) */
@property (nonatomic, strong) UIButton *confirmButton;    /**< 关闭按钮 */

@property (nonatomic, copy) void(^clickConfirmButtonBlock)(void);  /**< 点击'我知道了'按钮的回调 */

@end


@implementation CJCenterBCIKnowPopupView

/**
 *  初始化弹窗视图
 *
 *  @param popupContentView         弹窗主视图(位于关闭按钮上方的那个内容视图)
 *  @param clickConfirmButtonBlock  点击'我知道了'按钮的回调
 *
 *  @return 弹窗视图
 */
- (instancetype)initWithPopupContentView:(UIView *)popupContentView
                 clickConfirmButtonBlock:(void(^)(void))clickConfirmButtonBlock
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        // 确认按钮
        UIButton *confirmButton = [[self class] iKnowImageButtonWithOKHandle:^{
            [self __confirmButtonAction];
        }];
        [self addSubview:confirmButton];
        [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(42);
            make.width.mas_equalTo(152);
            make.bottom.mas_equalTo(self);
            make.centerX.mas_equalTo(self);
        }];
        self.confirmButton = confirmButton;
        
        // 弹窗的内容部分
        popupContentView.layer.masksToBounds = YES;
        popupContentView.layer.cornerRadius = 4.f;
        [self addSubview:popupContentView];
        [popupContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self);
            make.top.mas_equalTo(self);
            make.bottom.mas_equalTo(self.confirmButton.mas_top).mas_offset(-50.f);
        }];
        self.popupContentView = popupContentView;
        
        self.clickConfirmButtonBlock = clickConfirmButtonBlock;
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
    CGFloat popupViewHeight = popupContentViewHeight + 50 + 42;
    return popupViewHeight;
}


#pragma mark - Private Method
/// 关闭按钮执行的事件
- (void)__confirmButtonAction {
    !self.clickConfirmButtonBlock ?: self.clickConfirmButtonBlock();
}


#pragma mark - Get
/// "我知道了"图片按钮
+ (UIButton *)iKnowImageButtonWithOKHandle:(void(^)(void))okHandle
{
    UIImage *confirmImage = [UIImage imageNamed:@"IKnowDescriptions.png" inBundle:CQResourceCenterPopup1Bundle() compatibleWithTraitCollection:nil];
    //UIImage *confirmImage = [UIImage imageNamed:@"IKnowDescriptions.png"]
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.backgroundColor = [UIColor whiteColor];
    confirmButton.layer.masksToBounds = YES;
    confirmButton.layer.cornerRadius = 6;
    [confirmButton setBackgroundImage:confirmImage forState:UIControlStateNormal];
    //[confirmButton setTitle:NSLocalizedString(@"我知道了", nil) forState:UIControlStateNormal];
    //[confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //[confirmButton addTarget:self action:@selector(__confirmButtonAction) forControlEvents:UIControlEventTouchUpInside];
    confirmButton.cjTouchUpInsideBlock = ^(UIButton *button) {
        !okHandle ?: okHandle();
    };
    
    return confirmButton;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
