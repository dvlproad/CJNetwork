//
//  CQBottomCustomWithToolbarView.m
//  AppCommonUICollect
//
//  Created by ciyouzen on 2018/7/3.
//  Copyright © 2018年 dvlproad. All rights reserved.
//

#import "CQBottomCustomWithToolbarView.h"
#import <Masonry/Masonry.h>

@implementation CQBottomCustomWithToolbarView

#pragma mark - Init
/*
 *  初始化弹窗视图
 *
 *  @param customView       弹窗中的自定义主视图
 *
 *  @return 弹窗视图
 */
- (instancetype)initWithCustomView:(UIView *)customView {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        //self.backgroundColor = [UIColor redColor];

        CGFloat toolbarHeight = [CQBottomCustomWithToolbarView toolbarHeight];
        CQBottomToolbarView *toolbar = [[CQBottomToolbarView alloc] initWithFrame:CGRectZero];
        [self addSubview:toolbar];
        [toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self);
            make.height.equalTo(@(toolbarHeight));
        }];
        _toolbar = toolbar;
        
        [self addSubview:customView];
        [customView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(toolbar.mas_bottom);
            make.bottom.equalTo(self);
        }];
        _customView = customView;
    }
    return self;
}

/// 更新背景颜色，会同时更新toolbar上的背景色
- (void)updateBgType:(CQBottomPopupViewBGTheme)bgType {
    if (bgType == CQBottomPopupViewBGThemeBlack) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    } else if (bgType == CQBottomPopupViewBGThemeWhite) {
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    } else {
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1.0];
    }
    
    self.toolbar.bgType = bgType;
}

#pragma mark - Get Method
/*
 *  获取本视图工具栏的高度（使用场景：结合自定义视图的高度算出最后本视图的高度）
 *
 *  @return 本视图工具栏的高度
 */
+ (CGFloat)toolbarHeight {
    return 66;
}

/*
 *  获取视图高度
 *
 *  @param customViewHeight 自定义视图的高度
 *
 *  @return 整个视图的高度
 */
+ (CGFloat)contentViewHeightWithCustomViewHeight:(CGFloat)customViewHeight {
    return [self toolbarHeight] + customViewHeight;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
