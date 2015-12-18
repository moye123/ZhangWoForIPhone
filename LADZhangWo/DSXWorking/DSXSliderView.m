//
//  DSXSliderView.m
//  LADLihuibao
//
//  Created by Apple on 15/11/12.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "DSXSliderView.h"

@implementation DSXSliderView
@synthesize groupid = _groupid;
@synthesize num = _num;
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
        _scrollView.bounces = NO;
        [self addSubview:_scrollView];
        
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height-30, self.frame.size.width, 20)];
        [_pageControl addTarget:self action:@selector(pageControlClick:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_pageControl];
    }
    return self;
}

- (void)loaddata{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:[SITEAPI stringByAppendingFormat:@"&mod=homepage&ac=showlist&groupid=%ld&num=%ld",(long)_groupid,(long)_num] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        id array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([array isKindOfClass:[NSArray class]]) {
            for (UIView *subview in _scrollView.subviews) {
                [subview removeFromSuperview];
            }
            CGFloat x = 0;
            _slideData = [NSMutableDictionary dictionary];
            for (NSDictionary *dict in array) {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, self.frame.size.width, self.frame.size.height)];
                [imageView sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"pic"]]];
                [imageView setContentMode:UIViewContentModeScaleToFill];
                [imageView setTag:[[dict objectForKey:@"id"] integerValue]];
                [_scrollView addSubview:imageView];
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTap:)];
                [imageView addGestureRecognizer:tap];
                [imageView setUserInteractionEnabled:YES];
                x+= self.frame.size.width;
                [_slideData setObject:dict forKey:[dict objectForKey:@"id"]];
            }
            _scrollView.contentSize = CGSizeMake(self.frame.size.width*[_slideData count], 0);
            _pageControl.numberOfPages = [_slideData count];
            [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(autoPlay) userInfo:nil repeats:YES];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (void)imageViewTap:(UITapGestureRecognizer *)tap{
    NSDictionary *dict = [_slideData objectForKey:[NSString stringWithFormat:@"%ld",(long)tap.view.tag]];
    if ([_delegate respondsToSelector:@selector(slideView:touchedImageWithDataID:idType:)]) {
        NSInteger dataID = [[dict objectForKey:@"dataid"] integerValue];
        NSString *idType = [dict objectForKey:@"idtype"];
        [_delegate slideView:self touchedImageWithDataID:dataID idType:idType];
    }
}

- (void)pageControlClick:(UIPageControl *)sender{
    CGFloat x = sender.currentPage * self.frame.size.width;
    [self.scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
}

- (void)autoPlay{
    NSInteger index = _pageControl.currentPage;
    index++;
    if (index >= _pageControl.numberOfPages) {
        index = 0;
    }
    _pageControl.currentPage = index;
    [_scrollView setContentOffset:CGPointMake(self.frame.size.width*index, 0) animated:YES];
}

#pragma mark - scrollView delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = self.scrollView.contentOffset.x/self.frame.size.width;
    self.pageControl.currentPage = index;
}

@end
