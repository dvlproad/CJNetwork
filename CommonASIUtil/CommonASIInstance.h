//
//  CommonASIInstance.h
//  CommonAFNUtilDemo
//
//  Created by lichq on 8/10/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonASIUtil.h"

@interface CommonASIInstance : NSObject{
    
}
@property (nonatomic ,strong) ASIHTTPRequest *requestCurrent;

+ (CommonASIInstance *)shareCommonASIInstance;

- (void)request:(ASIHTTPRequest *)request delegate:(id<WebServiceASIDelegate>)delegate userInfo:(NSDictionary *)userInfo;

@end
