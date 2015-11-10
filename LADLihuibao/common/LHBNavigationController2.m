//
//  LHBNavigationController2.m
//  LADLihuibao
//
//  Created by Apple on 15/11/3.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "LHBNavigationController2.h"

@interface LHBNavigationController2 ()

@end

@implementation LHBNavigationController2

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController;{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        self.navigationBar.backIndicatorImage = [UIImage imageNamed:@"navbg2.png"];
    }
    return self;
}

@end
