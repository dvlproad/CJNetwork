//
//  CQNetworkUploadHelperSetGetter.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/6/3.
//  Copyright © 2018年 dvlproad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CQNetworkUploadCompletionHelperProtocal.h"
#import "CQNetworkUploadSuccessFailureHelperProtocal.h"

NS_ASSUME_NONNULL_BEGIN

@interface CQNetworkUploadHelperSetGetter : NSObject

+ (void)setNetworkUploadHelper:(Class<CQNetworkUploadCompletionHelperProtocal, CQNetworkUploadSuccessFailureHelperProtocal>)networkUploadHelper;

+ (Class<CQNetworkUploadCompletionHelperProtocal, CQNetworkUploadSuccessFailureHelperProtocal>)networkUploadHelper;

@end

NS_ASSUME_NONNULL_END
