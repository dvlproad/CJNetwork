//
//  LoginViewController.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 6/25/15.
//  Copyright (c) 2015 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface LoginViewController : UIViewController{
    MBProgressHUD *HUD;
}
@property(nonatomic, strong) IBOutlet UITextField *nameTextField;
@property(nonatomic, strong) IBOutlet UITextField *pasdTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

@end
