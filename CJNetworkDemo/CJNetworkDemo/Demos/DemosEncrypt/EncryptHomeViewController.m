//
//  EncryptHomeViewController.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2016/3/26.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "EncryptHomeViewController.h"

#import "TestNetworkClient+Test.h"
#import "TestHTTPSessionManager.h"


#import "HealthyNetworkClient.h"
#import "HealthyHTTPSessionManager.h"

#import "TestConcurrenceModel.h"
#import "TestConcurrenceManager.h"

@interface EncryptHomeViewController ()

@end

@implementation EncryptHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = NSLocalizedString(@"Encrypt首页", nil);
    
    
    NSMutableArray *sectionDataModels = [[NSMutableArray alloc] init];
    
    //网络缓存时间相关(Cache)
    {
        CJSectionDataModel *sectionDataModel = [[CJSectionDataModel alloc] init];
        sectionDataModel.theme = @"网络能否请求相关(Just Request)";
        
        {
            CJModuleModel *loginModule = [[CJModuleModel alloc] init];
            loginModule.title = @"登录(健康)";
            loginModule.selector = @selector(testLoginHealth);
            [sectionDataModel.values addObject:loginModule];
        }
        
        [sectionDataModels addObject:sectionDataModel];
    }
    
    //网络缓存时间相关(Cache)
    {
        CJSectionDataModel *sectionDataModel = [[CJSectionDataModel alloc] init];
        sectionDataModel.theme = @"网络缓存时间相关(Cache)";
        
        {
            CJModuleModel *loginModule = [[CJModuleModel alloc] init];
            loginModule.title = @"测试缓存时间(请一定要执行验证)";
            loginModule.selector = @selector(testCacheTime);
            [sectionDataModel.values addObject:loginModule];
        }
        
        [sectionDataModels addObject:sectionDataModel];
    }
    
    //网络并发相关(Concurrence)
    {
        CJSectionDataModel *sectionDataModel = [[CJSectionDataModel alloc] init];
        sectionDataModel.theme = @"网络并发相关(Concurrence)";
        {
            CJModuleModel *loginModule = [[CJModuleModel alloc] init];
            loginModule.title = @"正确的测试并发数设置(非网络)";
            loginModule.selector = @selector(testConcurrenceCount_correct);
            [sectionDataModel.values addObject:loginModule];
        }
        {
            CJModuleModel *loginModule = [[CJModuleModel alloc] init];
            loginModule.title = @"错误的测试并发数设置(非网络)";
            loginModule.selector = @selector(testConcurrenceCount_wrong);
            [sectionDataModel.values addObject:loginModule];
        }
        
        {
            CJModuleModel *loginModule = [[CJModuleModel alloc] init];
            loginModule.title = @"模拟测试网络并发数设置(请一定要执行验证)";
            loginModule.selector = @selector(testConcurrenceCount_simulateNetwork);
            [sectionDataModel.values addObject:loginModule];
        }
        
        {
            CJModuleModel *loginModule = [[CJModuleModel alloc] init];
            loginModule.title = @"模拟测试网络并发数设置(含拦截)(请一定要执行验证)";
            loginModule.selector = @selector(testConcurrenceCount_simulateNetworkWithUrl);
            [sectionDataModel.values addObject:loginModule];
        }
        
        {
            CJModuleModel *loginModule = [[CJModuleModel alloc] init];
            loginModule.title = @"测试网络并发数设置(请一定要执行验证)";
            loginModule.selector = @selector(testConcurrenceCount);
            [sectionDataModel.values addObject:loginModule];
        }
        
        [sectionDataModels addObject:sectionDataModel];
    }
    
    
    self.sectionDataModels = sectionDataModels;
}

#pragma mark - 测试缓存时间
/// 测试缓存时间
- (void)testCacheTime {
    // checkTestCacheTime 检查是否可以开始测试'设置的缓存过期时间是否有效'的问题
    [[TestNetworkClient sharedInstance] testCacheWithShouldRemoveCache:YES success:^(CJResponseModel *responseModel) {
        [self startTestCacheTime];
    } failure:^(BOOL isRequestFailure, NSString *errorMessage) {
        if (isRequestFailure) {
            [CJAlert showIKnowWithTitle:@"网络请求失败，无法测试'设置的缓存过期时间是否有效'的问题，请先保证网络请求成功" message:errorMessage okHandle:nil];
        }
    }];
}

- (void)startTestCacheTime {
    NSLog(@"第一次请求到的肯定是非缓存的数据，否则错误");
    [[TestNetworkClient sharedInstance] testCacheWithShouldRemoveCache:YES success:^(CJResponseModel *responseModel) {
        if (responseModel.isCacheData == NO) {
            [CJToast shortShowMessage:@"①测试通过：第一次请求到的肯定是非缓存的数据"];
        } else {
            [DemoAlert showIKnowAlertViewWithTitle:@"①测试不通过：第一次请求到的不是非缓存的数据"];
        }
    } failure:nil];
    
    NSLog(@"在缓存过期10秒内，请求到的肯定是缓存的数据，否则错误");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[TestNetworkClient sharedInstance] testCacheWithShouldRemoveCache:NO success:^(CJResponseModel *responseModel) {
            if (responseModel.isCacheData == YES) {
                [CJToast shortShowMessage:@"②测试通过：在缓存过期10秒内(现在是5秒)，请求到的肯定是缓存的数据"];
            } else {
                [DemoAlert showIKnowAlertViewWithTitle:@"②测试不通过：在缓存过期10秒内(现在是5秒)，请求到的不是缓存的数据"];
            }
        } failure:nil];
    });
    
    NSLog(@"在缓存过期10秒后，请求到的肯定是非缓存的数据，否则错误");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(11 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[TestNetworkClient sharedInstance] testCacheWithShouldRemoveCache:NO success:^(CJResponseModel *responseModel) {
            if (responseModel.isCacheData == NO) {
                [CJToast shortShowMessage:@"③测试通过：在缓存过期10秒后(现在是11秒)，请求到的肯定是非缓存的数据"];
                [DemoAlert showIKnowAlertViewWithTitle:@"测试缓存时间通过"];
            } else {
                [DemoAlert showIKnowAlertViewWithTitle:@"③测试不通过：在缓存过期10秒后(现在是11秒)，请求到的不是非缓存的数据"];
            }
        } failure:nil];
    });
}

#pragma mark - 测试并发数设置
- (void)testConcurrenceCount {
    [[TestNetworkClient sharedInstance] testConcurrenceCountApiIndex:1 success:^(CJResponseModel *responseModel) {
        [self startTestConcurrenceCount];
    } failure:^(BOOL isRequestFailure, NSString *errorMessage) {
        if (isRequestFailure) {
            [CJAlert showIKnowWithTitle:@"网络请求失败，无法测试'网络相关'的问题，请先保证网络请求成功" message:errorMessage okHandle:nil];
        }
    }];
}

- (void)startTestConcurrenceCount {
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [CJToast shortShowMessage:@"开始测试并发数设置"];
        });
    } else {
        [CJToast shortShowMessage:@"开始测试并发数设置"];
    }
    
    
    [TestHTTPSessionManager sharedInstance].completionQueue = dispatch_queue_create("cn.testConcurrenceCount.queue", DISPATCH_QUEUE_CONCURRENT); //如果没设置成并发队列就不能测试
    [[TestHTTPSessionManager sharedInstance] allowConcurrenceCount:3];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSInteger i = 0; i < 4; i++) {
            for (NSInteger apiIndex = 1; apiIndex <= 5; apiIndex++) {
                NSString *requestString = [NSString stringWithFormat:@"请求%ld(%ldx5+%ld)", i * 5 + apiIndex, i, apiIndex];
                NSLog(@"开始%@", requestString);
                [[TestNetworkClient sharedInstance] testConcurrenceCountApiIndex:apiIndex success:^(CJResponseModel *responseModel) {
                    NSLog(@"完成%@:%@", requestString, [NSThread currentThread]);
                } failure:^(BOOL isRequestFailure, NSString *errorMessage) {
                    NSLog(@"完成%@:%@", requestString, [NSThread currentThread]);
                }];
            }
        }
    });
}

- (void)testConcurrenceCount_correct {
    // 创建一个控制线程同步的信号量，初始值为4(红灯)
    dispatch_semaphore_t syncSemaphore = dispatch_semaphore_create(4); //可通过4+1=5个
    
    for (NSInteger i = 0; i < 30; i++) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            sleep(5);
            NSLog(@"完成任务%ld", i);
            // 使信号的信号量+1，这里的信号量本来为0，+1信号量为1(绿灯)
            dispatch_semaphore_signal(syncSemaphore);
        });
        
        // 开启信号等待，设置等待时间为永久，直到信号的信号量大于等于1（绿灯）
        dispatch_semaphore_wait(syncSemaphore, DISPATCH_TIME_FOREVER);
    }
}



- (void)testConcurrenceCount_wrong {
    // 创建一个控制线程同步的信号量，初始值为4(红灯)
    dispatch_semaphore_t syncSemaphore = dispatch_semaphore_create(4); //可通过4+1=5个
    
    for (NSInteger i = 0; i < 30; i++) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                sleep(5); //不要在主线程sleep
                NSLog(@"完成任务%ld", i);
            });
            
            // 使信号的信号量+1，这里的信号量本来为0，+1信号量为1(绿灯)
            dispatch_semaphore_signal(syncSemaphore);
        });
        
        // 开启信号等待，设置等待时间为永久，直到信号的信号量大于等于1（绿灯）
        dispatch_semaphore_wait(syncSemaphore, DISPATCH_TIME_FOREVER);
    }
}

- (void)testConcurrenceCount_simulateNetwork {
    TestConcurrenceModel *manager = [[TestConcurrenceModel alloc] init];
    [manager allowConcurrenceCount:4];
    
    for (NSInteger i = 0; i < 20; i++) {
        [manager runModelWithIndex:i];
    }
}

- (void)testConcurrenceCount_simulateNetworkWithUrl {
    TestConcurrenceManager *manager = [TestConcurrenceManager manager];
    [manager allowConcurrenceCount:4];
    
    for (NSInteger i = 0; i < 20; i++) {
        [manager runModelWithIndex:i];
    }
}


#pragma mark - 测试登录健康

- (void)testLoginHealth {
    [self loginHealthWithCompleteBlock:^(CJResponseModel *responseModel) {
        if (responseModel.status == 0) {
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"登录成功", nil)];
            if (responseModel.cjNetworkLog) {
                [CJAlert showDebugViewWithTitle:@"登录提醒" message:responseModel.cjNetworkLog];
                [CJLogViewWindow appendObject:responseModel.cjNetworkLog];
            }
            
        } else {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"登录失败", nil)];
            
            [CJLogViewWindow appendObject:@"加密页面的健康登录失败"];
            if (responseModel.cjNetworkLog) {
                [CJAlert showDebugViewWithTitle:@"登录提醒" message:responseModel.cjNetworkLog];
                [CJLogViewWindow appendObject:responseModel.cjNetworkLog];
            }
        }
    }];
}

- (void)loginHealthWithCompleteBlock:(void (^)(CJResponseModel *responseModel))completeBlock {
    NSString *apiName = @"http://121.40.82.169/drupal/api/login";
    NSDictionary *params = @{@"username" : @"test",
                             @"password" : @"test",
                             };
    /*
    AFHTTPSessionManager *manager = [HealthyHTTPSessionManager sharedInstance];
    [manager cj_postUrl:UITrackingRunLoopMode params:params settingModel:nil success:^(CJSuccessRequestInfo * _Nullable successRequestInfo) {
        <#code#>
    } failure:^(CJFailureRequestInfo * _Nullable failureRequestInfo) {
        <#code#>
    }];
    */
    [[HealthyNetworkClient sharedInstance] health_postApi:apiName params:params encrypt:YES success:^(HealthResponseModel *responseModel) {
        if (completeBlock) {
            completeBlock(responseModel);
        }
        
    } failure:^(NSError * _Nullable error) {
        CJResponseModel *responseModel = [[CJResponseModel alloc] init];
        responseModel.status = -1;
        responseModel.message = NSLocalizedString(@"网络请求失败", nil);
        responseModel.result = nil;
        responseModel.cjNetworkLog = error.userInfo[@"cjNetworkLog"];
        if (completeBlock) {
            completeBlock(responseModel);
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
