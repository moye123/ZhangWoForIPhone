//
//  NewsSliderView.h
//  LADZhangWo
//
//  Created by Apple on 16/1/23.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NewsSliderView;
@protocol NewsSliderViewDelegate <NSObject>
@optional
- (void)newsSliderView:(NewsSliderView *)sliderView didClickedAtImageView:(UIImageView *)imageView data:(NSDictionary *)data;

@end
@interface NewsSliderView : UIView<UIScrollViewDelegate>

- (instancetype)initWithFrame:(CGRect)frame;
@property(nonatomic)NSArray *dataList;
@property(nonatomic,readonly)UIPageControl *pageControl;
@property(nonatomic,readonly)UIScrollView *scrollView;
@property(nonatomic,assign)id<NewsSliderViewDelegate>delegate;

@end
