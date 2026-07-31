#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CQTSSegmentViewFactory : NSObject

+ (UIView *)segmentViewWithTitle:(NSString *)title
                           items:(NSArray<NSString *> *)items
                   selectedIndex:(NSInteger)selectedIndex
         segmentValueChangedBlock:(void(^)(UISegmentedControl *segment))segmentValueChangedBlock;

@end

NS_ASSUME_NONNULL_END
