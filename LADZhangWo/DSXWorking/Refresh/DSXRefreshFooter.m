//
//  DSXRefreshFooter.m
//  LADZhangWo
//
//  Created by Apple on 16/1/28.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "DSXRefreshFooter.h"

NSString *const DSXLoadingStateNormalText = @"上拉加载更多数据";
NSString *const DSXLoadingStateWillLoadingText = @"松开手立即加载";
NSString *const DSXLoadingStateLoadingText = @"正在加载更多数据..";
NSString *const DSXLoadingStateNoMoreDataText = @"没有更多内容了";

@implementation DSXRefreshFooter
@synthesize isLoading = _isLoading;
@synthesize loadingState = _loadingState;

- (instancetype)init{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.height = DSXRefreshFooterHeight;
        self.loadingState = DSXLoadingStateNormal;
        //self.hidden = YES;
        if (self.delegate && [self.delegate respondsToSelector:@selector(willStartLoading:)]) {
            [self.delegate willStartLoading:self];
        }
    }
    return self;
}

- (void)setLoadingState:(DSXLoadingState)loadingState{
    _loadingState = loadingState;
    switch (loadingState) {
        case DSXLoadingStateNormal:
            self.textLabel.text = DSXLoadingStateNormalText;
            break;
        case DSXLoadingStateWillLoading:
            self.textLabel.text = DSXLoadingStateWillLoadingText;
            break;
        case DSXLoadingStateLoading:
            self.textLabel.text = DSXLoadingStateLoadingText;
            break;
        case DSXLoadingStateNoMoreData:
            self.textLabel.text = DSXLoadingStateNoMoreDataText;
            break;
        default:
            break;
    }
    [self.textLabel sizeToFit];
}

- (void)beginLoading{
    _isLoading = YES;
    self.loadingState = DSXLoadingStateLoading;
    [self.indicatorView startAnimating];
    UIEdgeInsets inset = self.scrollView.contentInset;
    inset.bottom = DSXRefreshFooterHeight + 10;
    self.scrollView.contentInset = inset;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(didStartLoading:)]) {
            [self.delegate didStartLoading:self];
        }
        [self endLoading];
    });
}

- (void)endLoading{
    _isLoading = NO;
    [self.indicatorView stopAnimating];
    self.loadingState = DSXLoadingStateNormal;
    [UIView animateWithDuration:0.3f animations:^{
       self.scrollView.contentInset = self.scrollViewOriginInset;
    }];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didEndLoading:)]) {
        [self.delegate didEndLoading:self];
    }
}

- (void)setDelegate:(id<DSXRefreshDelegate>)delegate{
    [super setDelegate:delegate];
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    if (self.loadingState == DSXLoadingStateWillLoading) {
        self.loadingState = DSXLoadingStateLoading;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.textLabel sizeToFit];
    self.textLabel.frame = CGRectMake(0, 0, self.scrollView.width, self.height);
    self.indicatorView.position  = CGPointMake(self.width/2 - 90, (self.height - self.indicatorView.height)/2);
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    if (newSuperview) {
        self.originY = self.scrollView.contentSize.height;
    }
}

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change{
    [super scrollViewContentSizeDidChange:change];
    self.originY = self.scrollView.contentSize.height;
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change{
    [super scrollViewContentOffsetDidChange:change];
    if (self.loadingState == DSXLoadingStateLoading || self.loadingState == DSXLoadingStateNoMoreData || self.originY == 0) {
        return;
    }
    
    if (self.scrollView.contentInset.top + self.scrollView.contentSize.height > self.scrollView.height) {
        if (self.scrollView.isDragging) {
            CGFloat height = self.scrollView.height + self.scrollView.contentOffset.y - self.scrollView.contentSize.height - self.scrollView.contentInset.bottom;
            if (height > (DSXRefreshFooterHeight + 20) && self.loadingState == DSXLoadingStateNormal) {
                CGPoint newPoint = [[change objectForKey:@"new"] CGPointValue];
                CGPoint oldPoint = [[change objectForKey:@"old"] CGPointValue];
                if (newPoint.y <= oldPoint.y) return;
                self.loadingState = DSXLoadingStateWillLoading;
            }else {
                return;
            }
        }else if(self.loadingState == DSXLoadingStateWillLoading){
            [self beginLoading];
        }
        
    }
}

@end
