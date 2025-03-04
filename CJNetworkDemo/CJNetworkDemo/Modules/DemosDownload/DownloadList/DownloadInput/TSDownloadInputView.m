//
//  TSDownloadInputView.m
//  CJUIKitDemo
//
//  Created by ciyouzen on 8/10/15.
//  Copyright (c) 2015 dvlproad. All rights reserved.
//
//  用于下载列表的输入框 高度为 50+10+50

#import "TSDownloadInputView.h"
#import <Masonry/Masonry.h>

@interface TSDownloadInputView () {
    
}
@property (nonatomic, copy) void(^fetchVideoHandle)(NSString *text);
@property (nonatomic, assign, readonly) NSInteger changeCount;

@end


@implementation TSDownloadInputView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Init
- (instancetype)initWithFetchVideoHandle:(void (^)(NSString *text))fetchVideoHandle {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _fetchVideoHandle = fetchVideoHandle;
        
        self.backgroundColor = [UIColor clearColor];
        [self setupViews];
        
        // 监听app回到前台
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"has_agreed_privacy_policy"]; //TODO: qian
        _changeCount = [[NSUserDefaults standardUserDefaults] integerForKey:@"old_changeCount"];
    }
    return self;
}

#pragma mark - Private Method
- (void)appDidBecomeActive {
    //[self.textField becomeFirstResponder];
    [self pasteClipboardWithMustChange:YES];
}

- (void)setupViews {
    // 创建输入框
    self.textField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.textField.backgroundColor = [UIColor lightGrayColor];
    self.textField.textColor = [UIColor whiteColor];
    self.textField.font = [UIFont systemFontOfSize:12];
    self.textField.contentScaleFactor = 0.5;
    self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"粘贴TikTok视频链接..." attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
    self.textField.layer.cornerRadius = 10;
    self.textField.layer.masksToBounds = YES;
    self.textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    [self addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.height.mas_equalTo(50);
        //make.centerX.mas_equalTo(self);
        make.left.mas_equalTo(self).offset(10);
        make.right.mas_equalTo(self).offset(-10);
    }];
    
    // 创建粘贴板按钮
    UIButton *pasteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    pasteButton.frame = CGRectMake(0, 0, 30, 30);
    [pasteButton setImage:[UIImage imageNamed:@"icons8-calendar"] forState:UIControlStateNormal];
    [pasteButton addTarget:self action:@selector(pasteClipboard) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:pasteButton];
//    [pasteButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(self).offset(-10);
//        make.centerY.mas_equalTo(self.textField);
//        make.width.mas_equalTo(30);
//        make.height.mas_equalTo(30);
//    }];
    UIView *rightPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
//    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 20, 20)];
//    iconView.image = [UIImage imageNamed:@"your_icon"];
//    iconView.contentMode = UIViewContentModeScaleAspectFit;
    [rightPaddingView addSubview:pasteButton];
    self.textField.rightView = rightPaddingView;
    self.textField.rightViewMode = UITextFieldViewModeAlways;
    
    // 创建按钮
    self.fetchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.fetchButton.frame = CGRectZero;
    self.fetchButton.backgroundColor = [UIColor redColor];
    [self.fetchButton setTitle:@"获取视频" forState:UIControlStateNormal];
    self.fetchButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.fetchButton.layer.cornerRadius = 10;
    self.fetchButton.layer.masksToBounds = YES;
    [self.fetchButton addTarget:self action:@selector(fetchVideo) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.fetchButton];
    [self.fetchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.textField.mas_bottom).offset(10);
        make.left.mas_equalTo(self).offset(20);
        make.height.mas_equalTo(50);
    }];
}



#pragma mark - Setter


#pragma mark - Event
- (void)pasteClipboard {
    [self pasteClipboardWithMustChange:NO];
}
// 处理粘贴板粘贴功能
- (void)pasteClipboardWithMustChange:(BOOL)mustChange {
    BOOL hasAgree = [[NSUserDefaults standardUserDefaults] boolForKey:@"has_agreed_privacy_policy"];
    if (hasAgree != true) {
        return;
    }
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (mustChange == true && pasteboard.changeCount == _changeCount) {
        return;
    }
    _changeCount = pasteboard.changeCount;
    
    if (pasteboard.string.length > 0) {
        self.textField.text = pasteboard.string;
        [[NSUserDefaults standardUserDefaults] setInteger:pasteboard.changeCount forKey:@"old_changeCount"];
    }
}

// 处理获取视频点击事件
- (void)fetchVideo {
    NSString *text = self.textField.text;
    NSLog(@"获取视频: %@", text);
    
    if (self.fetchVideoHandle) {
        self.fetchVideoHandle(text);
    }
}

@end
