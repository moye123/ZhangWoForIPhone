//
//  ChaoshiReusableView.m
//  LADZhangWo
//
//  Created by Apple on 16/1/25.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ChaoshiReusableView.h"

@implementation ChaoshiReusableView
@synthesize text = _text;
@synthesize textLabel = _textLabel;

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width/2, 1)];
        _line.backgroundColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1];
        [self addSubview:_line];
        
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:16.0];
        _textLabel.textColor = [UIColor grayColor];
        _textLabel.backgroundColor = [UIColor whiteColor];
        [self addSubview:_textLabel];
    }
    return self;
}

- (void)setText:(NSString *)text{
    _text = text;
    _textLabel.text = text;
    [_textLabel sizeToFit];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGRect frame = _textLabel.frame;
    frame.origin.x = (self.frame.size.width-_textLabel.frame.size.width)/2;
    frame.origin.y = (self.frame.size.height-_textLabel.frame.size.height)/2;
    _textLabel.frame = frame;
    
    frame = _line.frame;
    frame.origin.x = (self.frame.size.width - _line.frame.size.width)/2;
    frame.origin.y = self.frame.size.height/2;
    _line.frame = frame;
}

@end
