//
//  EncryptHomeViewController.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2016/3/26.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import <CJBaseUtil/CJSectionDataModel.h>   //在CJDataUtil中
#import <CJBaseUtil/CJModuleModel.h>        //在CJDataUtil中

@interface EncryptHomeViewController : UIViewController {
    
}
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<CJSectionDataModel *> *sectionDataModels;

@end
