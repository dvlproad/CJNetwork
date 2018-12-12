//
//  CJResponseModel.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2016/12/18.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CJResponseModel : NSObject

@property (nonatomic, assign) NSInteger statusCode;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) id result;
@property (nonatomic, copy) NSString *cjNetworkLog;

@property (nonatomic, assign) BOOL isCacheData;

/*
CJResponseModel *responseModel = [[CJResponseModel alloc] init];
responseModel.statusCode = [responseDictionary[@"status"] integerValue];
responseModel.message = responseDictionary[@"message"];
responseModel.result = responseDictionary[@"result"];
responseModel.isCacheData = isCacheData;
*/
//- (instancetype)initWithResponseDictionary:(NSDictionary *)responseDictionary isCacheData:(BOOL)isCacheData;
- (BOOL)isNoNullForObject:(id)object;

+ (CJResponseModel *)responseModelWithRequestFailureMessage:(NSString *)requestFailureMessage;

@end
