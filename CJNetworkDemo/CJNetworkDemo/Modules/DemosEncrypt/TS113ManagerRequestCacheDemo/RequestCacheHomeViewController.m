//
//  RequestCacheHomeViewController.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2016/3/26.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "RequestCacheHomeViewController.h"
#import <CJMonitor/CJLogSuspendWindow.h>
#import <CQDemoKit/CJUIKitToastUtil.h>
#import <CQDemoKit/CJUIKitAlertUtil.h>

#import <CJNetwork/CJNetworkCacheUtil.h>
#import <CJNetwork/AFHTTPSessionManager+CJSerializerEncrypt.h>
#import "TSCleanHTTPSessionManager.h"
#import "TS113CacheResponseModel.h"

@interface RequestCacheHomeViewController ()

@property (nonatomic, strong) dispatch_queue_t commonConcurrentQueue; //创建并发队列

@end

@implementation RequestCacheHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = NSLocalizedString(@"请求Cache首页", nil);
    
    
    NSMutableArray *sectionDataModels = [[NSMutableArray alloc] init];
    
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

    self.sectionDataModels = sectionDataModels;
}

#pragma mark - 测试缓存时间
/// 测试缓存时间
- (void)testCacheTime {
    // checkTestCacheTime 检查是否可以开始测试'设置的缓存过期时间是否有效'的问题
    
    [self __testGetRequestWithIndex:0 useCache:YES success:^(TS113CacheResponseModel *responseModel) {
        [self startTestCacheTime];
        
    } failure:^(BOOL isRequestFailure, NSString *errorMessage) {
        if (isRequestFailure) {
            [CJUIKitAlertUtil showAlertInViewController:self
                                              withTitle:@"网络请求失败，无法测试'设置的缓存过期时间是否有效'的问题，请先保证网络请求成功"
                                                message:errorMessage
                                            cancleBlock:nil
                                                okBlock:nil];
        }
    }];
}



- (void)startTestCacheTime {
    [self __removeCacheForEndWithCacheIfExistApi];
    NSLog(@"缓存清除完毕，那么接下来第一次请求到的肯定是非缓存的数据，否则错误");
    
    // 创建一个组 （获得一个新的，空的调度组）
    dispatch_group_t group = dispatch_group_create();

    // 将队列关联组
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        NSLog(@"此时，在第0秒的时候开始发起第一个请求");
        [self __requestANewInSecond00:group];
    });

    // 将队列关联组
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        NSLog(@"在缓存过期10秒内，请求到的肯定是缓存的数据，否则错误");
        [self __requestANewInSecond05:group];
    });

    // 将队列关联组
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        NSLog(@"在缓存过期10秒后，请求到的肯定是非缓存的数据，否则错误");
        [self __requestANewInSecond11:group];
    });

    // 组中的队列全部执行完毕后就通知调度组
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"MainTask: %@", [NSThread currentThread]);
        [self __showResponseLogMessage:@"测试结束：测试缓存时间的功能整体结束" useAlert:YES];
    });
}

/// 在第0秒的时候开始发起第一个请求
- (void)__requestANewInSecond00:(dispatch_group_t)group {
    dispatch_group_enter(group);
    [self __testGetRequestWithIndex:0 useCache:YES success:^(TS113CacheResponseModel *responseModel) {
        if (responseModel.isCacheData == NO) {
            [self __showResponseLogMessage:@"①测试通过：第一次请求到的肯定是非缓存的数据" useAlert:NO];
        } else {
            [self __showResponseLogMessage:@"①测试不通过：第一次请求到的不是非缓存的数据" useAlert:YES];
            
        }
        dispatch_group_leave(group);
    } failure:^(BOOL isRequestFailure, NSString *errorMessage) {
        dispatch_group_leave(group);
    }];
}

/// 在第5秒的时候再发起一个请求
- (void)__requestANewInSecond05:(dispatch_group_t)group {
    dispatch_group_enter(group);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self __testGetRequestWithIndex:0 useCache:YES success:^(TS113CacheResponseModel *responseModel) {
            if (responseModel.isCacheData == YES) {
                [self __showResponseLogMessage:@"②测试通过：在缓存过期10秒内(现在是5秒)，请求到的肯定是缓存的数据" useAlert:NO];
            } else {
                [self __showResponseLogMessage:@"②测试不通过：在缓存过期10秒内(现在是5秒)，请求到的不是缓存的数据"
                                                    useAlert:YES];
            }
            dispatch_group_leave(group);
        } failure:^(BOOL isRequestFailure, NSString *errorMessage) {
            dispatch_group_leave(group);
        }];
    });
}

/// 在第11秒的时候再发起一个请求
- (void)__requestANewInSecond11:(dispatch_group_t)group {
    dispatch_group_enter(group);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(11 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self __testGetRequestWithIndex:0 useCache:YES success:^(TS113CacheResponseModel *responseModel) {
            if (responseModel.isCacheData == NO) {
                [self __showResponseLogMessage:@"③测试通过：在缓存过期10秒后(现在是11秒)，请求到的肯定是非缓存的数据" useAlert:NO];
            } else {
                [self __showResponseLogMessage:@"③测试不通过：在缓存过期10秒后(现在是11秒)，请求到的不是非缓存的数据"
                                                    useAlert:YES];
            }
            dispatch_group_leave(group);
        } failure:^(BOOL isRequestFailure, NSString *errorMessage) {
            dispatch_group_leave(group);
        }];
    });
}

#pragma mark - Private Method
/// 删除缓存
- (BOOL)__removeCacheForEndWithCacheIfExistApi {
    NSString *Url = @"https://suggest.taobao.com/sug";
    NSDictionary *params = @{
        @"code": @"utf-8",
        @"q": @"玩具车",
//        @"m_requestIndex": @(requestIndex),
    };
    
    return [CJNetworkCacheUtil removeCacheForUrl:Url params:params];
}

// 测试GET网络请求
- (void)__testGetRequestWithIndex:(NSInteger)requestIndex
                         useCache:(BOOL)useCache
                          success:(void (^)(TS113CacheResponseModel *responseModel))success
                          failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure
{
    // [淘宝宝贝名称查询GET](https://api.you-fire.com/youapi/api/detail/b5d2217f923e11e986e700163e0e0ef0)
    AFHTTPSessionManager *manager = [TSCleanHTTPSessionManager sharedInstance];
    NSString *Url = @"https://suggest.taobao.com/sug";
    NSDictionary *allParams = @{
        @"code": @"utf-8",
        @"q": @"玩具车",
//        @"m_requestIndex": @(requestIndex),
    };
    
    CJRequestCacheSettingModel *requestCacheModel = [[CJRequestCacheSettingModel alloc] init];
    if (useCache) {
        requestCacheModel.cacheStrategy = CJRequestCacheStrategyEndWithCacheIfExist;
        requestCacheModel.cacheTimeInterval = 10;
    } else {
        requestCacheModel.cacheStrategy = CJRequestCacheStrategyNoneCache;
    }
    
    [manager cj_requestUrl:Url params:allParams method:CJRequestMethodGET cacheSettingModel:requestCacheModel logType:CJRequestLogTypeSuppendWindow progress:nil success:^(CJSuccessRequestInfo * _Nullable successRequestInfo) {
        NSDictionary *responseDictionary = successRequestInfo.responseObject;
        
        TS113CacheResponseModel *responseModel = [[TS113CacheResponseModel alloc] init];
        responseModel.statusCode = [responseDictionary[@"status"] integerValue];
        responseModel.message = responseDictionary[@"message"];
        responseModel.result = responseDictionary[@"result"];
        responseModel.isCacheData = successRequestInfo.isCacheData;
        if (success) {
            success(responseModel);
        }
        
    } failure:^(CJFailureRequestInfo * _Nullable failureRequestInfo) {
        if (failure) {
            failure(failureRequestInfo.isRequestFailure, failureRequestInfo.errorMessage);
        }
    }];
}


/// 显示返回结果log
- (void)__showResponseLogMessage:(NSString *)message useAlert:(BOOL)useAlert {
    [CJLogViewWindow appendObject:message];
    NSLog(@"%@", message);
    
    if (!useAlert) {
        [CJUIKitToastUtil showMessage:message];
    } else {
        [CJUIKitAlertUtil showAlertInViewController:self
                                          withTitle:message
                                            message:nil
                                        cancleBlock:nil
                                            okBlock:nil];
    }
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
