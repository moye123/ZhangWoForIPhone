//
//  DSXSliderView.m
//  LADLihuibao
//
//  Created by Apple on 15/11/12.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "DSXSliderView.h"

@implementation DSXSliderView
@synthesize picList = _picList;
@synthesize scrollView;
@synthesize pageControl;
@synthesize touchDelegate;

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"0xd1d1d1"];
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.scrollView.pagingEnabled = YES;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.delegate = self;
        [self addSubview:self.scrollView];
        
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height-30, self.frame.size.width, 20)];
        [self.pageControl addTarget:self action:@selector(pageControlClick:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.pageControl];
    }
    return self;
}

- (void)setPicList:(NSArray *)picList{
    _picList = picList;
    [self loadData];
}

- (void)loadData{
    CGRect newFrame = self.frame;
    for (int i = 0; i < [_picList count]; i++) {
        newFrame.origin.x = self.frame.size.width * i;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:newFrame];
        imageView.tag = [[_picList[i] objectForKey:@"id"] intValue];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[_picList[i] objectForKey:@"pic"]]];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        [self.scrollView addSubview:imageView];
    }
    
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width * [_picList count], self.frame.size.height);
    self.pageControl.numberOfPages = [_picList count];
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
