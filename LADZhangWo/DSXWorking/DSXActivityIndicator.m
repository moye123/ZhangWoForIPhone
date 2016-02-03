//
//  DSXActivityIndicator.m
//  XiangBaLao
//
//  Created by Apple on 16/2/1.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "DSXActivityIndicator.h"
#import "UIView+Size.h"

@implementation DSXActivityIndicator
@synthesize title = _title;
@synthesize modalView = _modalView;
@synthesize loadingView = _loadingView;
@synthesize indicatorView = _indicatorView;
@synthesize textLabel = _textLabel;

- (instancetype)init{
    if (self = [super init]) {
        _window = [[[UIApplication sharedApplication] delegate] window];
        _modalView = [[UIView alloc] init];
        _modalView.backgroundColor = [UIColor blackColor];
        _modalView.alpha = 0.3;
        _modalView.opaque = YES;
        _modalView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [_window addSubview:_modalView];
        
        _loadingView = [[UIView alloc] init];
        _loadingView.hidden = YES;
        _loadingView.backgroundColor = [UIColor blackColor];
        _loadingView.layer.masksToBounds = YES;
        _loadingView.layer.cornerRadius = 5.0;
        
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [_indicatorView startAnimating];
        [_loadingView addSubview:_indicatorView];
        
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.font = [UIFont systemFontOfSize:14.0];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        [_loadingView addSubview:_textLabel];
        
        [_window addSubview:_loadingView];
        
    }
    return self;
}

+ (instancetype)sharedIndicator{
    static id instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.textLabel.text = title;
}

- (void)showViewWithTitle:(NSString *)title{
    self.title = title;
    self.textLabel.text = title;
    self.modalView.hidden = YES;
    self.loadingView.hidden = NO;
    [self layoutSubviews];
}

- (void)showModalViewWithTitle:(NSString *)title{
    self.title = title;
    self.modalView.hidden = NO;
    self.loadingView.hidden = NO;
    [self layoutSubviews];
}

- (void)hide{
    self.title = nil;
    self.modalView.hidden = YES;
    self.loadingView.hidden = YES;
}

- (void)layoutSubviews{
    self.modalView.size = CGSizeMake(_window.width, _window.height);
    if (self.title) {
        [self.textLabel sizeToFit];
        self.indicatorView.size = CGSizeMake(30, 30);
        self.loadingView.size = CGSizeMake(self.textLabel.width+30, self.textLabel.height+60);
        self.loadingView.center = _window.center;
        self.indicatorView.position = CGPointMake((self.loadingView.width-30)/2, 10);
        self.textLabel.position = CGPointMake(15, self.indicatorView.height+15);
    }else {
        self.loadingView.size = CGSizeMake(60, 60);
        self.loadingView.center = _window.center;
        self.indicatorView.frame = CGRectMake(5, 5, 50, 50);
    }
}

@end
