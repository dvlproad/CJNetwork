//
//  UploadViewController.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2017/4/5.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "UploadViewController.h"
#import "IjinbuNetworkClient+UploadFile.h"

#import <SVProgressHUD/SVProgressHUD.h>

@interface UploadViewController ()

@end

@implementation UploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)uploadFile:(id)sender {
    NSMutableArray<CJUploadFileModel *> *uploadFileModels = [[NSMutableArray alloc] init];
    
    NSString *imageName = @"op1.jpg";
    UIImage *image = [UIImage imageNamed:@"op1.jpg"];
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    
    //图片
    CJUploadFileModel *imageUploadModel = [[CJUploadFileModel alloc] init];
    imageUploadModel.uploadItemType = CJUploadItemTypeImage;
    imageUploadModel.uploadItemData = imageData;
    imageUploadModel.uploadItemName = imageName;
    [uploadFileModels addObject:imageUploadModel];
    
    IjinbuUploadItemRequest *uploadItemRequest = [[IjinbuUploadItemRequest alloc] init];
    uploadItemRequest.uploadItemToWhere = 16;
    uploadItemRequest.uploadFileModels = uploadFileModels;
    
    [[IjinbuNetworkClient sharedInstance] ijinbu_uploadFile:uploadItemRequest progress:nil completeBlock:^(IjinbuResponseModel *responseModel) {
        if (responseModel.status == 0) {
            [SVProgressHUD showSuccessWithStatus:@"上传成功"];
        } else {
            [SVProgressHUD showErrorWithStatus:@"上传失败"];
        }
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
