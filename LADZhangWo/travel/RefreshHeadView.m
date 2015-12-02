//
//  RefreshHeadView.m
//  LADLihuibao
//
//  Created by Apple on 15/11/1.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "RefreshHeadView.h"

@implementation RefreshHeadView
@synthesize indicatorView;
@synthesize textLabel;
@synthesize imageView;

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.indicatorView.frame = CGRectMake((frame.size.width-130)/2, 0, 30, 30);
        [self.indicatorView startAnimating];
        [self addSubview:self.indicatorView];
        
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake((frame.size.width-130)/2+32, 7, 100, 20)];
        self.textLabel.text = @"正在加载...";
        self.textLabel.textColor = [UIColor grayColor];
        self.textLabel.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:self.textLabel];
    }
    return self;
}

@end
