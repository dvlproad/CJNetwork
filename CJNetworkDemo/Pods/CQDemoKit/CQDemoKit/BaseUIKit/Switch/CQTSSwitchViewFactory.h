//
//  CQTSSwitchViewFactory.h
//  CJUIKitDemo
//
//  Created by ciyouzen on 2020/1/31.
//  Copyright © 2020 dvlproad. All rights reserved.
//
//  含标题的开关视图

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CQTSSwitchViewFactory : NSObject

#pragma mark - 含标题的开关视图
+ (UIView *)switchViewWithTitle:(NSString *)title
                       switchOn:(BOOL)switchOn
        switchValueChangedBlock:(void(^)(UISwitch *bSwitch))switchValueChangedBlock;


@end

NS_ASSUME_NONNULL_END
