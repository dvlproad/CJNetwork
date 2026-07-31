//
//  UIView+CJExit.m
//  TSPopupDemo
//
//  Created by qian on 2020/12/1.
//

#import "UIView+CJExit.h"

@implementation UIView (CJExit)

- (void)exitApplication {
    UIWindow *window;
    if (@available(iOS 13.0, *)) {
        window = [UIApplication sharedApplication].windows[0];
    } else {
        window = [UIApplication sharedApplication].delegate.window;
    }
    [UIView animateWithDuration:0.0f animations:^{
        window.alpha = 0;
        window.frame = CGRectMake(window.bounds.size.width/2.0, window.bounds.size.width, 0, 0);
    } completion:^(BOOL finished) {
        exit(0);
    }];
    
    
//    [UIView animateWithDuration:1.0f animations:^{
//        NSArray<UIWindow *> *windows = [UIApplication sharedApplication].windows;
//        for (UIWindow *window in windows) {
//            window.alpha = 0;
//            window.frame = CGRectMake(window.bounds.size.width/2.0, window.bounds.size.width, 0, 0);
//        }
//
//    } completion:^(BOOL finished) {
//        exit(0);
//    }];
}

@end
