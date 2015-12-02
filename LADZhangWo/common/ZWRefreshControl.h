//
//  LHBRefreshControl.h
//  LADLihuibao
//
//  Created by Apple on 15/11/2.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZWRefreshControl : UIRefreshControl
- (instancetype)initWithFrame:(CGRect)frame;
- (void)beginRefreshing;
- (void)endRefreshing;
@end
