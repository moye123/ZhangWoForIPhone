//
//  DSXPullUpView.m
//  XiangBaLao
//
//  Created by Apple on 15/12/29.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "DSXPullUpView.h"

@implementation DSXPullUpView
@synthesize textLabel = _textLabel;
@synthesize indicatorView = _indicatorView;

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicatorView.hidden = YES;
        [self addSubview:_indicatorView];
        
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:14.0];
        _textLabel.textColor = [UIColor grayColor];
        [self addSubview:_textLabel];
        [self endLoading];
    }
    return self;
}

- (void)beginLoading{
    [_indicatorView setHidden:NO];
    [_indicatorView startAnimating];
    [_textLabel setText:@"正在加载更多..."];
    [self reloadLayout];
}

- (void)endLoading{
    [_indicatorView setHidden:YES];
    [_indicatorView stopAnimating];
    [_textLabel setText:@"上拉加载更多"];
    [self reloadLayout];
}

- (void)reloadLayout{
    [_textLabel sizeToFit];
    CGRect frame = _textLabel.frame;
    frame.origin.x = (self.frame.size.width-_textLabel.frame.size.width)/2;
    frame.origin.y = (self.frame.size.height-_textLabel.frame.size.height)/2;
    _textLabel.frame = frame;
    
    frame.origin.x-= 30;
    frame.origin.y = self.frame.size.height/2-15;
    frame.size.width = 30;
    frame.size.height = 30;
    _indicatorView.frame = frame;
}

@end
