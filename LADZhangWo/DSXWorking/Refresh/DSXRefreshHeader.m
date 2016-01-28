//
//  DSXRefreshHeader.m
//  LADZhangWo
//
//  Created by Apple on 16/1/27.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "DSXRefreshHeader.h"

@implementation DSXRefreshHeader
@synthesize isRefreshing  = _isRefreshing;
@synthesize updateLabel   = _updateLabel;
@synthesize refreshState  = _refreshState;

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _updateLabel = [[UILabel alloc] init];
        _updateLabel.font = [UIFont systemFontOfSize:13.0];
        _updateLabel.textColor = [UIColor grayColor];
        _updateLabel.text = @"上次更新:2016-01-27";
        [self addSubview:_updateLabel];
        [self setRefreshState:DSXRefreshStateNormal];
    }
    return self;
}

- (void)setRefreshState:(DSXRefreshState)refreshState{
    switch (refreshState) {
        case DSXRefreshStateNormal:
            self.textLabel.text = @"下拉刷新当前内容";
            break;
        case DSXRefreshStateWillRefreshing:
            self.textLabel.text = @"松开手开始刷新";
            break;
            
        case DSXRefreshStateRefreshing:
            self.textLabel.text = @"下拉刷新内容中..";
            break;
        default:
            self.textLabel.text = @"下拉刷新当前内容";
            break;
    }
}

- (void)beginRefreshing{
    _isRefreshing = YES;
    self.refreshState = DSXRefreshStateRefreshing;
    [self.indicatorView startAnimating];
}

- (void)endRefreshing{
    _isRefreshing = NO;
    self.refreshState = DSXRefreshStateRefreshComplete;
    [self.indicatorView stopAnimating];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.textLabel sizeToFit];
    [self.updateLabel sizeToFit];
    self.textLabel.position = CGPointMake((self.width - self.textLabel.width)/2, 0);
    self.updateLabel.position = CGPointMake((self.width - self.updateLabel.width)/2, self.textLabel.height+10);
    self.indicatorView.frame = CGRectMake(self.updateLabel.originX - 50, (self.height - 30)/2, 30, 30);
}

@end
