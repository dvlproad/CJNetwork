//
//  CQLoadingHUD.h
//  AppCommonUICollect
//
//  Created by ciyouzen on 2018/9/20.
//  Copyright © 2018年 dvlproad. All rights reserved.
//
//  加载进度视图

#import <CJOverlayView/CJJSONProgressHUDView.h>

@interface CQLoadingHUD : CJJSONProgressHUDView {
    
}

- (void)play;
- (void)stop;

@end
