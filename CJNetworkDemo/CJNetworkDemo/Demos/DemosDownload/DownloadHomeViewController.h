//
//  DownloadHomeViewController.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2017/3/31.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import <CJBaseUtil/CJSectionDataModel.h>   //在CJDataUtil中
#import <CJBaseUtil/CJModuleModel.h>        //在CJDataUtil中

@interface DownloadHomeViewController : UIViewController {
    
}
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<CJSectionDataModel *> *sectionDataModels;

@end
