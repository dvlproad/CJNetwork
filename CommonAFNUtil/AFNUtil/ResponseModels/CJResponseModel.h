//
//  CJResponseModel.h
//  CommonAFNUtilDemo
//
//  Created by 李超前 on 2016/12/18.
//  Copyright © 2016年 ciyouzen. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface CJResponseModel : JSONModel

@property (strong, nonatomic) NSNumber *status;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) id result;

@end
