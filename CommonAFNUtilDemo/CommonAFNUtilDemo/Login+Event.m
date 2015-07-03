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
    AFHTTPRequestOperation *operation = [CommonAFNUtil postRequestUrl:Url params:parameters delegate:self];
    
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

- (void)onRequestSuccess:(AFHTTPRequestOperation *)operation tag:(NSInteger)tag{
    HUD.mode = MBProgressHUDModeText;
    HUD.labelText = NSLocalizedString(@"登录成功", nil);
    [HUD hide:YES afterDelay:1];
    
    id responseObject = operation.responseObject;
    NSString *uid = [responseObject objectForKey:@"id"];
    [[NSUserDefaults standardUserDefaults] setObject:uid forKey:kUID];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onRequestFailure:(AFHTTPRequestOperation *)operation tag:(NSInteger)tag{
    HUD.mode = MBProgressHUDModeText;
    HUD.labelText = NSLocalizedString(@"登录失败", nil);
    [HUD hide:YES afterDelay:1];
}



@end
