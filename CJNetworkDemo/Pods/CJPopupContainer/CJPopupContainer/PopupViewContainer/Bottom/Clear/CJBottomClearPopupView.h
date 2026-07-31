//
//  CJBottomClearPopupView.h
//  AppCommonUICollect
//
//  Created by ciyouzen on 2019/10/22.
//  Copyright © 2019 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  底部弹窗通用视图(常用于【从底部弹出日期选择】等弹窗)
 */
@interface CJBottomClearPopupView : UIView {
    
}

/**
 *  初始化弹窗视图
 *
 *  @param popupContentView 弹窗主视图(位于关闭按钮上方的那个内容视图)
 *
 *  @return 弹窗视图
 */
- (instancetype)initWithPopupContentView:(UIView *)popupContentView NS_DESIGNATED_INITIALIZER;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
