#import "CQTSDataEmptyView.h"
#import <Masonry/Masonry.h>

#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>


@interface CQTSDataEmptyView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIButton *actionButton;

@end

@implementation CQTSDataEmptyView

+ (BOOL)isNetworkReachable {
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;

    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(
        kCFAllocatorDefault, (const struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    if (SCNetworkReachabilityGetFlags(reachability, &flags)) {
        CFRelease(reachability);
        return (flags & kSCNetworkReachabilityFlagsReachable)
            && !(flags & kSCNetworkReachabilityFlagsConnectionRequired);
    }
    CFRelease(reachability);
    return NO;
}

/*
 *  初始化
 *
 *  @param reloadHandle 刷新回调
 *
 *  @return CQTSDataEmptyView
 */
- (instancetype)initWithReloadHandle:(void(^)(CQTSDataEmptyView *emptyView))reloadHandle {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _reloadBlock = reloadHandle;

        NSString *bundleName = @"CQDemoKit_StateUI";
        NSBundle *frameworkBundle = [NSBundle bundleForClass:[self class]];
        NSURL *bundleURL = [frameworkBundle URLForResource:bundleName withExtension:@"bundle"];
        NSBundle *resourceBundle = bundleURL ? [NSBundle bundleWithURL:bundleURL] : nil;
        
        self.imageView.image = [UIImage imageNamed:@"icon_no_data" inBundle:resourceBundle compatibleWithTraitCollection:nil];
        self.titleLabel.text = NSLocalizedString(@"数据加载失败，请重新加载...", nil);
        [self.actionButton setTitle:NSLocalizedString(@"刷新", nil) forState:UIControlStateNormal];

        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = UIColor.whiteColor;
    
    [self addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(self).offset(-80);
        make.width.mas_equalTo(85);
        make.height.mas_equalTo(73);
    }];

    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageView.mas_bottom).offset(17);
        make.left.mas_equalTo(self).offset(10);
        make.right.mas_equalTo(self).offset(-10);
    }];

    [self addSubview:self.messageLabel];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(4);
        make.left.mas_equalTo(self).offset(10);
        make.right.mas_equalTo(self).offset(-10);
    }];

    [self addSubview:self.actionButton];
    [self.actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.messageLabel.mas_bottom).offset(31);
        make.width.mas_equalTo(156);
        make.height.mas_equalTo(47);
    }];
}

#pragma mark - Lazy

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.textColor = [UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1];
    }
    return _titleLabel;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.numberOfLines = 0;
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.font = [UIFont systemFontOfSize:17];
        _messageLabel.textColor = [UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1];
    }
    return _messageLabel;
}

- (UIButton *)actionButton {
    if (!_actionButton) {
        _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _actionButton.layer.cornerRadius = 3;
        _actionButton.clipsToBounds = YES;
        _actionButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_actionButton setBackgroundColor:[UIColor colorWithRed:51/255.0 green:136/255.0 blue:255/255.0 alpha:1]];
        [_actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_actionButton addTarget:self action:@selector(reloadAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _actionButton;
}

#pragma mark - Action

- (void)reloadAction {
    if (![CQTSDataEmptyView isNetworkReachable]) {
        self.message = NSLocalizedString(@"请检查您的手机是否联网", nil);
        return;
    }
    
    if (self.reloadBlock) {
        self.reloadBlock(self);
    }
}

@end
