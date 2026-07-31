//
//  CJBottomTRClosePopupView.h
//  AppCommonUICollect
//
//  Created by ciyouzen on 2019/10/22.
//  Copyright © 2019 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  底部弹窗通用视图(常用于【从底部弹出规则内容】等弹窗：‘关闭’按钮 位于 内容区域右上角)
 */
@interface CJBottomTRClosePopupView : UIView {
    
}

/*
 *  初始化弹窗视图
 *
 *  @param popupContentView         弹窗主视图(‘关闭’按钮 位于 内容区域右上角)
 *  @param closeButtonCompleteBlock 关闭弹窗按钮的事件(默认为nil,如果非nil,则需要自己控制隐藏操作)
 *
 *  @return 弹窗视图
 */
- (instancetype)initWithPopupContentView:(UIView *)popupContentView
                closeButtonCompleteBlock:(void(^ _Nullable)(CJBottomTRClosePopupView *bPopupView))closeButtonCompleteBlock NS_DESIGNATED_INITIALIZER;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;


@end

NS_ASSUME_NONNULL_END
