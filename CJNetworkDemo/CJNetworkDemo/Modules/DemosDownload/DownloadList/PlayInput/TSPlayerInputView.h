//
//  TSPlayerInputView.h
//  CJUIKitDemo
//
//  Created by ciyouzen on 8/10/15.
//  Copyright (c) 2015 dvlproad. All rights reserved.

//  用于下载列表的输入框

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TSPlayerInputView : UIView {
    
}
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *fetchButton;

#pragma mark - Init
/*
 *  初始化视图
 *
 *  @param fetchVideoHandle   点击item的回调
 *
 *  @return 视图
 */
- (instancetype)initWithFetchVideoHandle:(void (^)(NSString *text))fetchVideoHandle NS_DESIGNATED_INITIALIZER;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

#pragma mark - Event
// 处理粘贴板粘贴功能
- (void)pasteClipboard;

@end

NS_ASSUME_NONNULL_END
