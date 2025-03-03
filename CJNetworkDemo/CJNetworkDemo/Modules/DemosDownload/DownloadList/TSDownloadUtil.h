//
//  TSDownloadUtil.h
//  CJNetworkDemo
//
//  Created by qian on 2025/3/2.
//  Copyright © 2025 dvlproad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CQDownloadRecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TSDownloadUtil : NSObject

+ (void)saveInViewController:(UIViewController *)vc forDownloadModel:(CQDownloadRecordModel *)downloadModel;

@end

NS_ASSUME_NONNULL_END
