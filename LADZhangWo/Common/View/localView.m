//
//  localView.m
//  LADLihuibao
//
//  Created by Apple on 15/11/10.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "localView.h"

@implementation localView
@synthesize textLabel = _textLabel;
@synthesize imageView = _imageView;

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, frame.size.height)];
        _textLabel.text = @"六盘水";
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.font = [UIFont systemFontOfSize:14.0];
        _textLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_textLabel];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(45, 6.5, 16, 16)];
        _imageView.image = [UIImage imageNamed:@"icon-arrow-down.png"];
        [self addSubview:_imageView];
    }
    return self;
}

@end