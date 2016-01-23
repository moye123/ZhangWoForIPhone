//
//  LaunchView.h
//  LADZhangWo
//
//  Created by Apple on 16/1/22.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LaunchView;
@protocol LaunchViewDelegate <NSObject>
@optional
- (void)launchView:(LaunchView *)launchView didClickAtItem:(UIImageView *)imageView data:(NSDictionary *)data;
- (void)launchView:(LaunchView *)launchView didClickAtButton:(UIButton *)button;

@end

@interface LaunchView : UIView<UIScrollViewDelegate>{
    @private
    NSTimer *_timer;
    UILabel *_waitLabel;
}

- (instancetype)initWithFrame:(CGRect)frame;
@property(nonatomic)NSArray *dataList;
@property(nonatomic,readonly)UIButton *hideButton;
@property(nonatomic,readonly)UIPageControl *pageControl;
@property(nonatomic,readonly)UIScrollView *scrollView;
@property(nonatomic,assign)int seconds;
@property(nonatomic,assign)id<LaunchViewDelegate>delegate;

@end
