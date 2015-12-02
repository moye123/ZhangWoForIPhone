//
//  LHBNavigationController.h
//  LADLihuibao
//
//  Created by Apple on 15/10/27.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,LHBNavigationStyle){
    LHBNavigationStyleDefault,
    LHBNavigationStyleGray
};

@interface ZWNavigationController : UINavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController;
- (void)setNavigationStyle:(LHBNavigationStyle)style;

@end