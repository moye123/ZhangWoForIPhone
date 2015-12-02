//
//  DSXSliderView.h
//  LADLihuibao
//
//  Created by Apple on 15/11/12.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSXSliderView : UIView<UIScrollViewDelegate>

- (instancetype)initWithFrame:(CGRect)frame;

@property(nonatomic,strong)NSArray *imageViews;
@property(nonatomic,retain)UIScrollView *scrollView;
@property(nonatomic,retain)UIPageControl *pageControl;

@end
