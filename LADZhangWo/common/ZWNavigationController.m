//
//  LHBNavigationController.m
//  LADLihuibao
//
//  Created by Apple on 15/10/27.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "ZWNavigationController.h"

@implementation ZWNavigationController
@synthesize style = _style;

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        [self.navigationBar setHidden:NO];
        [self setStyle:ZWNavigationStyleDefault];
        [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0]}];
    }
    return self;
}

- (void)setStyle:(ZWNavigationStyle)style{
    _style = style;
    switch (style) {
        case ZWNavigationStyleGray:
            [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbg-gray.png"] forBarMetrics:UIBarMetricsDefault];
            [self.navigationBar setBarStyle:UIBarStyleDefault];
            [self.navigationBar setTintColor:[UIColor colorWithRed:0.2 green:0.22 blue:0.25 alpha:1]];
            break;
            
        default:
            [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav-bg-orange.png"] forBarMetrics:UIBarMetricsDefault];
            [self.navigationBar setBarStyle:UIBarStyleBlack];
            [self.navigationBar setTintColor:[UIColor whiteColor]];
            break;
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.35;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:animation forKey:nil];
    [super pushViewController:viewController animated:NO];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.2;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:animation forKey:nil];
    return [super popViewControllerAnimated:NO];
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.35;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:animation forKey:nil];
    [super presentViewController:viewControllerToPresent animated:NO completion:completion];
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.2;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:animation forKey:nil];
    [super dismissViewControllerAnimated:NO completion:completion];
}

@end
