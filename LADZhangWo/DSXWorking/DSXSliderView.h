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
- (void)slideView:(DSXSliderView *)slideView touchedImageWithDataID:(NSInteger)dataID idType:(NSString *)idType;
@end

@interface DSXSliderView : UIView<UIScrollViewDelegate>{
    @private
    NSMutableDictionary *_slideData;
}

- (instancetype)initWithFrame:(CGRect)frame;
- (void)loaddata;

@property(nonatomic,assign)int groupid;
@property(nonatomic,assign)int num;
@property(nonatomic,strong)NSArray *imageViews;
@property(nonatomic,readonly)UIScrollView *scrollView;
@property(nonatomic,retain)UIPageControl *pageControl;
@property(nonatomic,assign)id<DSXSliderViewDelegate>delegate;

@end
