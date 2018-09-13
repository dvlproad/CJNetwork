//
//  CJNetworkInfoModel.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2016/12/20.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CJNetworkInfoModel : NSObject

@property (nonatomic, copy) NSString *Url;              /**< 请求的地址 */
@property (nonatomic, strong) id params;                /**< 请求的原始参数 */
@property (nonatomic, copy) NSString *bodyString;       /**< 请求的最终参数 */
@property (nonatomic, copy) NSString *responseString;   /**< 请求的结果 */

@end
