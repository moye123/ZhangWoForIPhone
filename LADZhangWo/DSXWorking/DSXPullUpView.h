//
//  DSXPullUpView.h
//  XiangBaLao
//
//  Created by Apple on 15/12/29.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSXPullUpView : UIView
- (instancetype)initWithFrame:(CGRect)frame;
- (void)beginLoading;
- (void)endLoading;

@property(nonatomic,readonly)UILabel *textLabel;
@property(nonatomic,readonly)UIActivityIndicatorView *indicatorView;

@end
