//
//  Login+Event.m
//  CommonAFNUtilDemo
//
//  Created by lichq on 6/25/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "Login+Event.h"
#import "NSString+Encoding.h"

@implementation Login (Event)
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


- (IBAction)login_health:(id)sender{
    [self.view endEditing:YES];
    [SVProgressHUD showWithStatus:NSLocalizedString(@"正在登录", nil) maskType:SVProgressHUDMaskTypeBlack];
    
    NSString *name = self.tfName.text;
    NSString *pasd = self.tfPasd.text;
    [CurrentAFNAPI requestLogin_name:name pasd:pasd success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"登录成功", nil)];
        /*
         NSDictionary *dic = [responseObject objectForKey:@"user"];
         NSError *error;
         AccountInfo *uinfo = [[AccountInfo alloc] initWithDictionary:dic error:&error];
         if (error) {
         NSLog(@"error.userInfo = %@", error.userInfo);
         }
         [LoginShareInfo shared].uinfo = uinfo;
         [LoginHelper login_name:name pasd:pasd];
         */
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        failMesg = [failMesg Unicode_To_Chinese];
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"登录失败", nil)];
    }];
}


- (IBAction)login_dingdang:(id)sender{
    [self.view endEditing:YES];
    [SVProgressHUD showWithStatus:NSLocalizedString(@"正在登录", nil) maskType:SVProgressHUDMaskTypeBlack];
    
    NSString *name = @"13055284289";
    NSString *pasd = @"123456";
    [CurrentAFNAPI requestDDLogin_name:name pasd:pasd success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD showSuccessWithStatus:@"登录成功"];//获取acces_token成功，登录成功
        
        [CurrentAFNAPI requestDDUser_GetInfo_success:^(NSURLSessionDataTask *task, id responseObject) {
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
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"登录不了哦，再试试看！");
        }];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"登录失败", nil)];//登录不了哦，再试试看！
    }];
}

- (IBAction)getCourse_dingdang:(id)sender{
    if (![LoginHelper isLogin]) {
        NSLog(@"未登录，请先登录");
        return;
    }
    [CurrentAFNAPI requestDDCourse_Get_success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"缓存/非缓存数据。。。%@", responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"获取我的科目列表失败");
    }];
}


- (IBAction)login_ijinbu:(id)sender {
    [self.view endEditing:YES];
    [SVProgressHUD showWithStatus:NSLocalizedString(@"正在登录", nil) maskType:SVProgressHUDMaskTypeBlack];
    
    NSString *name = @"18020721201";
    NSString *pasd = @"123456";
    [CurrentAFNAPI requestijinbuLogin_name:name pasd:pasd success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD showSuccessWithStatus:@"登录成功"];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"登录失败", nil)];//登录不了哦，再试试看！
    }];
}


@end
