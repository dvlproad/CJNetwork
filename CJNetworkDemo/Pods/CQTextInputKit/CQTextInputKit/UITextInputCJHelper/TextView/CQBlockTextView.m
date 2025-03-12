//
//  CQBlockTextView.m
//  CJUIKitDemo
//
//  Created by ciyouzen on 2020/5/15.
//  Copyright © 2020 dvlproad. All rights reserved.
//

#import "CQBlockTextView.h"

@interface CQBlockTextView () {
    
}

@end

@implementation CQBlockTextView

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addObserver];
        [self setupViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];

    if (self) {
        [self addObserver];
        [self setupViews];


    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addObserver];
        [self setupViews];
    }
    return self;
}


#pragma mark - SetupViews
- (void)setupViews {
    if (!self.placeholderLabel) {
        self.placeholderLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 0, self.frame.size.width, self.frame.size.height)];
        self.placeholderLabel.textColor = [UIColor lightGrayColor];
        self.placeholderLabel.numberOfLines = 0;
        self.placeholderLabel.font = [self font];
        [self addSubview:self.placeholderLabel];
    }
    
    if (!self.wordNumLabel) {
        self.wordNumLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        self.wordNumLabel.font = [UIFont systemFontOfSize:13];
        self.wordNumLabel.textColor = [UIColor lightGrayColor];
        self.wordNumLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.wordNumLabel];
    }
    
    self.wordNumLabel.hidden = YES;
}

- (void)layoutSubviews {
    self.placeholderLabel.frame = CGRectMake(8, 6.5, self.frame.size.width-8, self.frame.size.height);
    [self.placeholderLabel sizeToFit];
    [self.wordNumLabel sizeToFit];
    [self refreshFram];
}

#pragma mark - Setter
- (void)setText:(NSString *)text {
    [super setText:text];
    if (text.length > 0) {
        [self.placeholderLabel setHidden:YES];
        
        if (self.maxLength != 0) {
            self.wordNumLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)[text length],(long)_maxLength];
            [self.wordNumLabel sizeToFit];
            [self refreshFram];
        }
    } else {
        [self.placeholderLabel setHidden:NO];
    }
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.placeholderLabel.text = _placeholder;
    [self.placeholderLabel sizeToFit];
    [self endEditing:NO];
}

- (void)setMaxLength:(NSInteger)maxLength {
    _maxLength = maxLength;
    
    if (maxLength > 0) {
        self.wordNumLabel.hidden = NO;
    } else {
        self.wordNumLabel.hidden = YES;
    }
    self.wordNumLabel.text = [NSString stringWithFormat:@"%zd/%zd", self.text.length, (long)_maxLength];
}

#pragma mark - Listen
- (void)addObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(placeholderTextViewdidChange:) name:UITextViewTextDidChangeNotification object:self];
}

- (void)placeholderTextViewdidChange:(NSNotification *)notificat {
    CQBlockTextView *textView = (CQBlockTextView *)notificat.object;
    if ([self.text length] > 0) {
        [self.placeholderLabel setHidden:YES];
    } else {
        [self.placeholderLabel setHidden:NO];
    }
    
    //禁忌：不能在TextDidChange此做裁剪，会导致裁剪错误，比如最后一个字是表情，裁剪了一半
//    if (self.maxLength != 0 && [textView.text length] > self.maxLength && textView.markedTextRange == nil) {
//        textView.text = [textView.text substringToIndex:self.maxLength];
//    }
    
    self.wordNumLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)[textView.text length],(long)_maxLength];
    if (self.textDidChangeBlock) {
        self.textDidChangeBlock(textView.text);
    }

    [self refreshFram];
}



- (void)placeholderTextViewEndEditinge {
    if ([self.text length]>0) {
        [self.placeholderLabel setHidden:YES];
    }else{
        [self.placeholderLabel setHidden:NO];
        
    }
}

- (void)refreshFram {
    [self.wordNumLabel sizeToFit];
    if (self.contentSize.height > self.frame.size.height-self.wordNumLabel.frame.size.height-5) {
        self.wordNumLabel.frame = CGRectMake(self.frame.size.width - self.wordNumLabel.frame.size.width-5, self.contentSize.height+self.contentInset.bottom-self.wordNumLabel.frame.size.height-5, self.wordNumLabel.frame.size.width, self.wordNumLabel.frame.size.height);
        self.contentInset = UIEdgeInsetsMake(0, 0, self.wordNumLabel.frame.size.height, 0);
        
    } else {
        self.wordNumLabel.frame = CGRectMake(self.frame.size.width - self.wordNumLabel.frame.size.width-5, self.frame.size.height + self.contentInset.bottom-self.wordNumLabel.frame.size.height-5, self.wordNumLabel.frame.size.width, self.wordNumLabel.frame.size.height);
        self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);

    }
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
