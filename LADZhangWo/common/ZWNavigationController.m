//
//  LHBNavigationController.m
//  LADLihuibao
//
//  Created by Apple on 15/10/27.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "ZWNavigationController.h"

@implementation ZWNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        [self.navigationBar setHidden:NO];
        [self setNavigationStyle:LHBNavigationStyleDefault];
        [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0]}];
    }
    return self;
}

- (void)setNavigationStyle:(LHBNavigationStyle)style{
    switch (style) {
        case LHBNavigationStyleGray:
            [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbg-gray.png"] forBarMetrics:UIBarMetricsDefault];
            [self.navigationBar setBarStyle:UIBarStyleDefault];
            [self.navigationBar setTintColor:[UIColor blackColor]];
            break;
            
        default:
            [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbg-green.png"] forBarMetrics:UIBarMetricsDefault];
            [self.navigationBar setBarStyle:UIBarStyleBlack];
            [self.navigationBar setTintColor:[UIColor whiteColor]];
            break;
    }
}

@end
