//
//  CJBottomClearPopupView.m
//  AppCommonUICollect
//
//  Created by ciyouzen on 2019/10/22.
//  Copyright © 2019 dvlproad. All rights reserved.
//

#import "CJBottomClearPopupView.h"
#import <Masonry/Masonry.h>

@interface CJBottomClearPopupView () {
    
}
@property (nonatomic, strong) UIView *popupContentView; /**< 弹窗主视图(位于关闭按钮上方的那个内容视图) */


@end


@implementation CJBottomClearPopupView

/**
 *  初始化弹窗视图
 *
 *  @param popupContentView 弹窗主视图(位于关闭按钮上方的那个内容视图)
 *
 *  @return 弹窗视图
 */
- (instancetype)initWithPopupContentView:(UIView *)popupContentView {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        //self.backgroundColor = [UIColor redColor];

        CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
        BOOL isScreenFull = screenHeight >= 812 && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;  // 是否是全面屏
        CGFloat screenBottomHeight = isScreenFull ?  34.0 : 0.0;    // 屏幕底部
        
        UIView *screenBottomView = [[UIView alloc] init];
        screenBottomView.backgroundColor = [UIColor whiteColor];
        [self addSubview:screenBottomView];
        [screenBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self);
            make.bottom.mas_equalTo(self);
            make.height.mas_equalTo(screenBottomHeight);
        }];
        
        [self addSubview:popupContentView];
        [popupContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(self);
            make.bottom.mas_equalTo(screenBottomView.mas_top);
        }];
        self.popupContentView = popupContentView;
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
