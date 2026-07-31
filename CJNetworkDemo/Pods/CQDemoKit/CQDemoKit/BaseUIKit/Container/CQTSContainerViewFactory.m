//
//  CQTSContainerViewFactory.m
//  CJUIKitDemo
//
//  Created by ciyouzen on 2020/1/31.
//  Copyright © 2020 dvlproad. All rights reserved.
//

#import "CQTSContainerViewFactory.h"

@interface CQTSContainerViewFactory () {
    
}

@end

@implementation CQTSContainerViewFactory

#pragma mark - 多视图的基础接口
/// 创建一个containerView，包含subviews。并且这些subviews在去除了他们之间的fixedSpacing间距后，以axisType竖直/水平方向，在container内用剩余的大小等大小排列
///
/// @param axisType                 container内的subviews排列的方向（竖直/水平）
/// @param subviews                 container要添加的subviews
/// @param fixedSpacing        container内的subviews之间的间距
///
/// @return containerView
+ (UIView *)containerViewAlongAxis:(MASAxisType)axisType
                      withSubviews:(NSArray<UIView *> *)subviews
                      fixedSpacing:(CGFloat)fixedSpacing
{
    NSAssert(subviews.count >= 0, @"视图个数不能为空");
    if (subviews.count == 1) {
        UIView *view = subviews[0];
        return view;
    }
    
    UIView *containerView = [[UIView alloc] init];
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
    
    return containerView;
}

@end
