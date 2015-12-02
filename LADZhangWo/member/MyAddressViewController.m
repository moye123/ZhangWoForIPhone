//
//  MyAddressViewController.m
//  LADZhangWo
//
//  Created by Apple on 15/12/2.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "MyAddressViewController.h"

@implementation MyAddressViewController
@synthesize userStatus = _userStatus;
@synthesize addressList = _addressList;

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setTitle:@"管理收货地址"];
    self.navigationItem.leftBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
