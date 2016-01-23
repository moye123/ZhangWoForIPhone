//
//  LaunchView.m
//  LADZhangWo
//
//  Created by Apple on 16/1/22.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "LaunchView.h"

@implementation LaunchView
@synthesize dataList = _dataList;
@synthesize hideButton = _hideButton;
@synthesize pageControl = _pageControl;
@synthesize seconds = _seconds;
@synthesize scrollView = _scrollView;

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
        
        _hideButton = [[UIButton alloc] initWithFrame:CGRectMake((frame.size.width-120)/2, frame.size.height-140, 120, 40)];
        _hideButton.layer.cornerRadius = 5.0;
        _hideButton.layer.masksToBounds = YES;
        _hideButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _hideButton.layer.borderWidth = 0.8;
        _hideButton.backgroundColor = [UIColor clearColor];
        _hideButton.hidden = YES;
        [_hideButton setTitle:@"立即体验" forState:UIControlStateNormal];
        [_hideButton addTarget:self action:@selector(hide:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_hideButton];
        
        _waitLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width-60, 30, 40, 20)];
        _waitLabel.backgroundColor = [UIColor blackColor];
        _waitLabel.textAlignment = NSTextAlignmentCenter;
        _waitLabel.font = [UIFont systemFontOfSize:14.0];
        _waitLabel.alpha = 0.6;
        _waitLabel.textColor = [UIColor whiteColor];
        [self addSubview:_waitLabel];
        [self setSeconds:5];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView:)];
        tap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)setSeconds:(int)seconds{
    _seconds = seconds;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(waiting:) userInfo:nil repeats:YES];
}

- (void)setDataList:(NSArray *)dataList{
    _dataList = dataList;
    for (int i=0; i<[dataList count]; i++) {
        NSDictionary *dict = [dataList objectAtIndex:i];
        CGRect frame = CGRectMake(self.frame.size.width*i, 0, self.frame.size.width, self.frame.size.height);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        [imageView setImage:[UIImage imageNamed:[dict objectForKey:@"pic"]]];
        [imageView setContentMode:UIViewContentModeScaleToFill];
        [imageView setTag:i];
        [_scrollView addSubview:imageView];
        
        UITapGestureRecognizer *adTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ADImageTap:)];
        [imageView addGestureRecognizer:adTap];
        [imageView setUserInteractionEnabled:YES];
    }
    _pageControl.numberOfPages = [dataList count];
    _pageControl.center = CGPointMake(self.center.x, self.frame.size.height - 40);
    _scrollView.contentSize = CGSizeMake(self.frame.size.width*[dataList count], 0);
}

- (void)waiting:(NSTimer *)timer{
    if (_seconds < 1) {
        [timer invalidate];
        [self removeFromSuperview];
    }else {
        _waitLabel.text = [NSString stringWithFormat:@"0%d",_seconds];
    }
    _seconds--;
}

- (void)hideView:(UITapGestureRecognizer *)tap{
    [self removeFromSuperview];
}

- (void)ADImageTap:(UITapGestureRecognizer *)tap{
    if ([_delegate respondsToSelector:@selector(launchView:didClickAtItem:data:)]) {
        [_delegate launchView:self didClickAtItem:(UIImageView *)tap.view data:[_dataList objectAtIndex:tap.view.tag]];
    }
}

- (void)hide:(UIButton *)button{
    [self removeFromSuperview];
    if ([_delegate respondsToSelector:@selector(launchView:didClickAtButton:)]) {
        [_delegate launchView:self didClickAtButton:button];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/self.frame.size.width;
    _pageControl.currentPage = index;
    if (index == _pageControl.numberOfPages-1) {
        _hideButton.hidden = NO;
    }else {
        _hideButton.hidden = YES;
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    [_timer invalidate];
    [_waitLabel setHidden:YES];
}

@end
