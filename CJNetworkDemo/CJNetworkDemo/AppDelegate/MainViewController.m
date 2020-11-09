//
//  MainViewController.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2017/2/25.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "MainViewController.h"

#import "EncryptHomeViewController.h"
#import "UploadHomeViewController.h"
#import "SemaphoreHomeViewController.h"
#import "SocketHomeViewController.h"
#import "DownloadHomeViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupViews];
}

- (void)setupViews {
    self.tabBar.backgroundImage = [UIImage imageNamed:@"tabbar_BG"];
    
    /*
    知识点(UITabBarController):
    ①设置标题tabBarItem.title：为了使得tabBarItem中的title可以和显示在顶部的navigationItem的title保持各自，分别设置.tabBarItem.title和.navigationItem的title的值
    ②设置图片tabBarItem.image：会默认去掉图片的颜色，如果要看到原图片，需要设置图片的渲染模式为UIImageRenderingModeAlwaysOriginal
    ③设置角标tabBarItem.badgeValue：如果没有设置图片，角标默认显示在左上角，设置了图片就会在图片的右上角显示
    */
    EncryptHomeViewController *homeViewController = [[EncryptHomeViewController alloc] init];
    homeViewController.navigationItem.title = NSLocalizedString(@"Encrypt首页", nil);
    homeViewController.tabBarItem.title = NSLocalizedString(@"Encrypt", nil);
    homeViewController.tabBarItem.image = [[UIImage imageNamed:@"icons8-home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //homeViewController. = @"10";
    UINavigationController *homeNavigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    [self addChildViewController:homeNavigationController];
    
    
    UploadHomeViewController *scrollViewHomeViewController = [[UploadHomeViewController alloc] init];
    scrollViewHomeViewController.navigationItem.title = NSLocalizedString(@"Upload首页", nil);
    scrollViewHomeViewController.tabBarItem.title = NSLocalizedString(@"Upload", nil);
    scrollViewHomeViewController.tabBarItem.image = [[UIImage imageNamed:@"icons8-calendar"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController *scrollViewHomeNavigationController = [[UINavigationController alloc] initWithRootViewController:scrollViewHomeViewController];
    [self addChildViewController:scrollViewHomeNavigationController];
    
    
    SemaphoreHomeViewController *viewController4 = [[SemaphoreHomeViewController alloc] init];
    viewController4.view.backgroundColor = [UIColor whiteColor];
    viewController4.navigationItem.title = NSLocalizedString(@"Semaphore首页", nil);
    viewController4.tabBarItem.title = NSLocalizedString(@"Semaphore", nil);
    viewController4.tabBarItem.image = [[UIImage imageNamed:@"icons8-settings"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController *navigationController4 = [[UINavigationController alloc] initWithRootViewController:viewController4];
    [self addChildViewController:navigationController4];
    
    SocketHomeViewController *viewController5 = [[SocketHomeViewController alloc] init];
    viewController5.view.backgroundColor = [UIColor whiteColor];
    viewController5.navigationItem.title = NSLocalizedString(@"Socket首页", nil);
    viewController5.tabBarItem.title = NSLocalizedString(@"Socket", nil);
    viewController5.tabBarItem.image = [[UIImage imageNamed:@"icons8-settings"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController *navigationController5 = [[UINavigationController alloc] initWithRootViewController:viewController5];
    [self addChildViewController:navigationController5];
    
    DownloadHomeViewController *viewController6 = [[DownloadHomeViewController alloc] init];
    viewController6.view.backgroundColor = [UIColor whiteColor];
    viewController6.navigationItem.title = NSLocalizedString(@"Download首页", nil);
    viewController6.tabBarItem.title = NSLocalizedString(@"Download", nil);
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
