//
//  CQTSContainerViewFactory.h
//  CJUIKitDemo
//
//  Created by ciyouzen on 2020/1/31.
//  Copyright © 2020 dvlproad. All rights reserved.
//
//  创建子视图均分的containerView

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <Masonry/Masonry.h>

NS_ASSUME_NONNULL_BEGIN

@interface CQTSContainerViewFactory : NSObject

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
                      fixedSpacing:(CGFloat)fixedSpacing;


@end

NS_ASSUME_NONNULL_END
