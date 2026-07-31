//
//  CJCenterBCIKnowPopupView.h
//  AppCommonUICollect
//
//  Created by ciyouzen on 2019/10/22.
//  Copyright © 2019 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
*  中部弹窗通用视图(常用于【从底部弹出内容提示】等弹窗：‘我知道了’按钮 位于 内容区域下方固定间距)
*/
@interface CJCenterBCIKnowPopupView : UIView {
    
}
//@property (nonatomic, copy, readonly) void(^closeBlock)(void);  /**< 关闭弹窗的事件 */

/**
 *  初始化弹窗视图
 *
 *  @param popupContentView         弹窗主视图(位于关闭按钮上方的那个内容视图)
 *  @param clickConfirmButtonBlock  点击'我知道了'按钮的回调
 *
 *  @return 弹窗视图
 */
- (instancetype)initWithPopupContentView:(UIView *)popupContentView
                 clickConfirmButtonBlock:(void(^)(void))clickConfirmButtonBlock NS_DESIGNATED_INITIALIZER;
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
