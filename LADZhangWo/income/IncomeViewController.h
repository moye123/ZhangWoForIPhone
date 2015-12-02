//
//  IncomeViewController.h
//  LADLihuibao
//
//  Created by Apple on 15/10/27.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"

@interface IncomeViewController : UIViewController

- (instancetype)init;

@property(nonatomic,strong)NSString *income;
@property(nonatomic,retain)AFHTTPRequestOperationManager *afmanager;
@property(nonatomic,retain)ZWUserStatus *userStatus;
@property(nonatomic,retain)UIScrollView *scrollView;

@end
