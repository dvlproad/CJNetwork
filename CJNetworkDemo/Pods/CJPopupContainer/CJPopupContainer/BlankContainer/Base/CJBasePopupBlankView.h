//
//  CJBasePopupBlankView.h
//  CJUIKitDemo
//
//  Created by ciyouzen on 15/11/12.
//  Copyright (c) 2015年 dvlproad. All rights reserved.
//
//  整弹出框的容器视图blankContainer（每一个弹窗的背景点击回调都不一样）
//  注意：当正在关闭弹窗的时候，应该禁用整个视图的所有点击（防止尤其是当关闭耗时时候，多次进行的空白区域的快速点击导致重复调用）

#import <UIKit/UIKit.h>
#import <CJProtocolKit/CJBlankViewProtocol.h>

// 前向声明弹出策略协议，避免跨模块/跨库引用类型（防止"declaration not visible"），使用时再导入完整头文件
@protocol CJBlankPresenterProtocol;

NS_ASSUME_NONNULL_BEGIN

// 注意：当正在关闭弹窗的时候，应该禁用整个视图的所有点击（防止尤其是当关闭耗时时候，多次进行的空白区域的快速点击导致重复调用）
@interface CJBasePopupBlankView : UIView <CJBlankViewProtocol> {
    
}

#pragma mark - Init
/*
 *  初始化（本类仅创建空白可点击区域，不管理 popupView。
 *  子类应在自己的 init 中设置 popupView，详见 CJBottomBlankView / CJCenterBlankView）
 *
 *  @param tapBlankHandle       点击视图的回调（每一个弹窗的背景点击回调都不一样）
 *
 *  @return 完整弹出框的容器视图blankContainer
 */
- (instancetype)initWithTapBlankHandle:(void(^ _Nullable)(CJBasePopupBlankView *bSelf))tapBlankHandle NS_DESIGNATED_INITIALIZER;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

#pragma mark - Popup
/*
 *  弹出策略（负责"怎么弹"，由本容器持有）
 *  @brief 显示前调用方需设置，隐藏通过它来执行（为nil时隐藏为无操作）
 */
@property (nonatomic, strong, nullable) id<CJBlankPresenterProtocol> popupStrategy;

/*
 *  显示本容器视图（内部委托给 popupStrategy 执行）
 *  @brief 显示前需先设置 popupStrategy，否则为无操作
 *
 *  @param popupSuperview       要显示在什么视图上(为nil时候，显示在keyWindow上)
 */
- (void)showBlankViewInView:(nullable UIView *)popupSuperview;

/*
 *  隐藏本容器视图（内部委托给 popupStrategy 执行）
 *  @brief 为nil时隐藏为无操作
 */
- (void)hideBlankView;

#pragma mark - updateConstraints
/*
 *  更新约束，根据是否显示popupView
 *  @brief 各子类按自己的弹出位置实现此方法（如底部容器将popupView约束到底部，中间容器约束到中间），
 *         它是容器暴露给弹出策略的统一布局契约，弹出策略通过它来显示/隐藏popupView
 *
 *  @param show     是否显示popupView
 */
- (void)updateConstraintsForPopupViewWithShow:(BOOL)show;

+ (void)cjPopup_makeView:(UIView *)superView addSubView:(UIView *)subView withEdgeInsets:(UIEdgeInsets)edgeInsets;

@end

NS_ASSUME_NONNULL_END
