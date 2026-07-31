//
//  UIView+CQAuxiliaryText.m
//  CQDemoKit
//
//  Created by ciyouzen on 7/9/15.
//  Copyright (c) 2015 dvlproad. All rights reserved.
//

#import "UIView+CQAuxiliaryText.h"
#import <Masonry/Masonry.h>

@implementation UIView (Prompt)

- (void)cqts_addPromptText:(NSString *)text layout:(CQAuxiliaryAlignment)layout height:(CGFloat)height {
    UILabel *label = [[UILabel alloc] init];
    label.tag = 9004;
    label.numberOfLines = 0;
    label.text = text;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    label.textAlignment = NSTextAlignmentCenter;
    [self cqts_addPromptView:label layout:layout height:height];
}


- (void)cqts_removePrompt:(CQAuxiliaryRemove)order {
    [self cqts_removePromptWithTag:9004 order:order];
}

- (void)cqts_removePromptWithTag:(NSInteger)tag order:(CQAuxiliaryRemove)order {
    UILabel *label = [self viewWithTag:tag];
    if (label == nil) {
        return;
    }
    
    if (order == CQAuxiliaryRemoveLastOne || order == CQAuxiliaryRemoveAll) {
        // 获取所有子视图，过滤出符合 tag 的视图
        NSArray<UIView *> *subviews = [self subviews];
        NSMutableArray<UIView *> *taggedViews = [NSMutableArray array];
        for (UIView *subview in subviews) {
            if (subview.tag == tag) {
                [taggedViews addObject:subview];
            }
        }
        
        if (order == CQAuxiliaryRemoveAll) {
            // 按从后往前的顺序移除视图
            for (UIView *view in [taggedViews reverseObjectEnumerator]) {
                [view removeFromSuperview];
            }
        } else {
            // 按从后往前的顺序移除视图
            for (UIView *view in [taggedViews reverseObjectEnumerator]) {
                [view removeFromSuperview];
                break;  // 只移除一个
            }
        }
        
    } else {
        [label removeFromSuperview];
    }
}


- (void)cqts_addPromptView:(UIView *)promptView layout:(CQAuxiliaryAlignment)layout height:(CGFloat)height {
    promptView.tag = 9004;
    [self addSubview:promptView];

    if (layout == CQAuxiliaryAlignmentTop ||
        layout == CQAuxiliaryAlignmentBottom ||
        layout == CQAuxiliaryAlignmentTopTop ||
        layout == CQAuxiliaryAlignmentBottomBottom ||
        layout == CQAuxiliaryAlignmentCenter) {
        
        [promptView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.left.equalTo(self).offset(4);
            make.height.mas_equalTo(height);
            
            if (layout == CQAuxiliaryAlignmentTop) {
                make.top.equalTo(self);
            } else if (layout == CQAuxiliaryAlignmentBottom) {
                make.bottom.mas_equalTo(self);
            } else if (layout == CQAuxiliaryAlignmentTopTop) {
                make.bottom.mas_equalTo(self.mas_top);
            } else if (layout == CQAuxiliaryAlignmentBottomBottom) {
                make.top.mas_equalTo(self.mas_bottom);
            }  else {
                make.centerY.equalTo(self);
            }
        }];
        
    } else { // CQAuxiliaryAlignmentFill
        [promptView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.left.equalTo(self);
            make.top.equalTo(self);
            make.centerY.equalTo(self);
        }];
    }
}

@end
