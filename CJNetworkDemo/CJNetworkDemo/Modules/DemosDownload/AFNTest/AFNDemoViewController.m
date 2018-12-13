//
//  AFNDemoViewController.m
//  Lee
//
//  Created by ciyouzen on 6/3/15.
//  Copyright (c) 2015 dvlproad. All rights reserved.
//

#import "AFNDemoViewController.h"
#import <AFNetworking/UIActivityIndicatorView+AFNetworking.h>   //UIActivityIndicatorView
#import <AFNetworking/UIImageView+AFNetworking.h>               //UIImage
#import <AFNetworking/AFHTTPSessionManager.h>

@interface AFNDemoViewController ()

@end

@implementation AFNDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


#pragma mark - 图片获取
- (IBAction)testImageView:(id)sender{
    NSURL *URL = [NSURL URLWithString:@"http://d.hiphotos.baidu.com/image/w%3D310/sign=21bab078bd096b63811958513c328733/ac345982b2b7d0a2270873cac8ef76094a369aa7.jpg"];
    UIImage *image = [UIImage imageNamed:@"people_default"];
    
    /*
    //下载方法①：
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:URL];
    [self.imageV setImage:[UIImage imageWithData:imageData]];
    */
    
    /*
    //下载方法②：
    [self.imageV setImageWithURL:URL placeholderImage:image];//placeholder-avatar
    */
    
    //下载方法③：
    NSURLRequest *request = [NSURLRequest requestWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    UIImageView *imageV = self.imageV;
    [self.imageV setImageWithURLRequest:request placeholderImage:image success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        NSLog(@"图片获取成功: response = %@", response);
        [imageV setImage:image];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"图片获取失败: response = %@, error = %@", response, [error description]);
    }];
}


//下载文件:创建一个下载文件的任务
- (IBAction)testDownloading:(id)sender{
    [AFNDemoViewController sessionDownloadWithUrl:Test_ImageUrl2 success:nil fail:nil];
}

+ (void)sessionDownloadWithUrl:(NSString *)urlStr success:(void (^)(NSURL *fileURL))success fail:(void (^)(void))fail{
    
    NSString *urlString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    
    //AFURLSessionManager创建并完善了一个NSURLSession的对象基于遵从NSURLSessionDelegate与NSURLSessionDataDelegate协议NSURLSessionConfigration对象。
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
    
    
    
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        // 指定下载文件保存的路径
//        NSLog(@"%@ %@", targetPath, response.suggestedFilename);
        // 将下载文件保存在缓存路径中
        NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        NSString *path = [cacheDir stringByAppendingPathComponent:response.suggestedFilename];
        
        // URLWithString返回的是网络的URL,如果使用本地URL,需要注意
        NSURL *fileURL1 = [NSURL URLWithString:path];
        NSURL *fileURL = [NSURL fileURLWithPath:path];
        
        NSLog(@"== %@ |||| %@", fileURL1, fileURL);
        if (success) {
            success(fileURL);
        }
        
        return fileURL;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"%@ %@", filePath, error);
        if (fail) {
            fail();
        }
    }];
    
    [task resume];
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
