//
//  NewsSliderView.m
//  LADZhangWo
//
//  Created by Apple on 16/1/23.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "NewsSliderView.h"
#import "UIImageView+WebCache.h"

@implementation NewsSliderView
@synthesize dataList    = _dataList;
@synthesize pageControl = _pageControl;
@synthesize scrollView  = _scrollView;
@synthesize delegate    = _delegate;

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
        
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.tintColor = [UIColor whiteColor];
        [self addSubview:_pageControl];
    }
    return self;
}

- (void)setDataList:(NSArray *)dataList{
    _dataList = dataList;
    for (UIView *subview in _scrollView.subviews) {
        [subview removeFromSuperview];
    }
    for (int i=0; i<[dataList count]; i++) {
        NSDictionary *dict = [dataList objectAtIndex:i];
        CGRect frame = CGRectMake(self.frame.size.width*i, 0, self.frame.size.width, self.frame.size.height);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"pic"]]];
        [imageView setContentMode:UIViewContentModeScaleToFill];
        [imageView setTag:i];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageOnClick:)];
        [imageView addGestureRecognizer:tap];
        [imageView setUserInteractionEnabled:YES];
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-40, frame.size.width, 40)];
        backView.backgroundColor = [UIColor blackColor];
        backView.alpha = 0.5;
        backView.opaque = YES;
        [imageView addSubview:backView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:backView.frame];
        titleLabel.font = [UIFont systemFontOfSize:14.0];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = [dict objectForKey:@"title"];
        [imageView addSubview:titleLabel];
        [_scrollView addSubview:imageView];
    }
    _pageControl.numberOfPages = [dataList count];
    _pageControl.center = CGPointMake(self.center.x, 20);
    _scrollView.contentSize = CGSizeMake(self.frame.size.width*[dataList count], 0);
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(autoPlay:) userInfo:nil repeats:YES];
}

- (void)autoPlay:(NSTimer *)timer{
    BOOL animate = YES;
    NSInteger index = _pageControl.currentPage;
    index++;
    if (index >= _pageControl.numberOfPages) {
        index = 0;
        animate = NO;
    }
    _pageControl.currentPage = index;
    [_scrollView setContentOffset:CGPointMake(self.frame.size.width*index, 0) animated:animate];
}

- (void)imageOnClick:(UITapGestureRecognizer *)tap{
    if ([_delegate respondsToSelector:@selector(newsSliderView:didClickedAtImageView:data:)]) {
        [_delegate newsSliderView:self didClickedAtImageView:(UIImageView *)tap.view data:[_dataList objectAtIndex:tap.view.tag]];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/self.frame.size.width;
    _pageControl.currentPage = index;
}

@end
