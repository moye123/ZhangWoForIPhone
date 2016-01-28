//
//  DSXSliderView.h
//  LADLihuibao
//
//  Created by Apple on 15/11/12.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"
@class DSXSliderView;
@protocol DSXSliderViewDelegate<NSObject>
@optional
- (void)DSXSliderView:(DSXSliderView *)sliderView didSelectedItemWithData:(NSDictionary *)data;
@end

@interface DSXSliderView : UIView<UIScrollViewDelegate>{
    @private
    NSArray *_dataList;
}

- (instancetype)initWithFrame:(CGRect)frame;
- (void)loaddata;

@property(nonatomic,assign)int groupid;
@property(nonatomic,assign)int num;
@property(nonatomic,readonly)UIScrollView *scrollView;
@property(nonatomic,retain)UIPageControl *pageControl;
@property(nonatomic,assign)id<DSXSliderViewDelegate>delegate;

@end
