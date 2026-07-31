//
//  CQBottomToolbarView.m
//  CJUIKitDemo
//
//  Created by qian on 2020/11/24.
//  Copyright © 2020 dvlproad. All rights reserved.
//

#import "CQBottomToolbarView.h"
#import <Masonry/Masonry.h>
#import <CJBaseUIKit/UIButton+CJMoreProperty.h>

@interface CQBottomToolbarView () {
    
}
@property (nonatomic, strong) UILabel *titleLabel;      /**< 标题标签 */
//@property (nonatomic, strong) CAShapeLayer *fieldLayer;

@property (nonatomic, copy, readonly) void(^cancelHandle)(void);    /**< 点击取消按钮的回调 */
@property (nonatomic, copy, readonly) void(^okHandle)(void);        /**< 点击完成按钮的事件 */

@end

@implementation CQBottomToolbarView


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
        
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
//    if (self.fieldLayer == nil) {
//        CAShapeLayer *fieldLayer = [[CAShapeLayer alloc] init];
//        self.layer.mask = fieldLayer;
//        self.fieldLayer = fieldLayer;
//    }
//    
//    UIBezierPath *fieldPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(30 , 30)];
//    self.fieldLayer.frame = self.bounds;
//    self.fieldLayer.path = fieldPath.CGPath;
}


#pragma mark - Setter
- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setBgType:(CQBottomPopupViewBGTheme)bgType {
    _bgType = bgType;
    
    UIColor *c0C101B = [UIColor colorWithRed:12/255.0 green:16/255.0 blue:27/255.0 alpha:1.0]; // #0C101B
    UIColor *cB6B7BA = [UIColor colorWithRed:182/255.0 green:183/255.0 blue:186/255.0 alpha:1.0]; // #B6B7BA
    
    if (bgType == CQBottomPopupViewBGThemeBlack) {
        [self.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.okButton setTitleColor:c0C101B forState:UIControlStateNormal];
        self.okButton.cjNormalBGColor = [UIColor whiteColor];
        self.titleLabel.textColor = cB6B7BA;
    } else { // 默认白色背景、黑色文字
        [self.cancelButton setTitleColor:c0C101B forState:UIControlStateNormal];
        [self.okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.okButton.cjNormalBGColor = c0C101B;
        self.titleLabel.textColor = cB6B7BA;
    }
}


#pragma mark - SetupViews
- (void)setupViews {
    self.backgroundColor = [UIColor clearColor]; // 为了直接采用背景色
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    [cancelButton setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor colorWithRed:12/255.0 green:16/255.0 blue:27/255.0 alpha:1.0] forState:UIControlStateNormal];// #0C101B
    cancelButton.backgroundColor = [UIColor clearColor];
    cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;  // UI左对齐
    [cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.height.equalTo(@30);
        make.left.equalTo(self).offset(22);
        make.width.equalTo(@50);
    }];
    self.cancelButton = cancelButton;
    
    
    UIButton *okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    okButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
    [okButton setTitle:NSLocalizedString(@"完成", nil) forState:UIControlStateNormal];
//    [okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    okButton.cjNormalBGColor = [UIColor colorWithRed:12/255.0 green:16/255.0 blue:27/255.0 alpha:1.0]; // #0C101B
//    okButton.cjDisabledBGColor = [UIColor colorWithRed:12/255.0 green:16/255.0 blue:27/255.0 alpha:1.0]; // #0C101B
    okButton.layer.cornerRadius = 15;
    okButton.layer.masksToBounds = YES;
    [okButton addTarget:self action:@selector(okAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:okButton];
    [okButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.height.equalTo(@30);
        make.right.equalTo(self).offset(-16);
        make.width.equalTo(@50);
    }];
    self.okButton = okButton;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.text = @"编辑昵称";
    titleLabel.textColor = [UIColor colorWithRed:182/255.0 green:183/255.0 blue:186/255.0 alpha:1.0]; // #B6B7BA
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.right.equalTo(okButton.mas_left).offset(-10);
        make.centerY.equalTo(okButton);
        make.height.equalTo(@18);
    }];
    self.titleLabel = titleLabel;
}

#pragma mark - Config
/*
 *  设置标题和击完成按钮的事件(规则：没有确认按钮就没有取消按钮)
 *
 *  @param title            标题
 *  @param cancelHandle     点击取消按钮的事件
 *  @param okHandle         点击确认按钮的事件
 */
- (void)setupTitle:(NSString *)title cancelHandle:(void(^)(void))cancelHandle okHandle:(void(^)(void))okHandle {
    BOOL shouldHideOKButton = okHandle == nil;
    self.okButton.hidden = shouldHideOKButton;
    self.cancelButton.hidden = shouldHideOKButton; // 规则：没有确认按钮就没有取消按钮
    
    _cancelHandle = cancelHandle;
    _okHandle = okHandle;
}

/*
 *  设置标题
 *
 *  @param title            工具栏的标题
 */
- (void)configToolTitle:(NSString *)toolbarTitle {
    self.titleLabel.text = toolbarTitle;
}

/*
 *  设置确认按钮的文本
 *
 *  @param toolbarOKTitle   确认按钮的文本
 *  @param okHandle         点击确认按钮的事件
 */
- (void)configOKButtonTitle:(nullable NSString *)toolbarOKTitle
             okButtonHandle:(void(^ _Nullable)(void))okHandle
{
    self.okButton.hidden = toolbarOKTitle.length == 0;
    
    [self.okButton setTitle:toolbarOKTitle forState:UIControlStateNormal];
    _okHandle = okHandle;
}

/*
 *  设置取消按钮的文本
 *
 *  @param toolbarCancelTitle   取消按钮的文本
 *  @param cancelHandle         点击取消按钮的事件
 */
- (void)configCancelButtonTitle:(nullable NSString *)toolbarCancelTitle
             cancelButtonHandle:(void(^ _Nullable)(void))cancelHandle
{
    self.cancelButton.hidden = toolbarCancelTitle.length == 0;
    
    [self.cancelButton setTitle:toolbarCancelTitle forState:UIControlStateNormal];
    _cancelHandle = cancelHandle;
}


#pragma mark - Private Method
- (void)okAction {
    !self.okHandle ?: self.okHandle();
}

- (void)cancelAction {
    !self.cancelHandle ?: self.cancelHandle();
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
