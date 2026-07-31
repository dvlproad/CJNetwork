#import "CQTSSegmentViewFactory.h"
#import <Masonry/Masonry.h>
#import <objc/runtime.h>

static const char kSegmentValueChangedBlockKey;

@interface CQTSSegmentViewFactory () {

}

@end

@implementation CQTSSegmentViewFactory

+ (UIView *)segmentViewWithTitle:(NSString *)title
                           items:(NSArray<NSString *> *)items
                   selectedIndex:(NSInteger)selectedIndex
         segmentValueChangedBlock:(void(^)(UISegmentedControl *segment))segmentValueChangedBlock
{
    UIView *segmentView = [[UIView alloc] init];

    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:items];
    objc_setAssociatedObject(segment, &kSegmentValueChangedBlockKey, segmentValueChangedBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [segment addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    [segmentView addSubview:segment];
    [segment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(segmentView).mas_offset(-4);
        make.centerY.mas_equalTo(segmentView);
        make.height.mas_equalTo(30);
    }];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentRight;
    [segmentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(segmentView).mas_offset(4);
        make.right.mas_equalTo(segment.mas_left).mas_offset(-4);
        make.top.bottom.mas_equalTo(segmentView);
    }];

    segment.selectedSegmentIndex = selectedIndex;
    label.text = title;

    return segmentView;
}

+ (void)segmentValueChanged:(UISegmentedControl *)segment {
    void (^block)(UISegmentedControl *) = objc_getAssociatedObject(segment, &kSegmentValueChangedBlockKey);
    if (block) {
        block(segment);
    }
}

@end
