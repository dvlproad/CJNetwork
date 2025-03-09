//
//  LOTAnimationView.h
//  CQTabBarController
//
//  Created by dvlproad on 2021/1/6.
//  Copyright © 2021 ciyouzen. All rights reserved.
//
//  Lottie animation view

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface LOTAnimationView : UIView {
    
}
@property (nonatomic, assign) CGFloat animationProgress;

- (instancetype)initWithContentsOfURL:(NSURL *)URL;
- (void)forceDrawingUpdate;
- (void)play;
- (void)stop;


@property (nonatomic, assign) BOOL loopAnimation;
+ (nonnull instancetype)animationNamed:(nonnull NSString *)animationName;
+ (nonnull instancetype)animationNamed:(nonnull NSString *)animationName inBundle:(nonnull NSBundle *)bundle;

@end

NS_ASSUME_NONNULL_END
