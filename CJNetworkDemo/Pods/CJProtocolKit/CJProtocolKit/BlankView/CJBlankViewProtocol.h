//
//  CJBlankViewProtocol.h
//  CJProtocolKit
//
//  Created by ciyouzen on 2021/10/14.
//

#ifndef CJBlankViewProtocol_h
#define CJBlankViewProtocol_h

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*
 *  弹窗容器空白视图(blankView)的布局契约
 *  @brief 遵守本协议的是 blankView 本身（如 CJBasePopupBlankView 及其子类）：
 *         操作对象就是自己（self），按自身弹出位置（底部/中间等）实现
 *         updateConstraintsForPopupViewWithShow:，来显示/隐藏其中的 popupView。
 *         弹出策略不感知具体容器类型，只通过本契约驱动布局
 */
@protocol CJBlankViewProtocol <NSObject>

/*
 *  更新约束，根据是否显示popupView
 *
 *  @param show     是否显示popupView
 */
- (void)updateConstraintsForPopupViewWithShow:(BOOL)show;

@end

NS_ASSUME_NONNULL_END

#endif /* CJBlankViewProtocol_h */
