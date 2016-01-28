//
//  DSXRefreshHeader.h
//  LADZhangWo
//
//  Created by Apple on 16/1/27.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSXRefreshView.h"

typedef NS_ENUM(NSInteger,DSXRefreshState){
    DSXRefreshStateNormal,
    DSXRefreshStateWillRefreshing,
    DSXRefreshStateRefreshing,
    DSXRefreshStateRefreshComplete
};

@interface DSXRefreshHeader : DSXRefreshView

@property(nonatomic)BOOL isRefreshing;
@property(nonatomic)DSXRefreshState refreshState;
@property(nonatomic,readonly)UILabel *updateLabel;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)beginRefreshing;
- (void)endRefreshing;

@end
