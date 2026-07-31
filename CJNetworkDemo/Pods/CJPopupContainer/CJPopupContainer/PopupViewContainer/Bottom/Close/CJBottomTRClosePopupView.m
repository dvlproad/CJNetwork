//
//  CJBottomTRClosePopupView.m
//  AppCommonUICollect
//
//  Created by ciyouzen on 2019/10/22.
//  Copyright © 2019 dvlproad. All rights reserved.
//

#import "CJBottomTRClosePopupView.h"
#import <Masonry/Masonry.h>
#import <CJBaseUIKit/UIButton+CJMoreProperty.h>

static NSBundle *CQResourceBottomPopup1Bundle(void) {
    static NSBundle *bundle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSBundle *podBundle = [NSBundle bundleForClass:[CJBottomTRClosePopupView class]];
        NSURL *url = [podBundle URLForResource:@"CJPopupContainer_PopupViewContainer_Bottom_Close" withExtension:@"bundle"];
        bundle = [NSBundle bundleWithURL:url];
    });
    return bundle;
}

@interface CJBottomTRClosePopupView () {
    
}
@property (nonatomic, strong) UIView *popupContentView;         /**< 弹窗主视图(位于关闭按钮上方的那个内容视图) */
@property (nonatomic, strong) UIButton *closeButton;            /**< 关闭按钮 */
@property (nonatomic, copy, readonly) void(^closeButtonCompleteBlock)(CJBottomTRClosePopupView *bPopupView);  /**< 关闭弹窗按钮的事件 */

@end


@implementation CJBottomTRClosePopupView

/*
 *  初始化弹窗视图
 *
 *  @param popupContentView         弹窗主视图(位于关闭按钮上方的那个内容视图)
 *  @param closeButtonCompleteBlock 关闭弹窗按钮的事件(默认为nil,如果非nil,则需要自己控制隐藏操作)
 *
 *  @return 弹窗视图
 */
- (instancetype)initWithPopupContentView:(UIView *)popupContentView
                closeButtonCompleteBlock:(void(^ _Nullable)(CJBottomTRClosePopupView *bPopupView))closeButtonCompleteBlock
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 12;
        self.layer.masksToBounds = YES;
        
        // 弹窗的内容部分
        popupContentView.layer.masksToBounds = YES;
        popupContentView.layer.cornerRadius = 4.f;
        [self addSubview:popupContentView];
        [popupContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        self.popupContentView = popupContentView;

        // 关闭按钮
        UIButton *closeButton = [[self class] closeImageButtonWithCloseHandle:^{
            [self __closeButtonAction];
        }];
        [self addSubview:closeButton];
        [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(45);
            make.width.mas_equalTo(45);
            make.right.top.mas_equalTo(0);
        }];
        self.closeButton = closeButton;
        _closeButtonCompleteBlock = closeButtonCompleteBlock;
    }
    return self;
}

/// "关闭"图片按钮
+ (UIView *)closeImageButtonWithCloseHandle:(void(^)(void))closeHandle
{
    UIImage *closeImage = [UIImage imageNamed:@"bottom_closePopup" inBundle:CQResourceBottomPopup1Bundle() compatibleWithTraitCollection:nil];
    NSAssert(closeImage, @"关闭图片不能为空");
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setBackgroundImage:closeImage forState:UIControlStateNormal];
    //[closeButton addTarget:self action:@selector(__closeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    closeButton.cjTouchUpInsideBlock = ^(UIButton *button) {
        !closeHandle ?: closeHandle();
    };
    
    return closeButton;
}



#pragma mark - Private Method
/// 关闭按钮执行的事件
- (void)__closeButtonAction {
    !self.closeButtonCompleteBlock ?: self.closeButtonCompleteBlock(self);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
