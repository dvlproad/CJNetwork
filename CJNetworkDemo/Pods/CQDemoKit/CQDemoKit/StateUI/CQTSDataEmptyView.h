#import <UIKit/UIKit.h>

@interface CQTSDataEmptyView : UIView {
    
}

@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) void(^reloadBlock)(CQTSDataEmptyView *emptyView);

+ (BOOL)isNetworkReachable;

/*
 *  初始化
 *
 *  @param reloadHandle 刷新回调
 *
 *  @return CQTSDataEmptyView
 */
- (instancetype)initWithReloadHandle:(void(^)(CQTSDataEmptyView *emptyView))reloadHandle NS_DESIGNATED_INITIALIZER;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

@end
