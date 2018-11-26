//
//  CJNetworkEnvironmentManager.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2017/8/1.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CJNetworkEnvironmentModel.h"

//@"develop";
//@"develop2";
//@"preproduct";
//@"product";

@interface CJNetworkEnvironmentManager : NSObject {
    
}
@property (nonatomic, strong) CJNetworkEnvironmentModel *environmentModel;  /**< 当前网络环境 */
@property (nonatomic, strong) NSMutableDictionary *specificCommonParams;           /**< 设置每个请求都会有的公共参数(项目里已添加了其他一些公共参数) */

+ (CJNetworkEnvironmentManager *)sharedInstance;

#pragma mark - Url
- (NSString *)completeUrlWithApiSuffix:(NSString *)apiSuffix;

#pragma mark - Params
- (NSDictionary *)completeParamsWithCustomParams:(NSDictionary *)customParams;



@end
