//
//  Login+Event.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 6/25/15.
//  Copyright (c) 2015 dvlproad. All rights reserved.
//

#import "Login+Event.h"

#import "HealthyNetworkClient.h"
#import "DingdangNetworkClient.h"
#import "IjinbuNetworkClient+Login.h"

#import "UploadViewController.h"

@implementation Login (Event)
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    
    NSDictionary *params = @{@"uid":            @"13141",
                             @"access_token":   @"dfdfd"};
    
    NSMutableString *postString = [NSMutableString new];
    for (NSString *key in [params allKeys]) {
        id obj = [params valueForKey:key];
        if ([obj isKindOfClass:[NSString class]]) {
            if (postString.length!=0) {
                [postString appendString:@"&"];
            }
            [postString appendFormat:@"%@=%@",key,obj];
        }
        if ([obj isKindOfClass:[NSArray class]]) {
            for (NSString *value in obj) {
                if (postString.length!=0) {
                    [postString appendString:@"&"];
                }
                [postString appendFormat:@"%@=%@",key,value];
            }
        }
    }
    
    
    NSData *bodyData1 = [postString dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"bodyData1 = %@", bodyData1);
    NSLog(@"postString = %@", postString);
    
    //打印JSONObject
    NSData *bodyData2 = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    NSString *postString2 = [[NSString alloc] initWithData:bodyData2 encoding:NSUTF8StringEncoding];
    NSLog(@"bodyData2 = %@", bodyData2);
    NSLog(@"postString2 = %@", postString2);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

///登录（健康）
- (IBAction)login_health:(id)sender{
    [self.view endEditing:YES];
    [SVProgressHUD showWithStatus:NSLocalizedString(@"正在登录", nil)];
    
    NSString *name = self.nameTextField.text;
    NSString *pasd = self.pasdTextField.text;
    [[HealthyNetworkClient sharedInstance] requestLogin_name:name pasd:pasd completeBlock:^(CJResponseModel *responseModel) {
        if (responseModel.status == 0) {
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
            
            
        } else {
            //        NSString *failMesg = [error localizedDescription];
            //        failMesg = [failMesg cjEncodeUnicodeToChinese];
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"登录失败", nil)];
        }
    }];
}


///登录（叮当）
- (IBAction)login_dingdang:(id)sender{
    [self.view endEditing:YES];
    
    [SVProgressHUD showWithStatus:NSLocalizedString(@"正在登录", nil)];
    
    NSString *name = @"13055284289";
    NSString *pasd = @"123456";
    [[DingdangNetworkClient sharedInstance] requestDDLogin_name:name pasd:pasd completeBlock:^(CJResponseModel *responseModel) {
        if (responseModel.status == 0) {
            [SVProgressHUD showSuccessWithStatus:@"登录成功"];//获取acces_token成功，登录成功
            
            [self getUserInfoByUserName:name password:pasd];
        } else {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"登录失败", nil)];//登录不了哦，再试试看！
        }
    }];
}

- (void)getUserInfoByUserName:(NSString *)userName password:(NSString *)password {
    [[DingdangNetworkClient sharedInstance] requestDDUser_GetInfo_completeBlock:^(CJResponseModel *responseModel) {
        if (responseModel.status == 0) {
            NSLog(@"用户信息获取成功");
            //NSLog(@"%@",responseObject);
            NSDictionary *responseResult = responseModel.result;
            NSDictionary *data = [responseResult objectForKey:@"data"];
            
            NSError *error;
            AccountInfo *uinfo = [[AccountInfo alloc] initWithDictionary:data error:&error];
            if (error) {
                NSLog(@"error.userInfo= %@", error.userInfo);
            }
            [LoginShareInfo shared].uinfo = uinfo;
            [LoginHelper login_name:userName pasd:password];
            
        } else {
            NSLog(@"登录不了哦，再试试看！");
        }
    }];
}

///获取我的科目资料(叮当)
- (IBAction)getCourse_dingdang:(id)sender{
    if (![LoginHelper isLogin]) {
        NSLog(@"未登录，请先登录");
        return;
    }
    [[DingdangNetworkClient sharedInstance] requestDDCourse_Get_completeBlock:^(CJResponseModel *responseModel) {
        if (responseModel.status == 0) {
            NSLog(@"缓存/非缓存数据。。。%@", responseModel);
        } else {
            NSLog(@"获取我的科目列表失败");
        }
     
    }];
}

///登录（ijinbu）
- (IBAction)login_ijinbu:(id)sender {
    [self.view endEditing:YES];
    [SVProgressHUD showWithStatus:NSLocalizedString(@"正在登录", nil)];
    
    NSString *name = @"18020721201";
    NSString *pasd = @"123456";
    
    /*
    [[CheckVersionNetworkClient sharedInstance] requestijinbuLogin_name:name pasd:pasd success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD showSuccessWithStatus:@"登录成功"];
        
    } failure:^(NSURLSessionDataTask *task, NSString *errorMessage) {
        [SVProgressHUD showErrorWithStatus:errorMessage];//登录不了哦，再试试看！
    }];
    */
    
    [[IjinbuNetworkClient sharedInstance] requestijinbuLogin_name:name pasd:pasd completeBlock:^(IjinbuResponseModel *responseModel) {
        if (responseModel.status == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showSuccessWithStatus:@"登录成功"];
                UploadViewController *viewController = [[UploadViewController alloc] initWithNibName:@"UploadViewController" bundle:nil];
                [self.navigationController pushViewController:viewController animated:YES];
            });
            
        } else {
            [SVProgressHUD showErrorWithStatus:@"登录失败"];//登录不了哦，再试试看！
        }
     
    }];
}


@end
