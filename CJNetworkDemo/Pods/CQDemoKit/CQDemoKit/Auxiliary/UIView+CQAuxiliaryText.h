//
//  UIView+CQAuxiliaryText.h
//  CQDemoKit
//
//  Created by ciyouzen on 7/9/15.
//  Copyright (c) 2015 dvlproad. All rights reserved.
//
//  添加辅助文本(含删除)、添加任意辅助视图

// 包含上下中的枚举： UIControl.ContentVerticalAlignment
// 包含上下中左右的枚举： UIStackView.Alignment ,但只适用于Swift
// 包含左右中的枚举： NSTextAlignment
typedef NS_ENUM(NSInteger, CQAuxiliaryAlignment) {
    CQAuxiliaryAlignmentCenter,         // 视图中心
    CQAuxiliaryAlignmentTop,            // 视图内的顶部
    CQAuxiliaryAlignmentBottom,         // 视图内的底部
    CQAuxiliaryAlignmentFill,           // 辅助视图充满整个视图，且辅助视图的高度，使用视图的高度。
    
    // 视图外的顶部，即辅助视图的bottom在指定视图的top（使得能够显示得超出视图区域，可省去不影响视图的情况下，添加辅助信息)
    CQAuxiliaryAlignmentTopTop,
    
    // 视图外的底部，即辅助视图的top在指定视图的bottom（使得能够显示得超出视图区域，可省去不影响视图的情况下，添加辅助信息)
    CQAuxiliaryAlignmentBottomBottom,   // 视图外的底部
};

// 辅助文本的移除顺序（当有多个相同tag的辅助文本的时候需要）
typedef NS_ENUM(NSInteger, CQAuxiliaryRemove) {
    CQAuxiliaryRemoveFirstOne,      // 正序且一次只移除一个：按添加顺序移除
    CQAuxiliaryRemoveLastOne,       // 逆序且一次只移除一个：后添加到先移除
    CQAuxiliaryRemoveAll,           // 所有的都移除
};

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Prompt)

#pragma mark - 添加辅助文本
/// 添加辅助文本
- (void)cqts_addPromptText:(NSString *)text layout:(CQAuxiliaryAlignment)layout height:(CGFloat)height;

#pragma mark - 添加任意辅助视图
- (void)cqts_addPromptView:(UIView *)promptView layout:(CQAuxiliaryAlignment)layout height:(CGFloat)height;

#pragma mark - 删除任意辅助文本/视图
/// 删除辅助文本
- (void)cqts_removePrompt:(CQAuxiliaryRemove)order;

@end

NS_ASSUME_NONNULL_END
