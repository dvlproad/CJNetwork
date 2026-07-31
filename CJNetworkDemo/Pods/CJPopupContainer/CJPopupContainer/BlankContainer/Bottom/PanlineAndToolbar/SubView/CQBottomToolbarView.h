//
//  CQBottomToolbarView.h
//  CJUIKitDemo
//
//  Created by qian on 2020/11/24.
//  Copyright © 2020 dvlproad. All rights reserved.
//
//  默认高度180

#import <UIKit/UIKit.h>
#import "CQBottomCustomWithToolbarViewEnum.h"

NS_ASSUME_NONNULL_BEGIN

@interface CQBottomToolbarView : UIView {
    
}
@property (nonatomic, assign) CQBottomPopupViewBGTheme bgType;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIButton *okButton;       /**< 确认按钮 */
@property (nonatomic, strong) UIButton *cancelButton;   /**< 取消按钮 */


/*
 *  设置标题和击完成按钮的事件(规则：没有确认按钮就没有取消按钮)
 *
 *  @param title            标题
 *  @param cancelHandle     点击取消按钮的事件
 *  @param okHandle         点击确认按钮的事件
 */
- (void)setupTitle:(NSString *)title cancelHandle:(void(^)(void))cancelHandle okHandle:(void(^)(void))okHandle;

/*
 *  设置标题
 *
 *  @param title            工具栏的标题
 */
- (void)configToolTitle:(NSString *)toolbarTitle;

/*
 *  设置确认按钮的文本
 *
 *  @param toolbarOKTitle   确认按钮的文本
 *  @param okHandle         点击确认按钮的事件
 */
- (void)configOKButtonTitle:(nullable NSString *)toolbarOKTitle
             okButtonHandle:(void(^ _Nullable)(void))okHandle;

/*
 *  设置取消按钮的文本
 *
 *  @param toolbarCancelTitle   取消按钮的文本
 *  @param cancelHandle         点击取消按钮的事件
 */
- (void)configCancelButtonTitle:(nullable NSString *)toolbarCancelTitle
             cancelButtonHandle:(void(^ _Nullable)(void))cancelHandle;

@end

NS_ASSUME_NONNULL_END
