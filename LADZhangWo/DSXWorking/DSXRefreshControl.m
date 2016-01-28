//
//  DSXRefreshControl.m
//  XiangBaLao
//
//  Created by Apple on 15/12/29.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "DSXRefreshControl.h"

@implementation DSXRefreshControl

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
    }
    return self;
}

- (void)beginRefreshing{
    self.attributedTitle = [[NSAttributedString alloc] initWithString:@"松开手开始刷新"];
    [super beginRefreshing];
}

- (void)endRefreshing{
    self.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
    [super endRefreshing];
}

@end
