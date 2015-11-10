//
//  IncomeViewController.m
//  LADLihuibao
//
//  Created by Apple on 15/10/27.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "IncomeViewController.h"
#import "IncomeView.h"

@implementation IncomeViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setTitle:@"我的收益"];
    [self.navigationController.tabBarItem setTitle:@"收益"];
    [self.view setBackgroundColor:[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1]];
    
    IncomeView *myIncomeView = [[IncomeView alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, 200)];
    [self.view addSubview:myIncomeView];
    
    UIButton *rechargeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rechargeButton setFrame:CGRectMake(20, 220, 80, 80)];
    [rechargeButton setBackgroundImage:[UIImage imageNamed:@"icon-recharge.png"] forState:UIControlStateNormal];
    [self.view addSubview:rechargeButton];
    
    UIButton *withdrawalButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [withdrawalButton setFrame:CGRectMake((SWIDTH-80)/2, 220, 80, 80)];
    [withdrawalButton setBackgroundImage:[UIImage imageNamed:@"icon-withdrawal.png"] forState:UIControlStateNormal];
    [self.view addSubview:withdrawalButton];
    
    UIButton *contactButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [contactButton setFrame:CGRectMake(SWIDTH-100, 220, 80, 80)];
    [contactButton setBackgroundImage:[UIImage imageNamed:@"icon-contact.png"] forState:UIControlStateNormal];
    [self.view addSubview:contactButton];
}

@end
