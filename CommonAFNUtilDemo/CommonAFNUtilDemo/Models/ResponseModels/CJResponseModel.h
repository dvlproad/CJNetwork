//
//  CJResponseModel.h
//  CommonAFNUtilDemo
//
//  Created by dvlproad on 2016/12/18.
//  Copyright © 2016年 ciyouzen. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface CJResponseModel : JSONModel

@property(nonatomic, strong) NSNumber<Optional> *status;
@property(nonatomic, strong) NSString<Optional> *message;
@property(nonatomic, strong) id<Optional> result;

@end
