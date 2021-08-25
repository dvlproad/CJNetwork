//
//  SemaphoreHomeViewController.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2016/3/26.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "SemaphoreHomeViewController.h"
#import <CQDemoKit/CJUIKitToastUtil.h>
#import <CQDemoKit/CJUIKitAlertUtil.h>

#import "TestConcurrenceModel.h"
#import "TestConcurrenceManager.h"
#import "TestHTTPSessionManager.h"
#import "TestNetworkClient+TestConcurrence.h"

@interface SemaphoreHomeViewController ()

@property (nonatomic, strong) dispatch_queue_t commonConcurrentQueue;   //创建并发队列
@property (nonatomic, strong) dispatch_queue_t commonSerialQueue;       //串行队列

@property (nonatomic, strong) NSLock *lock;

@end

NSInteger total = 0;

@implementation SemaphoreHomeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self threadSafe];
}



- (void)threadSafe {
    for (NSInteger index = 0; index < 3; index++) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self.lock lock];
            total += 1;
            NSLog(@"total: %ld", total);
            total -= 1;
            NSLog(@"total: %ld", total);
            [self.lock unlock];
        });
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.lock = [[NSLock alloc] init];
    
    self.navigationItem.title = NSLocalizedString(@"Semaphore首页", nil);
    
    
    NSMutableArray *sectionDataModels = [[NSMutableArray alloc] init];
    
    //异步任务的semaphore信号量使用
    {
        CQDMSectionDataModel *sectionDataModel = [[CQDMSectionDataModel alloc] init];
        sectionDataModel.theme = @"异步任务的semaphore信号量使用";
        
        {
            CQDMModuleModel *semaphoreModule = [[CQDMModuleModel alloc] init];
            semaphoreModule.title = @"异步任务的semaphore:串行队列(正常使用)";
            semaphoreModule.selector = @selector(test_semaphore_asyncTask_serialQueue_normal);
            [sectionDataModel.values addObject:semaphoreModule];
        }
        {
            CQDMModuleModel *semaphoreModule = [[CQDMModuleModel alloc] init];
            semaphoreModule.title = @"异步任务的semaphore:串行队列(特殊使用)";
            semaphoreModule.selector = @selector(test_semaphore_asyncTask_serialQueue_special);
            [sectionDataModel.values addObject:semaphoreModule];
        }
        {
            CQDMModuleModel *semaphoreModule = [[CQDMModuleModel alloc] init];
            semaphoreModule.title = @"异步任务的semaphore:并发队列(特殊使用)";
            semaphoreModule.selector = @selector(test_semaphore_asyncTask_concurrentQueue_special);
            [sectionDataModel.values addObject:semaphoreModule];
        }
        
        [sectionDataModels addObject:sectionDataModel];
    }
    
    //同步任务的semaphore信号量使用
    {
        CQDMSectionDataModel *sectionDataModel = [[CQDMSectionDataModel alloc] init];
        sectionDataModel.theme = @"同步任务的semaphore信号量使用";
        
        {
            CQDMModuleModel *semaphoreModule = [[CQDMModuleModel alloc] init];
            semaphoreModule.title = @"同步任务的semaphore:主队列";
            semaphoreModule.selector = @selector(test_semaphore_syncTask_mainQueue);
            [sectionDataModel.values addObject:semaphoreModule];
        }
        {
            CQDMModuleModel *semaphoreModule = [[CQDMModuleModel alloc] init];
            semaphoreModule.title = @"同步任务的semaphore:串行队列";
            semaphoreModule.selector = @selector(test_semaphore_syncTask_serialQueue);
            [sectionDataModel.values addObject:semaphoreModule];
        }
        {
            CQDMModuleModel *semaphoreModule = [[CQDMModuleModel alloc] init];
            semaphoreModule.title = @"同步任务的semaphore:并发队列";
            semaphoreModule.selector = @selector(test_semaphore_syncTask_concurrentQueue);
            [sectionDataModel.values addObject:semaphoreModule];
        }
        
        [sectionDataModels addObject:sectionDataModel];
    }
    
    // 测试更新Semaphore的值
    {
        CQDMSectionDataModel *sectionDataModel = [[CQDMSectionDataModel alloc] init];
        sectionDataModel.theme = @"测试更新Semaphore的值";
        {
            CQDMModuleModel *semaphoreModule = [[CQDMModuleModel alloc] init];
            semaphoreModule.title = @"同步任务的semaphore:并发队列(错误示例!)";
            semaphoreModule.selector = @selector(test_updateSemaphoreCount_wrong);
            [sectionDataModel.values addObject:semaphoreModule];
        }
        {
            CQDMModuleModel *semaphoreModule = [[CQDMModuleModel alloc] init];
            semaphoreModule.title = @"同步任务的semaphore:并发队列(错误示例修正!)";
            semaphoreModule.selector = @selector(test_updateSemaphoreCount_correct);
            [sectionDataModel.values addObject:semaphoreModule];
        }
        {
            CQDMModuleModel *semaphoreModule = [[CQDMModuleModel alloc] init];
            semaphoreModule.title = @"同步任务的semaphore:并发队列(不加锁正确吗?)";
            semaphoreModule.selector = @selector(test_updateSemaphoreCount_nolock);
            [sectionDataModel.values addObject:semaphoreModule];
        }
        [sectionDataModels addObject:sectionDataModel];
    }
    
    //model模拟网络测试并发及拦截(Concurrence&Intercept)
    {
        CQDMSectionDataModel *sectionDataModel = [[CQDMSectionDataModel alloc] init];
        sectionDataModel.theme = @"model模拟网络测试并发及拦截(Concurrence&Intercept)";
        {
            CQDMModuleModel *concurrenceModule = [[CQDMModuleModel alloc] init];
            concurrenceModule.title = @"model并发测试:设置(请一定要执行验证)";
            concurrenceModule.selector = @selector(model_testConcurrenceCount_setting);
            [sectionDataModel.values addObject:concurrenceModule];
        }
        
        {
            CQDMModuleModel *concurrenceModule = [[CQDMModuleModel alloc] init];
            concurrenceModule.title = @"model并发测试:设置+改变(请一定要执行验证)";
            concurrenceModule.selector = @selector(model_testConcurrenceCount_setting_change);
            [sectionDataModel.values addObject:concurrenceModule];
        }
        
        {
            CQDMModuleModel *concurrenceModule = [[CQDMModuleModel alloc] init];
            concurrenceModule.title = @"model并发测试:设置+改变+恢复(请一定要执行验证)";
            concurrenceModule.selector = @selector(model_testConcurrenceCount_setting_change_recover);
            [sectionDataModel.values addObject:concurrenceModule];
        }
        
        [sectionDataModels addObject:sectionDataModel];
    }
    
    //manager模拟网络测试并发及拦截(Concurrence&Intercept)
    {
        CQDMSectionDataModel *sectionDataModel = [[CQDMSectionDataModel alloc] init];
        sectionDataModel.theme = @"manager模拟网络测试并发及拦截(Concurrence&Intercept)";
        {
            CQDMModuleModel *concurrenceModule = [[CQDMModuleModel alloc] init];
            concurrenceModule.title = @"manager并发测试:设置(请一定要执行验证)";
            concurrenceModule.selector = @selector(manager_testConcurrenceCount_simulateNetwork_withoutKepper);
            [sectionDataModel.values addObject:concurrenceModule];
        }
        
        {
            CQDMModuleModel *interceptModule = [[CQDMModuleModel alloc] init];
            interceptModule.title = @"manager并发测试:设置+改变+恢复(请一定要执行验证)";
            interceptModule.selector = @selector(manager_testConcurrenceCount_simulateNetwork_withKepper);
            [sectionDataModel.values addObject:interceptModule];
        }
        
        [sectionDataModels addObject:sectionDataModel];
    }
    
    //自我服务器模拟网络并发及拦截测试(Concurrence&Intercept)
    {
        CQDMSectionDataModel *sectionDataModel = [[CQDMSectionDataModel alloc] init];
        sectionDataModel.theme = @"自我服务器模拟网络并发及拦截测试(Concurrence&Intercept)";
        
        {
            CQDMModuleModel *concurrenceModule = [[CQDMModuleModel alloc] init];
            concurrenceModule.title = @"myNetwork并发测试:设置+改变+恢复(请一定要执行验证)";
            concurrenceModule.selector = @selector(realNetwork_testConcurrenceCount_withoutKepper);
            [sectionDataModel.values addObject:concurrenceModule];
        }
        
        [sectionDataModels addObject:sectionDataModel];
    }
    
    
    self.sectionDataModels = sectionDataModels;
    
    dispatch_queue_t concurrentQueue = dispatch_queue_create("commonConcurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    self.commonConcurrentQueue = concurrentQueue;
    
    dispatch_queue_t commonSerialQueue = dispatch_queue_create("commonSerialQueue", DISPATCH_QUEUE_SERIAL);
    self.commonSerialQueue = commonSerialQueue;
}


#pragma mark - 异步任务的semaphore信号量使用
- (void)test_semaphore_asyncTask_serialQueue_normal {
    NSLog(@"----------------------");
    NSLog(@"常见的信号量使用，任务是<异步>的，初始值0");
    //dispatch_queue_t serialQueue = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t serialQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_semaphore_t concurrentSemaphore = dispatch_semaphore_create(0);//这里是0
    
    dispatch_async(serialQueue, ^{
        NSLog(@"1.asyncTask_serialQueue_normal...doing");
        dispatch_semaphore_signal(concurrentSemaphore);
        NSLog(@"1.asyncTask_serialQueue_normal...finish");
    });
    dispatch_semaphore_wait(concurrentSemaphore, DISPATCH_TIME_FOREVER);
    
    dispatch_async(serialQueue, ^{
        NSLog(@"2.asyncTask_serialQueue_normal...doing");
        dispatch_semaphore_signal(concurrentSemaphore);
        NSLog(@"2.asyncTask_serialQueue_normal...finish");
    });
    dispatch_semaphore_wait(concurrentSemaphore, DISPATCH_TIME_FOREVER);
}

- (void)test_semaphore_asyncTask_serialQueue_special {
    NSLog(@"----------------------");
    NSLog(@"常见的信号量使用，任务是<异步>的，初始值1");
    //dispatch_queue_t serialQueue = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t serialQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_semaphore_t concurrentSemaphore = dispatch_semaphore_create(1);//这里是1
    
    dispatch_semaphore_wait(concurrentSemaphore, DISPATCH_TIME_FOREVER);
    dispatch_async(serialQueue, ^{
        NSLog(@"1.asyncTask_serialQueue_special...doing");
        dispatch_semaphore_signal(concurrentSemaphore);
        NSLog(@"1.asyncTask_serialQueue_special...finish");
    });
    
    dispatch_semaphore_wait(concurrentSemaphore, DISPATCH_TIME_FOREVER);
    dispatch_async(serialQueue, ^{
        NSLog(@"2.asyncTask_serialQueue_special...doing");
        dispatch_semaphore_signal(concurrentSemaphore);
        NSLog(@"2.asyncTask_serialQueue_special...finish");
    });
}

- (void)test_semaphore_asyncTask_concurrentQueue_special {
    NSLog(@"----------------------");
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_semaphore_t concurrentSemaphore = dispatch_semaphore_create(1);//这里是1
    
    dispatch_semaphore_wait(concurrentSemaphore, DISPATCH_TIME_FOREVER);
    dispatch_async(concurrentQueue, ^{
        NSLog(@"1.asyncTask_concurrentQueue_special...doing");
        dispatch_semaphore_signal(concurrentSemaphore);
        NSLog(@"1.asyncTask_concurrentQueue_special...finish");
    });
    
    dispatch_semaphore_wait(concurrentSemaphore, DISPATCH_TIME_FOREVER);
    dispatch_async(concurrentQueue, ^{
        NSLog(@"2.asyncTask_concurrentQueue_special...doing");
        dispatch_semaphore_signal(concurrentSemaphore);
        NSLog(@"2.asyncTask_concurrentQueue_special...finish");
    });
}


#pragma mark - 测试更新Semaphore的值
- (void)test_updateSemaphoreCount_correct {
    NSLog(@"----------------------");
    //dispatch_queue_t serialQueue2 = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t concurrentQueue2 = dispatch_queue_create("concurrentQueue2", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_semaphore_t updateCountSemaphore = dispatch_semaphore_create(1);
    dispatch_semaphore_t concurrentSemaphore = dispatch_semaphore_create(0);
    __block NSInteger concurrentCount = 0;
    
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    for (NSInteger i = 0; i < 5; i++) {
        dispatch_async(concurrentQueue2, ^(void) { //这边是串行或者是并行队列都无可以
            dispatch_semaphore_wait(updateCountSemaphore, DISPATCH_TIME_FOREVER);   //新位置，保证update的准确性
            dispatch_async(concurrentQueue, ^{
                NSLog(@"%ld.asyncTask_concurrentQueue...doing", i);
                //dispatch_semaphore_wait(updateCountSemaphore, DISPATCH_TIME_FOREVER); //原本位置
                dispatch_semaphore_signal(concurrentSemaphore);
                dispatch_semaphore_signal(updateCountSemaphore);
                concurrentCount++;
                NSLog(@"%ld.asyncTask_concurrentQueue...finish", i);
            });
            dispatch_semaphore_wait(updateCountSemaphore, DISPATCH_TIME_FOREVER);
            
            dispatch_semaphore_wait(concurrentSemaphore, DISPATCH_TIME_FOREVER);
            concurrentCount--;
            dispatch_semaphore_signal(updateCountSemaphore);
        });
    }
}

- (void)test_updateSemaphoreCount_nolock {
    NSLog(@"----------------------");
    //dispatch_queue_t serialQueue2 = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t concurrentQueue2 = dispatch_queue_create("concurrentQueue2", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_semaphore_t concurrentSemaphore = dispatch_semaphore_create(0);
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    for (NSInteger i = 0; i < 5; i++) {
        dispatch_async(concurrentQueue2, ^(void) { //这边是串行或者是并行队列都无可以
            dispatch_async(concurrentQueue, ^{
                NSLog(@"%ld.asyncTask_concurrentQueue...doing", i);
                sleep(2);
                dispatch_semaphore_signal(concurrentSemaphore);
                NSLog(@"%ld.asyncTask_concurrentQueue...finish", i);
            });
            dispatch_semaphore_wait(concurrentSemaphore, DISPATCH_TIME_FOREVER);
        });
    }
}

- (void)test_updateSemaphoreCount_wrong {
    NSLog(@"----------------------");
    //dispatch_queue_t serialQueue2 = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t concurrentQueue2 = dispatch_queue_create("concurrentQueue2", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_semaphore_t updateCountSemaphore = dispatch_semaphore_create(1);
    dispatch_semaphore_t concurrentSemaphore = dispatch_semaphore_create(0);
    __block NSInteger concurrentCount = 0;
    
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    for (NSInteger i = 0; i < 5; i++) {
        dispatch_async(concurrentQueue2, ^(void) {  //这边是串行或者是并行队列都不可以
            dispatch_async(concurrentQueue, ^{
                NSLog(@"%ld.asyncTask_concurrentQueue...doing", i);
                dispatch_semaphore_wait(updateCountSemaphore, DISPATCH_TIME_FOREVER);
                dispatch_semaphore_signal(concurrentSemaphore);
                concurrentCount++;
                dispatch_semaphore_signal(updateCountSemaphore);
                NSLog(@"%ld.asyncTask_concurrentQueue...finish", i);
            });
            dispatch_semaphore_wait(updateCountSemaphore, DISPATCH_TIME_FOREVER);
            dispatch_semaphore_wait(concurrentSemaphore, DISPATCH_TIME_FOREVER);
            concurrentCount--;
            dispatch_semaphore_signal(updateCountSemaphore);
        });
    }
}

#pragma mark - 同步任务的semaphore信号量使用
- (void)test_semaphore_syncTask_mainQueue {
    NSLog(@"----------------------");
    NSLog(@"不常见的信号量使用，任务是<同步>的，初始值1");
    dispatch_semaphore_t concurrentSemaphore = dispatch_semaphore_create(1);//这里是1
    
    dispatch_semaphore_wait(concurrentSemaphore, DISPATCH_TIME_FOREVER);
    NSLog(@"1.syncTask_mainQueue...doing");
    dispatch_semaphore_signal(concurrentSemaphore);
    NSLog(@"1.syncTask_mainQueue...finish");
    
    dispatch_semaphore_wait(concurrentSemaphore, DISPATCH_TIME_FOREVER);
    NSLog(@"2.syncTask_mainQueue...doing");
    dispatch_semaphore_signal(concurrentSemaphore);
    NSLog(@"2.syncTask_mainQueue...finish");
}

- (void)test_semaphore_syncTask_serialQueue {
    NSLog(@"----------------------");
    dispatch_semaphore_t concurrentSemaphore = dispatch_semaphore_create(1);
    dispatch_queue_t serialQueue = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(serialQueue, ^{
        for (NSInteger i = 0; i < 5; i++) {
            dispatch_semaphore_wait(concurrentSemaphore, DISPATCH_TIME_FOREVER);
            NSLog(@"%ld.syncTask_serialQueue...doing", i);
            dispatch_semaphore_signal(concurrentSemaphore);
            NSLog(@"%ld.syncTask_serialQueue...finish", i);
        }
    });
}

- (void)test_semaphore_syncTask_concurrentQueue {
    NSLog(@"----------------------");
    dispatch_semaphore_t concurrentSemaphore = dispatch_semaphore_create(1);
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    
//    dispatch_async(concurrentQueue, ^{
//        for (NSInteger i = 0; i < 5; i++) {
//            dispatch_semaphore_wait(concurrentSemaphore, DISPATCH_TIME_FOREVER);
//            NSLog(@"%ld.syncTask_concurrentQueue...doing", i);
//            dispatch_semaphore_signal(concurrentSemaphore);
//        }
//    });
    
    for (NSInteger i = 0; i < 5; i++) {
        dispatch_async(concurrentQueue, ^{
            dispatch_semaphore_wait(concurrentSemaphore, DISPATCH_TIME_FOREVER);
            NSLog(@"%ld.syncTask_concurrentQueue...doing", i);
            dispatch_semaphore_signal(concurrentSemaphore);
            NSLog(@"%ld.syncTask_concurrentQueue...finish", i);
        });
    }
}


#pragma mark - model模拟网络测试并发及拦截(Concurrence&Intercept)
- (void)model_testConcurrenceCount_setting {
    TestConcurrenceModel *manager = [[TestConcurrenceModel alloc] init];
    [manager allowMaxConcurrenceCount:4];
    
    for (NSInteger i = 0; i < 20; i++) {
        [manager runModelWithIndex:i];
    }
}

- (void)model_testConcurrenceCount_setting_change2 {
    TestConcurrenceModel *manager = [[TestConcurrenceModel alloc] init];
    [manager allowMaxConcurrenceCount:4];
    
    dispatch_queue_t concurrentQueue1 = dispatch_queue_create("model.testAddMinusConcurrenceCount.queue1", DISPATCH_QUEUE_CONCURRENT); //创建并发队列
    dispatch_async(concurrentQueue1, ^{
        dispatch_queue_t concurrentQueue2 = dispatch_queue_create("model.testAddMinusConcurrenceCount.queue2", DISPATCH_QUEUE_CONCURRENT); //创建并发队列
        
        //模拟的第一个操作
        dispatch_async(concurrentQueue2, ^{
            sleep(2);
            //            [self __addOneConcurrenceCount];
            NSLog(@"模拟的第一个操作结束");
        });
        //        [self __minusOneConcurrenceCount];
        
        // 模拟的第二个操作
        dispatch_async(concurrentQueue2, ^{
            sleep(2);
            //            [self __addOneConcurrenceCount];
            NSLog(@"模拟的第二个操作结束");
        });
        //        [self __minusOneConcurrenceCount];
    });
    
}

- (void)model_testConcurrenceCount_setting_change {
    TestConcurrenceModel *manager = [[TestConcurrenceModel alloc] init];
    [manager allowMaxConcurrenceCount:4];
    
    //dispatch_queue_t commonSerialQueue = dispatch_queue_create("commonSerialQueue", DISPATCH_QUEUE_SERIAL); //创建串行队列
    dispatch_queue_t commonConcurrentQueue = dispatch_queue_create("commonConcurrentQueue", DISPATCH_QUEUE_CONCURRENT); //创建并发队列
    self.commonConcurrentQueue = commonConcurrentQueue;
    for (NSInteger i = 0; i < 10; i++) { //为什么并行队列时候，大于最大并发量为什么会有问题
        dispatch_async(self.commonConcurrentQueue, ^{ //为什么用并行队列会有问题？？？？？？？
            [manager runModelWithIndex:i];
        });
    }
    
    //    [NSThread detachNewThreadWithBlock:^{
    //        NSLog(@"通道改为1");
    //        [manager __changeConcurrenceCountTo:1];
    //        sleep(10);
    //    }];
    //*/
}

- (void)model_testConcurrenceCount_setting_change_recover {
    [self model_testConcurrenceCount_simulateNetwork_withKepper:YES];
}

- (void)model_testConcurrenceCount_simulateNetwork_withKepper:(BOOL)withKeepr {
    TestConcurrenceModel *manager = [[TestConcurrenceModel alloc] init];
    [manager allowMaxConcurrenceCount:4];
    
    dispatch_queue_t concurrentQueue = dispatch_queue_create("model.testConcurrenceCount.queue", DISPATCH_QUEUE_CONCURRENT); //创建并发队列
    dispatch_async(concurrentQueue, ^{
        for (NSInteger i = 0; i < 10; i++) {
            [manager runModelWithIndex:i];
        }
        
        if (withKeepr) {
            [manager runModelWithKeeper];
        }
    });
    
    //    for (NSInteger i = 0; i < 10; i++) {
    //        [manager runModelWithIndex:i];
    //    }
    //
    //    if (withKeepr) {
    //        [manager runModelWithKeeper];
    //    }
}

#pragma mark - manager模拟网络测试并发及拦截(Concurrence&Intercept)
- (void)manager_testConcurrenceCount_simulateNetwork_withoutKepper {
    TestConcurrenceManager *manager = [TestConcurrenceManager manager];
    [manager allowMaxConcurrenceCount:4];
    
    for (NSInteger i = 0; i < 20; i++) {
        [manager runModelWithIndex:i];
    }
}

- (void)manager_testConcurrenceCount_simulateNetwork_withKepper {
    [self manager_testConcurrenceCount_simulateNetwork_withKepper:YES];
}

- (void)manager_testConcurrenceCount_simulateNetwork_withKepper:(BOOL)withKeepr {
    TestConcurrenceManager *manager = [TestConcurrenceManager manager];
    [manager allowMaxConcurrenceCount:4];
    
    for (NSInteger i = 0; i < 20; i++) {
        [manager runModelWithIndex:i];
    }
    
    //    if (withKeepr) {
    //        [manager runModelWithKeeper];
    //    }
}


#pragma mark - 真正网络并发测试(Concurrence)
- (void)realNetwork_testConcurrenceCount_withoutKepper {
    [[TestNetworkClient sharedInstance] testConcurrenceCountApiIndex:1 success:^(CJResponseModel *responseModel) {
        [self startTestConcurrenceCount];
    } failure:^(BOOL isRequestFailure, NSString *errorMessage) {
        if (isRequestFailure) {
            [CJUIKitAlertUtil showCancleOKAlertInViewController:self
                                              withTitle:@"网络请求失败，无法测试'网络相关'的问题，请先保证网络请求成功"
                                                message:errorMessage
                                            cancleBlock:nil
                                                okBlock:nil];
        }
    }];
}

- (void)startTestConcurrenceCount {
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [CJUIKitToastUtil showMessage:@"开始测试并发数设置"];
        });
    } else {
        [CJUIKitToastUtil showMessage:@"开始测试并发数设置"];
    }
    
    
    [TestHTTPSessionManager sharedInstance].completionQueue = dispatch_queue_create("realNetwork.testConcurrenceCount.queue", DISPATCH_QUEUE_CONCURRENT); //如果没设置成并发队列就不能测试
    [[TestHTTPSessionManager sharedInstance] allowMaxConcurrenceCount:3];
    
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
