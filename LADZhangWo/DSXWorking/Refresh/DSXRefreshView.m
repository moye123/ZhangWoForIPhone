//
//  DSXRefreshView.m
//  LADZhangWo
//
//  Created by Apple on 16/1/27.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "DSXRefreshView.h"

const CGFloat DSXRefreshHeaderHeight = 64.0;
const CGFloat DSXRefreshFooterHeight = 44.0;
NSString *const DSXRefreshKeyPathContentSize = @"contentSize";
NSString *const DSXRefreshKeyPathContentOffset = @"contentOffset";
NSString *const DSXRefreshKeyPathPanState = @"state";

@implementation DSXRefreshView
@synthesize textLabel     = _textLabel;
@synthesize indicatorView = _indicatorView;
@synthesize scrollView    = _scrollView;
@synthesize delegate      = _delegate;
@synthesize scrollViewOriginInset = _scrollViewOriginInset;

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:14.0];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.textColor = [UIColor colorWithRed:0.36 green:0.47 blue:0.48 alpha:1];
        [self addSubview:_textLabel];
        
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicatorView.size = CGSizeMake(30, 30);
        [self addSubview:_indicatorView];
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    if (newSuperview && ![newSuperview isKindOfClass:[UIScrollView class]]) {
        return;
    }
    [self removeObservers];
    if (newSuperview) {
        self.width = newSuperview.width;
        self.originX = 0;
        
        _scrollView = (UIScrollView *)newSuperview;
        _scrollView.alwaysBounceVertical = YES;
        _scrollViewOriginInset = _scrollView.contentInset;
        [self addObservers];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

#pragma mark - KVO监听
- (void)addObservers
{
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.scrollView addObserver:self forKeyPath:DSXRefreshKeyPathContentOffset options:options context:nil];
    [self.scrollView addObserver:self forKeyPath:DSXRefreshKeyPathContentSize options:options context:nil];
    self.pan = self.scrollView.panGestureRecognizer;
    [self.pan addObserver:self forKeyPath:DSXRefreshKeyPathPanState options:options context:nil];
}

- (void)removeObservers
{
    [self.scrollView removeObserver:self forKeyPath:DSXRefreshKeyPathContentOffset];
    [self.scrollView removeObserver:self forKeyPath:DSXRefreshKeyPathContentSize];;
    [self.pan removeObserver:self forKeyPath:DSXRefreshKeyPathPanState];
    self.pan = nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    // 遇到这些情况就直接返回
    if (!self.userInteractionEnabled) return;
    
    // 这个就算看不见也需要处理
    if ([keyPath isEqualToString:DSXRefreshKeyPathContentSize]) {
        [self scrollViewContentSizeDidChange:change];
    }
    
    // 看不见
    if (self.hidden) return;
    if ([keyPath isEqualToString:DSXRefreshKeyPathContentOffset]) {
        [self scrollViewContentOffsetDidChange:change];
    } else if ([keyPath isEqualToString:DSXRefreshKeyPathPanState]) {
        [self scrollViewPanStateDidChange:change];
    }
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change{}
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change{}
- (void)scrollViewPanStateDidChange:(NSDictionary *)change{}

@end
