//
//  CQBottomCustomWithToolbarView.h
//  AppCommonUICollect
//
//  Created by ciyouzen on 2018/7/3.
//  Copyright © 2018年 dvlproad. All rights reserved.
//
//  视图：创建由 ToolBar(取消、完成)+自定义视图 组成的视图(常作为底部弹出视图)

#import <UIKit/UIKit.h>
#import "CQBottomToolbarView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CQBottomCustomWithToolbarView : UIView {
    
}
@property (nonatomic, strong, readonly) CQBottomToolbarView *toolbar;
@property (nonatomic, strong, readonly) UIView *customView;

#pragma mark - Init
/*
 *  初始化弹窗视图
 *
 *  @param customView       弹窗中的自定义主视图
 *
 *  @return 弹窗视图
 */
- (instancetype)initWithCustomView:(UIView *)customView;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

/// 更新背景颜色，会同时更新toolbar上的背景色
- (void)updateBgType:(CQBottomPopupViewBGTheme)bgType;


#pragma mark - Get Method

/*
 *  获取本视图工具栏的高度（使用场景：结合自定义视图的高度算出最后本视图的高度）
 *
 *  @return 本视图工具栏的高度
 */
+ (CGFloat)toolbarHeight;

/*
 *  获取视图高度
 *
 *  @param customViewHeight 自定义视图的高度
 *
 *  @return 整个视图的高度
 */
+ (CGFloat)contentViewHeightWithCustomViewHeight:(CGFloat)customViewHeight;

@end

NS_ASSUME_NONNULL_END
