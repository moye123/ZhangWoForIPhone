//
//  DSXSliderView.m
//  LADLihuibao
//
//  Created by Apple on 15/11/12.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "DSXSliderView.h"

@implementation DSXSliderView
@synthesize imageViews = _imageViews;
@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
        
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height-30, self.frame.size.width, 20)];
        [_pageControl addTarget:self action:@selector(pageControlClick:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_pageControl];
    }
    return self;
}


- (void)setImageViews:(NSArray *)imageViews{
    _imageViews = imageViews;
    for (UIView *subview in _scrollView.subviews) {
        [subview removeFromSuperview];
    }
    CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    for (int i=0; i < [_imageViews count]; i++) {
        frame.origin.x = self.frame.size.width * i;
        [_imageViews[i] setFrame:frame];
        [_scrollView addSubview:_imageViews[i]];
    }
    _scrollView.contentSize = CGSizeMake(self.frame.size.width * [_imageViews count], self.frame.size.height);
    _pageControl.numberOfPages = [_imageViews count];
}

- (void)pageControlClick:(UIPageControl *)sender{
    CGFloat x = sender.currentPage * self.frame.size.width;
    [self.scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
}

#pragma mark - scrollView delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = self.scrollView.contentOffset.x/self.frame.size.width;
    self.pageControl.currentPage = index;
}

@end
