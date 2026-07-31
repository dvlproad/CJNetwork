//
//  CJBlankPresenterProtocol.h
//  CJProtocolKit
//
//  Created by ciyouzen on 2021/10/14.
//

#ifndef CJBlankPresenterProtocol_h
#define CJBlankPresenterProtocol_h

#import <UIKit/UIKit.h>

// 前向声明布局契约协议，避免跨模块/跨库引用类型（防止"declaration not visible"），使用时再导入完整头文件
@protocol CJBlankViewProtocol;

NS_ASSUME_NONNULL_BEGIN

/*
 *  弹窗空白视图(blankView)的展示者协议（负责"怎么弹"）
 *  @brief 遵守本协议的是 blankView 的展示者（presenter，默认实现 CJBlankDefaultPresenter），而非 blankView 本身：
 *         操作对象是方法传入的 blankView 参数——把 blankView 加到 popupSuperview 上，
 *         并调用其布局契约 updateConstraintsForPopupViewWithShow: 来显示/隐藏其中的 popupView。
 *         展示者只依赖布局契约 CJBlankViewProtocol，不感知具体容器类型；
 *         "弹到底部还是中间"由容器自己决定（blankView 自己实现布局契约）
 *  @note  展示者以实例方法提供，可携带各自的配置/状态；实例由 blankView 持有（blankView.popupStrategy），
 *         显示前需先给 blankView 设置
 *
 *  @note  为什么本协议依赖 CJBlankViewProtocol：
 *         ① 本协议方法操作的对象就是 blankView，方法签名用 UIView<CJBlankViewProtocol> 来声明参数，
 *            即"接受任何遵守布局契约的 blankView"，约束其必须能提供布局能力点——面向抽象（协议）而非具体容器类；
 *         ② 依赖方向单向无环：仅 CJBlankPresenterProtocol → CJBlankViewProtocol，
 *            CJBlankViewProtocol 不反向依赖本协议（若反向依赖则两协议成环）；
 *         ③ 与具体容器（如 CJBottomBlankView/CJCenterBlankView）解耦，任意遵守布局契约的 blankView
 *            都可被本协议的任意实现（presenter）驱动弹出。
 */
@protocol CJBlankPresenterProtocol <NSObject>

/*
 *  显示最完整弹窗视图blankView
 *
 *  @param blankView            要显示的含点击背景的最完整弹窗视图blankView
 *  @param popupSuperview       要显示在什么视图上(为nil时候，显示在keyWindow上)
 */
- (void)showBlankView:(UIView<CJBlankViewProtocol> *)blankView inView:(nullable UIView *)popupSuperview;

/*
 *  隐藏最完整弹窗视图blankView
 *
 *  @param blankView            要隐藏的含点击背景的最完整弹窗视图blankView
 */
- (void)hideBlankView:(UIView<CJBlankViewProtocol> *)blankView;

@end

NS_ASSUME_NONNULL_END

#endif /* CJBlankPresenterProtocol_h */
