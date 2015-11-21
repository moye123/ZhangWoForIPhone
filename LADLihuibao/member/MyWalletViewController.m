//
//  MyWalletViewController.m
//  LADLihuibao
//
//  Created by Apple on 15/11/21.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "MyWalletViewController.h"

@implementation MyWalletViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setTitle:@"我的钱包"];
    [self.view setBackgroundColor:[UIColor backColor]];
    self.navigationItem.leftBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleMore target:self action:nil];
    
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
