//
//  CJBottomAgreeNoPopupView.h
//  TSPopupDemo
//
//  Created by ciyouzen on 2019/10/22.
//  Copyright © 2019 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  底部弹窗通用视图(常用于【从底部弹出规则内容】等弹窗：‘关闭’按钮 位于 内容区域右上角)
 */
@interface CJBottomAgreeNoPopupView : UIView {
    
}

#pragma mark - Init
/*
 *  初始化弹窗视图
 *
 *  @param popupContentView         弹窗主视图(位于关闭按钮上方的那个内容视图)
 *  @param cancelBlock              取消事件(默认为nil,如果非nil,则需要自己控制隐藏弹窗操作)
 *  @param okBlock                  确认事件(默认为nil,如果非nil,则需要自己控制隐藏弹窗操作)
 *
 *  @return 弹窗视图
 */
- (instancetype)initWithPopupContentView:(UIView *)popupContentView cancelBlock:(void(^ _Nullable)(CJBottomAgreeNoPopupView *bPopupView))cancelBlock okBlock:(void(^ _Nullable)(CJBottomAgreeNoPopupView *bPopupView))okBlock NS_DESIGNATED_INITIALIZER;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

#pragma mark - Get Method
/*
 *  获取视图高度
 *
 *  @param popupContentViewHeight 初始化popupContentView传入的高度
 *
 *  @return 本视图的高度
 */
- (CGFloat)viewHeightWithContentHeight:(CGFloat)popupContentViewHeight;

@end

NS_ASSUME_NONNULL_END
