//
//  CQTSAlertManager.m
//  CJUIKitDemo
//
//  Created by ciyouzen on 2018/9/3.
//  Copyright © 2018年 dvlproad. All rights reserved.
//

#import "CQTSAlertManager.h"

@interface CQTSAlertManager () {
    
}
@property (nonatomic, strong) UIAlertController *networkNoOpenAlertVC;      /**< 网络权限没打开的alert */
@property (nonatomic, strong) UIAlertController *locationNoOpenAlertVC;     /**< 定位权限没打开的alert */
@property (nonatomic, strong) UIAlertController *locationAbnormalAlertVC;   /**< 定位权限异常的alert */


@end



@implementation CQTSAlertManager

+ (CQTSAlertManager *)sharedInstance {
    static CQTSAlertManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

///显示和隐藏网络权限没打开的alert
- (void)showNetworkNoOpenAlert:(BOOL)show {
    if (!show) {
        if (self.networkNoOpenAlertVC) {
            [self.networkNoOpenAlertVC dismissViewControllerAnimated:NO completion:nil];
            self.networkNoOpenAlertVC = nil;
        }
    } else {
        if (self.networkNoOpenAlertVC) {
            return;
        }
        NSString *networkNoOpenText = NSLocalizedString(@"网络链接失败，请检查您的网络链接", nil);
        NSString *networkGoOpenText = NSLocalizedString(@"查看设置", nil);
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:networkNoOpenText message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:networkGoOpenText style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.networkNoOpenAlertVC = nil;
            NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:settingsURL]) {
                [[UIApplication sharedApplication] openURL:settingsURL options:@{} completionHandler:nil];
            }
        }];
        [alertVC addAction:okAction];
        self.networkNoOpenAlertVC = alertVC;
        
        UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
        [rootVC presentViewController:alertVC animated:YES completion:nil];
    }
}


@end
