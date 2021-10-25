//
//  CQNetworkUploadClientSetGetter.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/6/3.
//  Copyright © 2018年 dvlproad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CQNetworkUploadCompletionClientProtocal.h"
#import "CQNetworkUploadSuccessFailureClientProtocal.h"

NS_ASSUME_NONNULL_BEGIN

@interface CQNetworkUploadClientSetGetter : NSObject

+ (void)setNetworkUploadClient:(Class<CQNetworkUploadCompletionClientProtocal, CQNetworkUploadSuccessFailureClientProtocal>)networkUploadClient;

+ (Class<CQNetworkUploadCompletionClientProtocal, CQNetworkUploadSuccessFailureClientProtocal>)networkUploadClient;

@end

NS_ASSUME_NONNULL_END
