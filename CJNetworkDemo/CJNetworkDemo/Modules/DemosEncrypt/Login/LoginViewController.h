//
//  LoginViewController.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 6/25/15.
//  Copyright (c) 2015 dvlproad. All rights reserved.
//

#import <CQDemoKit/CJUIKitBaseViewController.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface LoginViewController : CJUIKitBaseViewController{
    MBProgressHUD *HUD;
}
@property(nonatomic, strong) IBOutlet UITextField *nameTextField;
@property(nonatomic, strong) IBOutlet UITextField *pasdTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

@end
