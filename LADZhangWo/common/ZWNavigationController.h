//
//  LHBNavigationController.h
//  LADLihuibao
//
//  Created by Apple on 15/10/27.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ZWNavigationStyle){
    ZWNavigationStyleDefault,
    ZWNavigationStyleGray
};

@interface ZWNavigationController : UINavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController;

@property(nonatomic,assign)ZWNavigationStyle style;

@end