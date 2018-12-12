//
//  CJNetworkEnvironmentManagerProtocol.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/6/3.
//  Copyright © 2018年 dvlproad. All rights reserved.
//

#ifndef CJNetworkEnvironmentManagerProtocol_h
#define CJNetworkEnvironmentManagerProtocol_h

@protocol CJNetworkEnvironmentManagerProtocol <NSObject>

- (NSString *)completeUrlWithApiSuffix:(NSString *)apiSuffix;
- (NSDictionary *)completeParamsWithCustomParams:(NSDictionary *)customParams;

@end


#endif /* CJNetworkEnvironmentManagerProtocol_h */
