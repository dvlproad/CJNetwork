//
//  CQTSRadioButtonsView.m
//  CJUIKitDemo
//
//  Created by ciyouzen on 7/9/15.
//  Copyright (c) 2015 dvlproad. All rights reserved.
//

#import "CQTSRadioButtonsView.h"
#import "CQTSButtonFactory.h"

@interface CQTSRadioButtonsView () {
    
}
@property (nonatomic, strong, readonly) NSArray<NSString *> *titles;
@property (nonatomic, strong) NSMutableArray<UIButton *> *buttons;
@property (nullable, nonatomic, copy, readonly) void(^didSelectItemAtIndexHandle)(NSInteger index); /**< 点击item的回调 */

@end


@implementation CQTSRadioButtonsView

#pragma mark - Init
/// 初始化 单行或单列的按钮组
///
/// @param titles                                              按钮的标题数组
/// @param axisType                                         按钮排列的方向（竖直/水平）
/// @param fixedSpacing                                 按钮之间的间距
/// @param didSelectItemAtIndexHandle  当前点击按钮的点击事件
///
/// @return 单选按钮组
- (instancetype)initWithTitles:(NSArray<NSString *> *)titles
                     alongAxis:(MASAxisType)axisType
                  fixedSpacing:(CGFloat)fixedSpacing
    didSelectItemAtIndexHandle:(void(^)(NSInteger index))didSelectItemAtIndexHandle
{
    _titles = titles;
    _didSelectItemAtIndexHandle = didSelectItemAtIndexHandle;
    
    __weak typeof(self) weakSelf = self;
    NSMutableArray *buttons = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < titles.count; i++) {
        NSString *title = [titles objectAtIndex:i];
        UIButton *radioButton = [CQTSButtonFactory radioButtonWithTitle:title clickHandle:^(UIButton * _Nonnull button) {
            [weakSelf didSelectItemAtIndex:i];
        }];
        // 添加checkView
        UILabel *checkedView = [[UILabel alloc] init];
        checkedView.tag = 973+i;
        checkedView.text = @"✅"; // 其他打勾符号：☑️ ✓
        [radioButton addSubview:checkedView];
        [checkedView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.mas_equalTo(radioButton);
            make.width.height.mas_equalTo(20);
        }];
        checkedView.hidden = YES;
        
        [buttons addObject:radioButton];
    }
    _buttons = buttons;
    
    self = [super initWithFrame:CGRectZero];
    if (self) {
        NSArray<UIView *> *subviews = buttons;
        UIView *containerView = self;
        for (UIView *view in subviews) {
            [containerView addSubview:view];
        }
        
        if (axisType == MASAxisTypeHorizontal) {
            [subviews mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:fixedSpacing leadSpacing:0 tailSpacing:0];
            [subviews mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.mas_equalTo(containerView);
            }];
            
        } else {
            [subviews mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:fixedSpacing leadSpacing:0 tailSpacing:0];
            [subviews mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(containerView);
            }];
        }
    }
    return self;
}

#pragma mark - Public Method
- (void)didSelectItemAtIndex:(NSInteger)index {
    if (index < 0 || index >= self.buttons.count) return;
    
    NSArray<NSString *> *titles = self.titles;
    for (NSInteger i = 0; i < titles.count; i++) {
        UIButton *radioButton = [self.buttons objectAtIndex:i];
        radioButton.selected = i == index;
        
        UILabel *checkedView = [radioButton viewWithTag:973+i];
        checkedView.hidden = i != index;
    }
    
    if (self.didSelectItemAtIndexHandle) {
        self.didSelectItemAtIndexHandle(index);
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
