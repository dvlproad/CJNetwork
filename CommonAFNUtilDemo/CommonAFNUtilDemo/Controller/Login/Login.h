//
//  Login.h
//  CommonAFNUtilDemo
//
//  Created by lichq on 6/25/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface Login : UIViewController{
    MBProgressHUD *HUD;
}
@property(nonatomic, strong) IBOutlet UITextField *tfName;
@property(nonatomic, strong) IBOutlet UITextField *tfPasd;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

@end
