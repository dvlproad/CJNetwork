//
//  CQVideoAnalyzeMainViewController.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2017/2/25.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "CQVideoAnalyzeMainViewController.h"
#import "CJLogSuspendWindow.h"

#import "TSDownloadInputViewController.h"
#import "TSDownloadCollectionViewController.h"
#import "TSPlayerInputViewController.h"
#import "CQDownloadSettingViewController.h"

@interface CQVideoAnalyzeMainViewController ()

@end

@implementation CQVideoAnalyzeMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupViews];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.selectedIndex = 0;
        
        [CJLogSuspendWindow removeFromScreen];
    });
}

- (void)setupViews {
    self.tabBar.backgroundImage = [UIImage imageNamed:@"tabbar_BG"];
    
    /*
    知识点(UITabBarController):
    ①设置标题tabBarItem.title：为了使得tabBarItem中的title可以和显示在顶部的navigationItem的title保持各自，分别设置.tabBarItem.title和.navigationItem的title的值
    ②设置图片tabBarItem.image：会默认去掉图片的颜色，如果要看到原图片，需要设置图片的渲染模式为UIImageRenderingModeAlwaysOriginal
    ③设置角标tabBarItem.badgeValue：如果没有设置图片，角标默认显示在左上角，设置了图片就会在图片的右上角显示
    */
    TSDownloadInputViewController *homeViewController = [[TSDownloadInputViewController alloc] init];
    homeViewController.navigationItem.title = NSLocalizedString(@"解析输入", nil);
    homeViewController.tabBarItem.title = NSLocalizedString(@"解析输入", nil);
    homeViewController.tabBarItem.image = [[UIImage imageNamed:@"icons8-home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //homeViewController. = @"10";
    UINavigationController *homeNavigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    [self addChildViewController:homeNavigationController];
    
    
    TSDownloadCollectionViewController *scrollViewHomeViewController = [[TSDownloadCollectionViewController alloc] init];
    scrollViewHomeViewController.navigationItem.title = NSLocalizedString(@"已解析", nil);
    scrollViewHomeViewController.tabBarItem.title = NSLocalizedString(@"已解析", nil);
    scrollViewHomeViewController.tabBarItem.image = [[UIImage imageNamed:@"icons8-calendar"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController *scrollViewHomeNavigationController = [[UINavigationController alloc] initWithRootViewController:scrollViewHomeViewController];
    [self addChildViewController:scrollViewHomeNavigationController];
    
    TSPlayerInputViewController *playerInputViewController = [[TSPlayerInputViewController alloc] init];
    playerInputViewController.view.backgroundColor = [UIColor whiteColor];
    playerInputViewController.navigationItem.title = NSLocalizedString(@"播放器", nil);
    playerInputViewController.tabBarItem.title = NSLocalizedString(@"播放器", nil);
    playerInputViewController.tabBarItem.image = [[UIImage imageNamed:@"icons8-folder"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController *navigationController3 = [[UINavigationController alloc] initWithRootViewController:playerInputViewController];
    [self addChildViewController:navigationController3];
    
    CQDownloadSettingViewController *viewController6 = [[CQDownloadSettingViewController alloc] init];
    viewController6.view.backgroundColor = [UIColor whiteColor];
    viewController6.navigationItem.title = NSLocalizedString(@"更多", nil);
    viewController6.tabBarItem.title = NSLocalizedString(@"更多", nil);
    viewController6.tabBarItem.image = [[UIImage imageNamed:@"icons8-settings"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController *navigationController6 = [[UINavigationController alloc] initWithRootViewController:viewController6];
    [self addChildViewController:navigationController6];
    
//    [self setViewControllers:@[firstNavigationController, secondNavigationController, navigationController3, navigationController4] animated:YES];
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
