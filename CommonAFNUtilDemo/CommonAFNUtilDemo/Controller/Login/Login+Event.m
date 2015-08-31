//
//  Login+Event.m
//  CommonAFNUtilDemo
//
//  Created by lichq on 6/25/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "Login+Event.h"

@implementation Login (Event)
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)login_dingdang:(id)sender{
    [self.view endEditing:YES];
    
    HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = NSLocalizedString(@"正在登录", nil);
    //HUD.dimBackground = YES;
    
    NSString *name = @"13055284289";
    NSString *pasd = @"123456";
    [CurrentAFNAPI requestLogin_name:name pasd:pasd success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"获取acces_token成功，登录成功");
        //[CommonHUD hud_showText:NSLocalizedString(@"登录成功", nil)];
        HUD.mode = MBProgressHUDModeText;
        HUD.labelText = NSLocalizedString(@"登录成功", nil);
        [HUD hide:YES afterDelay:1];
        
        [CurrentAFNAPI requestUser_GetInfo_success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"用户信息获取成功");
            //NSLog(@"%@",responseObject);
            NSDictionary *data = [responseObject objectForKey:@"data"];
            
            NSError *error;
            AccountInfo *uinfo = [[AccountInfo alloc] initWithDictionary:data error:&error];
            if (error) {
                NSLog(@"error.userInfo= %@", error.userInfo);
            }
            [LoginShareInfo shared].uinfo = uinfo;
            [LoginHelper login_name:name pasd:pasd];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"登录不了哦，再试试看！");
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        HUD.mode = MBProgressHUDModeText;
        HUD.labelText = NSLocalizedString(@"登录失败", nil);
        [HUD hide:YES afterDelay:1];
        
        NSLog(@"登录不了哦，再试试看！");
    }];
}

- (IBAction)getCourse_dingdang:(id)sender{
    if (![LoginHelper isLogin]) {
        NSLog(@"未登录，请先登录");
        return;
    }
    [CurrentAFNAPI requestCourse_Get_success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"缓存/非缓存数据。。。%@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"获取我的科目列表失败");
    }];
}

- (IBAction)login:(id)sender{
    [self.view endEditing:YES];
    
    HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = NSLocalizedString(@"正在登录", nil);
    //HUD.dimBackground = YES;
    
    NSString *Url = API_BASE_Url(@"login");
    NSDictionary *parameters = @{@"username": self.tfName.text,
                                 @"password": self.tfPasd.text};
    
    //delegate方式
    AFHTTPRequestOperationManager *manager = [CurrentAFNManager manager_health];
    AFHTTPRequestOperation *operation = [[CommonAFNInstance shareCommonAFNInstance] useManager_d:manager postRequestUrl:Url params:parameters delegate:self];

    
//    AFHTTPRequestOperation *operation = [[CommonAFNManager manager] postRequestUrl:Url params:parameters delegate:self];
    //block方式
    /*
    AFHTTPRequestOperation *operation =
    [[CommonAFNUtil manager] POST:Url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self onRequestSuccess:operation tag:0];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self onRequestFailure:operation tag:0];
    }];
    */
    
    [self.indicatorView setAnimatingWithStateOfOperation:operation];
}


- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [hud removeFromSuperview];
    hud = nil;
}

- (void)onRequestFailure:(AFHTTPRequestOperation *)operation tag:(NSInteger)tag failMesg:(NSString *)failMesg{
    HUD.mode = MBProgressHUDModeText;
    HUD.labelText = NSLocalizedString(@"登录失败", nil);
    [HUD hide:YES afterDelay:1];
}

- (void)onRequestSuccess:(AFHTTPRequestOperation *)operation tag:(NSInteger)tag responseObject:(id)responseObject{
    HUD.mode = MBProgressHUDModeText;
    HUD.labelText = NSLocalizedString(@"登录成功", nil);
    [HUD hide:YES afterDelay:1];
    
    NSString *uid = [responseObject valueForKeyPath:@"user.uid"];
    [LoginHelper login_UID:uid];
    
    [self.navigationController popViewControllerAnimated:YES];
}




@end
