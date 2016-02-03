//
//  DSXRefreshControl.m
//  LADZhangWo
//
//  Created by Apple on 16/1/28.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "DSXRefreshControl.h"

@implementation DSXRefreshControl
@synthesize headerView   = _headerView;
@synthesize footerView   = _footerView;
@synthesize refreshState = _refreshState;
@synthesize loadingState = _loadingState;
@synthesize bottomHidden = _bottomHidden;
@synthesize delegate     = _delegate;

- (instancetype)init{
    if (self = [super init]) {
        _headerView = [[DSXRefreshHeader alloc] init];
        _footerView = [[DSXRefreshFooter alloc] init];
    }
    return self;
}

- (void)setDelegate:(id<DSXRefreshDelegate>)delegate{
    _delegate = delegate;
    self.headerView.delegate = delegate;
    self.footerView.delegate = delegate;
}

- (void)setRefreshState:(DSXRefreshState)refreshState{
    if (_refreshState != refreshState) {
        _refreshState = refreshState;
        _headerView.refreshState = refreshState;
    }
}

- (DSXRefreshState)refreshState{
    return self.headerView.refreshState;
}

- (void)setLoadingState:(DSXLoadingState)loadingState{
    if (_loadingState != loadingState) {
        _loadingState = loadingState;
        self.footerView.loadingState = loadingState;
    }
}

- (DSXLoadingState)loadingState{
    return self.footerView.loadingState;
}

- (void)setBottomHidden:(BOOL)bottomHidden{
    _bottomHidden = bottomHidden;
    self.footerView.hidden = bottomHidden;
}

- (void)beginRefreshing{
    [self.headerView beginRefreshing];
}

- (void)endRefreshing{
    [self.headerView endRefreshing];
}

- (void)beginLoading{
    [self.footerView beginLoading];
}

- (void)endLoading{
    [self.footerView endLoading];
}

@end
