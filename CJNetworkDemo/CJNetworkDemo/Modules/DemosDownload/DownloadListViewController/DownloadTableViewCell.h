//
//  DownloadTableViewCell.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2017/3/31.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CJBaseDownloadView.h"

@interface DownloadTableViewCell : UITableViewCell {
    
}
@property (nonatomic, strong) UIImageView *previewImageView;        /** 预览图 */
@property (nonatomic, strong) CJBaseDownloadView *downloadView;     /** 下载文件的视图 */

@end
