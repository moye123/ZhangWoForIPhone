//
//  LHBRefreshControl.m
//  LADLihuibao
//
//  Created by Apple on 15/11/2.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "LHBRefreshControl.h"

@implementation LHBRefreshControl

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setAttributedTitle:[[NSAttributedString alloc] initWithString:@"下拉刷新"]];
    }
    return self;
}

- (void)beginRefreshing{
    [super beginRefreshing];
    [self setAttributedTitle:[[NSAttributedString alloc] initWithString:@"正在刷新.."]];

}

- (void)endRefreshing{
    [super endRefreshing];
    [self setAttributedTitle:[[NSAttributedString alloc] initWithString:@"下拉刷新"]];

}

@end
