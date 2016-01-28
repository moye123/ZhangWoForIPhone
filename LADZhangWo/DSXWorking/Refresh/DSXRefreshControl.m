//
//  DSXRefreshControl.m
//  LADZhangWo
//
//  Created by Apple on 16/1/28.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "DSXRefreshControl.h"

@implementation DSXRefreshControl
@synthesize headerView = _headerView;
@synthesize footerView = _footerView;
@synthesize scrollView = _scrollView;
@synthesize delegate   = _delegate;

- (instancetype)init{
    if (self = [super init]) {
        _headerView = [[DSXRefreshHeader alloc] init];
        _footerView = [[DSXRefreshFooter alloc] init];
    }
    return self;
}

- (instancetype)initWithScrollView:(UIScrollView *)scrollView{
    self = [self init];
    self.scrollView = scrollView;
    return self;
}

- (void)setDelegate:(id<DSXRefreshDelegate>)delegate{
    _delegate = delegate;
    _headerView.delegate = delegate;
    _footerView.delegate = delegate;
}

- (void)setScrollView:(UIScrollView *)scrollView{
    _scrollView = scrollView;
    _scrollView.dsx_headerView = _headerView;
    _scrollView.dsx_footerView = _footerView;
}

@end
