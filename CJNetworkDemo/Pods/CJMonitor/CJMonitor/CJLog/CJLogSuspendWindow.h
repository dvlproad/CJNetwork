//
//  CJLogSuspendWindow.h
//  CJUIKitDemo
//
//  Created by ciyouzen on 2017/5/20.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CJLogViewWindow.h"

/**
 *  用于控制log视图的弹出与隐藏的悬浮球
 */
@interface CJLogSuspendWindow : UIWindow {
    
}
@property(nonatomic, copy) NSString *windowIdentifier;
@property (nonatomic, copy) void (^clickWindowBlock)(UIButton *clickButton);
@property (nonatomic, copy) void (^closeWindowBlock)(void);

/*
 *  显示
 *
 *  @param frame            要显示到的位置
 *  @param configBlock      对这个按钮窗口的定制(可拖动、拖动吸附等)
 */
+ (void)showWithFrame:(CGRect)frame configBlock:(void(^ _Nullable)(CJLogSuspendWindow *bSuspendWindow))configBlock;

///移除
+ (void)removeFromScreen;

@end
