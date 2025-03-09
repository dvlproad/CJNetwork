//
//  CQHUDUtil.m
//  AppCommonUICollect
//
//  Created by ciyouzen on 2018/9/20.
//  Copyright © 2018年 dvlproad. All rights reserved.
//

#import "CQHUDUtil.h"
//#import <SVProgressHUD/SVProgressHUD.h>
#import "CQJsonHUDUtil.h"
#import "CQIndicatorHUDUtil.h"

@interface CQHUDUtil () {
    
}

@end


@implementation CQHUDUtil

#pragma mark - 使用时候调用
+ (void)showLoadingHUD {
//    [SVProgressHUD show];
//    [CQJsonHUDUtil showLoadingHUD];
    [CQIndicatorHUDUtil showLoadingHUD:nil];
}

+ (void)dismissLoadingHUD {
//    [SVProgressHUD dismiss];
//    [CQJsonHUDUtil dismissLoadingHUD];
    [CQIndicatorHUDUtil dismissLoadingHUD];
}

#pragma mark - 获取与全局动画一致的ProgressHUD对象
/**
 *  获取与全局动画一致的新的的ProgressHUD对象
 */
+ (CQLoadingHUD *)defaultLoadingHUD {
    CJIndicatorProgressHUDView *hudView = [[CJIndicatorProgressHUDView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    return hudView;
//    return [CQIndicatorHUDUtil defaultLoadingHUD];
//    return [CQJsonHUDUtil defaultLoadingHUD];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
