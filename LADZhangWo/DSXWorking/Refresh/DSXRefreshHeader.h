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
    DSXRefreshStateNormal = 0,
    DSXRefreshStateWillRefresh = 1,
    DSXRefreshStateRefreshing = 2,
};

UIKIT_EXTERN NSString *const DSXRefreshStateNormalText;
UIKIT_EXTERN NSString *const DSXRefreshStateWillRefreshText;
UIKIT_EXTERN NSString *const DSXRefreshStateRefreshingText;

@interface DSXRefreshHeader : DSXRefreshView{
    NSString *_updateTimeKey;
    UIImageView *_arrow;
}

@property(nonatomic)BOOL isRefreshing;
@property(nonatomic,readwrite)DSXRefreshState refreshState;
@property(nonatomic,readonly)UILabel *updateTimeLabel;

- (instancetype)init;
- (instancetype)initWithFrame:(CGRect)frame;
- (void)beginRefreshing;
- (void)endRefreshing;

@end
