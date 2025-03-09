//
//  LOTAnimationView.m
//  CQTabBarController
//
//  Created by dvlproad on 2021/1/6.
//  Copyright © 2021 ciyouzen. All rights reserved.
//

#import "LOTAnimationView.h"
//#import "CQBridgeSTOLottie-Swift.h"                         // Podfile中没使用use_frameworks!的时候
//#import <CQBridgeSTOLottie/CQBridgeSTOLottie-Swift.h>       // Podfile中有使用use_frameworks!的时候
#if __has_include("CQBridgeSTOLottie-Swift.h")
#import "CQBridgeSTOLottie-Swift.h"                         // Podfile中没使用use_frameworks!的时候
#else
    #if __has_include(<CQBridgeSTOLottie/CQBridgeSTOLottie-Swift.h>)
    #import <CQBridgeSTOLottie/CQBridgeSTOLottie-Swift.h>   // Podfile中有使用use_frameworks!的时候
    #else
    #endif
#endif

@interface LOTAnimationView ()

@property (nonatomic, strong) AnimationViewContainer *animationView;


@end

@implementation LOTAnimationView


- (void)setAnimationProgress:(CGFloat)animationProgress {
    _animationProgress = animationProgress;
    
    self.animationView.animationProgress = animationProgress;
}

- (void)forceDrawingUpdate {
    [self.animationView forceDrawingUpdate];
}

- (void)play {
    [self.animationView play];
}

- (void)stop {
    [self.animationView stop];
}


- (instancetype)initWithContentsOfURL:(NSURL *)URL {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.animationView = [[AnimationViewContainer alloc] init];
        [self addSubview:self.animationView];
        
        //[self.animationView configAnimationWithName:@"tab_search_animate" filePath:nil];
        
        NSString *filePath = [URL absoluteString];
        NSString *jsonFileFullName = [filePath lastPathComponent];
        NSString *jsonFileName;
        NSArray *jsonFileFullNameComponent = [jsonFileFullName componentsSeparatedByString:@"."];
        if ([jsonFileFullNameComponent count] != 2) {
            jsonFileName = nil;
        } else {
            NSString *fileTitle = [jsonFileFullNameComponent objectAtIndex:0];
            //NSString *fileType = [jsonFileFullNameComponent objectAtIndex:1];
            jsonFileName = fileTitle;
        }
        
        [self.animationView configAnimationWithName:jsonFileName bundle:nil subdirectory:nil];
    }
    return self;
}

- (instancetype)initWithAnimationNamed:(nonnull NSString *)animationName inBundle:(nonnull NSBundle *)bundle {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.animationView = [[AnimationViewContainer alloc] init];
        [self addSubview:self.animationView];
        
        [self.animationView configAnimationWithName:animationName bundle:bundle subdirectory:nil];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.animationView.frame = self.bounds;
}

- (void)setLoopAnimation:(BOOL)loopAnimation {
    _loopAnimation = loopAnimation;
}



+ (nonnull instancetype)animationNamed:(nonnull NSString *)animationName {
  return [self animationNamed:animationName inBundle:[NSBundle mainBundle]];
    
    
}

+ (nonnull instancetype)animationNamed:(nonnull NSString *)animationName inBundle:(nonnull NSBundle *)bundle {
    return [[LOTAnimationView alloc] initWithAnimationNamed:animationName inBundle:bundle];
}

@end
