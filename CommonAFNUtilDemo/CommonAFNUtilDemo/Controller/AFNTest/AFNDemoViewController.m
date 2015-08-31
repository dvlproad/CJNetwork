//
//  AFNDemoViewController.m
//  Lee
//
//  Created by lichq on 6/3/15.
//  Copyright (c) 2015 lichq. All rights reserved.
//

#import "AFNDemoViewController.h"
#import <AFNetworking/UIActivityIndicatorView+AFNetworking.h>   //UIActivityIndicatorView
#import <AFNetworking/UIImageView+AFNetworking.h>               //UIImage

@interface AFNDemoViewController ()

@end

@implementation AFNDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}



//具体参照 AFNetworking2.5使用：http://blog.csdn.net/daiyelang/article/details/38434023
- (IBAction)testAFNetworking:(id)sender{
    //下面代码放到ViewDidload里就会出现错误，为什么？
    NSLog(@"testAFNetworking...");
    
    NSString *Url = API_BASE_Url_LookHouse(@"head/loadAd");
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestOperation *operation = [CommonAFNUtil useManager:manager getRequestUrl:Url params:nil delegate:self tag:0];
    
    //网络请求时候的动画添加
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] init];
    indicatorView.frame = CGRectMake(100, 200, 100, 100);/*calculate frame here*/
    [self.view addSubview:indicatorView];
    [indicatorView setAnimatingWithStateOfOperation:operation];
}

- (void)onRequestSuccess:(AFHTTPRequestOperation *)operation tag:(NSInteger)tag responseObject:(id)responseObject{
    NSLog(@"获取数据成功");
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

+ (void)sessionDownloadWithUrl:(NSString *)urlStr success:(void (^)(NSURL *fileURL))success fail:(void (^)())fail{
    
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


//文件上传－自定义上传文件名
+ (void)postUploadWithUrl:(NSString *)urlStr fileUrl:(NSURL *)fileURL fileName:(NSString *)fileName fileType:(NSString *)fileTye success:(void (^)(id responseObject))success fail:(void (^)())fail
{
    // 本地上传给服务器时,没有确定的URL,不好用MD5的方式处理
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //@"http://localhost/demo/upload.php"
    [manager POST:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        //        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"头像1.png" withExtension:nil];
        
        // 要上传保存在服务器中的名称
        // 使用时间来作为文件名 2014-04-30 14:20:57.png
        // 让不同的用户信息,保存在不同目录中
        //        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        //        // 设置日期格式
        //        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        //        NSString *fileName = [formatter stringFromDate:[NSDate date]];
        
        //@"image/png"
        [formData appendPartWithFileURL:fileURL name:@"uploadFile" fileName:fileName mimeType:fileTye error:NULL];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail();
        }
    }];
}



//文件上传－随机生成文件名
+ (void)postUploadWithUrl:(NSString *)urlStr fileUrl:(NSURL *)fileURL success:(void (^)(id responseObject))success fail:(void (^)())fail
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // AFHTTPResponseSerializer就是正常的HTTP请求响应结果:NSData
    // 当请求的返回数据不是JSON,XML,PList,UIImage之外,使用AFHTTPResponseSerializer
    // 例如返回一个html,text...
    //
    // 实际上就是AFN没有对响应数据做任何处理的情况
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // formData是遵守了AFMultipartFormData的对象
    [manager POST:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // 将本地的文件上传至服务器
        //        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"头像1.png" withExtension:nil];
        
        [formData appendPartWithFileURL:fileURL name:@"uploadFile" error:NULL];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //
        //        NSLog(@"完成 %@", result);
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"错误 %@", error.localizedDescription);
        if (fail) {
            fail();
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
