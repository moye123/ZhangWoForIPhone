//
//  DSXModalView.m
//  LADLihuibao
//
//  Created by Apple on 15/11/27.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "DSXModalView.h"

@implementation DSXModalView
@synthesize contentView = _contentView;

- (instancetype)init{
    self = [super init];
    if (self) {
        CGRect rect = [UIScreen mainScreen].bounds;
        self.frame = rect;
        self.hidden = YES;
        _modalView = [[UIView alloc] initWithFrame:rect];
        _modalView.backgroundColor = [UIColor blackColor];
        _modalView.alpha = 0.5;
        [self addSubview:_modalView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        [_modalView addGestureRecognizer:tap];
        [_modalView setUserInteractionEnabled:YES];
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, rect.size.height, rect.size.width, 200)];
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
        
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        [window addSubview:self];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    return self;
}

- (void)show{
    self.hidden = NO;
    CGRect frame = _contentView.frame;
    frame.origin.y = self.frame.size.height - frame.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        _contentView.frame = frame;
    }];
}

- (void)hide{
    CGRect frame = _contentView.frame;
    frame.origin.y = self.frame.size.height;
    [UIView animateWithDuration:0.2 animations:^{
        _contentView.frame = frame;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

@end
