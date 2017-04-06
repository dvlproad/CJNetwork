//
//  UploadViewController.m
//  CommonAFNUtilDemo
//
//  Created by dvlproad on 2017/4/5.
//  Copyright © 2017年 ciyouzen. All rights reserved.
//

#import "UploadViewController.h"
#import "IjinbuNetworkClient+UploadFile.h"

@interface UploadViewController ()

@end

@implementation UploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)uploadFile:(id)sender {
    NSMutableArray<CJUploadItemModel *> *uploadItems = [[NSMutableArray alloc] init];
    
    NSString *imageName = @"op1.jpg";
    UIImage *image = [UIImage imageNamed:@"op1.jpg"];
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    
    //图片
    CJUploadItemModel *imageUploadModel = [[CJUploadItemModel alloc] init];
    imageUploadModel.uploadItemType = CJUploadItemTypeImage;
    imageUploadModel.uploadItemData = imageData;
    imageUploadModel.uploadItemName = imageName;
    [uploadItems addObject:imageUploadModel];
    
    IjinbuUploadItemRequest *uploadItemRequest = [[IjinbuUploadItemRequest alloc] init];
    uploadItemRequest.uploadItemToWhere = 16;
    uploadItemRequest.uploadItems = uploadItems;
    
    [[IjinbuNetworkClient sharedInstance] requestUploadFile:uploadItemRequest progress:nil success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [SVProgressHUD showSuccessWithStatus:@"上传成功"];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        [SVProgressHUD showErrorWithStatus:@"上传失败"];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end