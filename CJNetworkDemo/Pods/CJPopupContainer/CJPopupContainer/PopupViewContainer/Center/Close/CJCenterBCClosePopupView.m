//
//  CJCenterBCClosePopupView.m
//  AppCommonUICollect
//
//  Created by ciyouzen on 2019/10/22.
//  Copyright © 2019 dvlproad. All rights reserved.
//

#import "CJCenterBCClosePopupView.h"
#import <Masonry/Masonry.h>
#import <CJBaseUIKit/UIButton+CJMoreProperty.h>

static NSBundle *CQResourceCenterPopup1Bundle(void) {
    static NSBundle *bundle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSBundle *podBundle = [NSBundle bundleForClass:[CJCenterBCClosePopupView class]];
        NSURL *url = [podBundle URLForResource:@"CJPopupContainer_PopupViewContainer_Center_Close" withExtension:@"bundle"];
        bundle = [NSBundle bundleWithURL:url];
    });
    return bundle;
}

@interface CJCenterBCClosePopupView () {
    
}
@property (nonatomic, strong) UIView *popupContentView; /**< 弹窗主视图(位于关闭按钮上方的那个内容视图) */
@property (nonatomic, strong) UIButton *closeButton;    /**< 关闭按钮 */
@property (nonatomic, copy, readonly) void(^closeButtonCompleteBlock)(CJCenterBCClosePopupView *bPopupView);  /**< 关闭弹窗按钮的事件 */


@end


@implementation CJCenterBCClosePopupView

/*
 *  初始化弹窗视图
 *
 *  @param popupContentView         弹窗主视图(位于关闭按钮上方的那个内容视图)
 *  @param closeButtonCompleteBlock 关闭弹窗按钮的事件(默认为nil,如果非nil,则需要自己控制隐藏操作)
 *
 *  @return 弹窗视图
 */
- (instancetype)initWithPopupContentView:(UIView *)popupContentView
                closeButtonCompleteBlock:(void(^ _Nullable)(CJCenterBCClosePopupView *bPopupView))closeButtonCompleteBlock {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        // 关闭按钮
        UIButton *closeButton = [[self class] closeImageButtonWithCloseHandle:^{
            [self __closeButtonAction];
        }];
        [self addSubview:closeButton];
        [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(32);
            make.width.mas_equalTo(32);
            make.bottom.mas_equalTo(self);
            make.centerX.mas_equalTo(self);
        }];
        self.closeButton = closeButton;
        
        // 弹窗的内容部分
        popupContentView.layer.masksToBounds = YES;
        popupContentView.layer.cornerRadius = 4.f;
        [self addSubview:popupContentView];
        [popupContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self);
            make.top.mas_equalTo(self);
            make.bottom.mas_equalTo(self.closeButton.mas_top).mas_offset(-20.f);
        }];
        self.popupContentView = popupContentView;
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
    CGFloat popupViewHeight = popupContentViewHeight + 20 + 32;
    return popupViewHeight;
}

#pragma mark - Private Method
/// 关闭按钮执行的事件
- (void)__closeButtonAction {
    !self.closeButtonCompleteBlock ?: self.closeButtonCompleteBlock(self);
}


#pragma mark - Get
/// "关闭"图片按钮
+ (UIButton *)closeImageButtonWithCloseHandle:(void(^)(void))closeHandle
{
    UIImage *closeImage = [UIImage imageNamed:@"center_closePopup" inBundle:CQResourceCenterPopup1Bundle() compatibleWithTraitCollection:nil];
    NSAssert(closeImage, @"关闭图片不能为空");
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setBackgroundImage:closeImage forState:UIControlStateNormal];
    //[closeButton addTarget:self action:@selector(__closeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    closeButton.cjTouchUpInsideBlock = ^(UIButton *button) {
        !closeHandle ?: closeHandle();
    };
    
    return closeButton;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
