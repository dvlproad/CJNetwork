//
//  AccountInfo.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 8/1/15.
//  Copyright (c) 2015 dvlproad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountInfo : NSObject

@property(nonatomic, strong) NSString *uid;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *email;
@property(nonatomic, strong) NSString *pasd;

- (instancetype)initWithHisDictionary:(NSDictionary *)dictionary;

@end
