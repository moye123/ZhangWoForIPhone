//
//  DSXSliderView.h
//  LADLihuibao
//
//  Created by Apple on 15/11/12.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHBCommon.h"
@protocol DSXSliderDelegate<NSObject>
@optional
- (void)picShouldTouchedWithTag:(NSInteger)tag;
@end

@interface DSXSliderView : UIView<UIScrollViewDelegate>

- (instancetype)initWithFrame:(CGRect)frame;

@property(nonatomic,strong)NSArray *picList;
@property(nonatomic,retain)UIScrollView *scrollView;
@property(nonatomic,retain)UIPageControl *pageControl;
@property(nonatomic,assign)id<DSXSliderDelegate> delegate;

@end
