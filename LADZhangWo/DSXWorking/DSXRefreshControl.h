//
//  DSXRefreshControl.h
//  XiangBaLao
//
//  Created by Apple on 15/12/29.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSXRefreshControl : UIRefreshControl
- (instancetype)initWithFrame:(CGRect)frame;
- (void)beginRefreshing;
- (void)endRefreshing;

@end
