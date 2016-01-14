//
//  LHBPullUpView.m
//  LADLihuibao
//
//  Created by Apple on 15/11/2.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "ZWPullUpView.h"

@implementation ZWPullUpView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.text = @"上拉加载更多";
        self.textColor = [UIColor grayColor];
        self.font = [UIFont systemFontOfSize:14.0];
        self.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)beginLoading{
    self.text = @"正在加载更多..";
}
- (void)endLoading{
    self.text = @"上拉加载更多";
}

@end
