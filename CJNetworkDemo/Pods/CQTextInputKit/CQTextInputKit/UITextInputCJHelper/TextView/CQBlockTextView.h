//
//  CQBlockTextView.h
//  CJUIKitDemo
//
//  Created by ciyouzen on 2020/5/15.
//  Copyright © 2020 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CQBlockTextView : UITextView {
    
}
@property (nullable, nonatomic, copy) NSString *placeholder;
@property (nonatomic, assign) NSInteger maxLength;              //最大长度(默认
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, strong) UILabel *wordNumLabel;

//文字输入
@property (nonatomic, copy) void(^textDidChangeBlock)(NSString *text);


@end

NS_ASSUME_NONNULL_END
